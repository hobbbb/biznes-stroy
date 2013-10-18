package Orders;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;
use File::Copy;

prefix '/shopping_cart' => sub {
    ajax '/add/:id/' => sub {
        my $cart = cookie 'cart';
        my $shopping_cart = from_json($cart) if $cart;
        my $product = database->quick_select('products', { enabled => 1, id => params->{id} });
        if ($product->{id}) {
            my $in_cart = 0;
            for (@$shopping_cart) {
                if ($_->{id} == params->{id}) {
                    $in_cart = 1;
                    $_->{qnt}++;
                    $_->{price} = func::product_price($product);
                }
            }
            unless ($in_cart) {
                push @$shopping_cart, {
                    id      => $product->{id},
                    qnt     => 1,
                    price   => func::product_price($product),
                }
            }
        }
        cookie cart => to_json($shopping_cart), expires => '1 year', http_only => 0;
    };

    ajax '/recalc/' => sub {
        my $shopping_cart = [];
        my $ids = ref(params->{id}) eq 'ARRAY' ? params->{id} : [params->{id}];
        for my $id (@$ids) {
            my $product = database->quick_select('products', { enabled => 1, id => $id });
            if ($product->{id} and params->{"qnt_$id"}) {
                push @$shopping_cart, {
                    id      => $id,
                    qnt     => params->{"qnt_$id"},
                    price   => func::product_price($product),
                }
            }
        }
        cookie cart => to_json($shopping_cart), expires => '1 year', http_only => 0;
    };

    any ['post', 'get'] => '/' => sub {
        my $p = {};

        if (request->method() eq 'POST') {
            ($p->{form}, $p->{err}) = _check_order(\%{params()});

            my $cart = cookie 'cart';
            my $shopping_cart = from_json($cart) if $cart;
            $p->{err}->{no_products} = 1 unless $shopping_cart and @$shopping_cart;

            unless (scalar keys %{$p->{err}}) {
                my $order = { data => $p->{form} };

                $p->{form}->{registered} = func::now();
                database->quick_insert('orders', $p->{form});
                $order->{data}->{id} = database->last_insert_id(undef, undef, undef, undef);

                my $summary_buy = 0;
                for my $cp (@$shopping_cart) {
                    my $product = database->quick_select('products', { enabled => 1, id => $cp->{id} });
                    my $_product = {
                        orders_id    => $order->{data}->{id},
                        products_id  => $cp->{id},
                        quantity     => $cp->{qnt},
                        price        => $cp->{price},
                        name         => $product->{name},
                    };
                    database->quick_insert('orders_products', $_product);

                    if ($product->{manufacturers_id}) {
                        $_product->{manufacturer} = database->quick_select('manufacturers', { id => $product->{manufacturers_id} });
                    }

                    push @{$order->{product_list}}, $_product;
                    $summary_buy += $cp->{price};
                }
                cookie cart => to_json([]), expires => '0', http_only => 0;

                my $file = _send_order($order, params->{file} ? 1 : 0);
                if ($file) {
                    database->quick_update('orders', { id => $order->{data}->{id} }, { file => $file });
                }

                if ($order->{data}->{users_id}) {
                    database->do('UPDATE users SET summary_buy = summary_buy + ? WHERE id = ?', undef, $summary_buy, $order->{data}->{users_id});
                }

                $p->{success} = 1;
                $p->{order} = $order;
            }
        }

        my $cart = cookie 'cart';
        my $shopping_cart = from_json($cart) if $cart;

        my $real_cart = [];
        for (@$shopping_cart) {
            my $product = database->quick_select('products', { enabled => 1, id => $_->{id} });
            if ($product) {
                $product->{qnt}   = $_->{qnt};
                $product->{price} = func::product_price($product);
                $product->{image} = database->quick_lookup('products_images', { products_id => $product->{id} }, 'image');
                push @{$p->{products}}, $product;
                push @$real_cart, $_;
            }
        }

        if (scalar @$real_cart) {
            cookie cart => to_json($real_cart), expires => '1 year', http_only => 0;
        }
        else {
            cookie cart => to_json([]), expires => '0', http_only => 0;
        }

        $p->{discount_program} = [ database->quick_select('discount_program', {}) ];
        template 'shopping_cart.tpl', $p;
    };
};

any ['post', 'get'] => '/cashless/' => sub {
    my $p = {};

    if (request->method() eq 'POST') {
        ($p->{form}, $p->{err}) = _check_order(\%{params()}, { products => 'check' });

        unless (scalar keys %{$p->{err}}) {
            my $order = { data => $p->{form} };
            $p->{form}->{registered} = func::now();
            database->quick_insert('orders', $p->{form});
            $order->{data}->{id} = database->last_insert_id(undef, undef, undef, undef);

            my $file = _send_order($order, params->{file} ? 1 : 0);
            if ($file) {
                database->quick_update('orders', { id => $order->{data}->{id} }, { file => $file });
            }

            $p->{success} = 1;
            $p->{order} = $order;
        }
    }

    template 'cashless.tpl', $p;
};


sub _check_order {
    my ($params, $opt) = @_;
    my ($form, $err) = ({},{});

    for (qw/shipping payment users_id phone fio email comments products discount file mkad/) {
        $form->{$_} = $params->{$_};
    }
    $form->{users_id} ||= 0;

    $err->{shipping} = 1 unless $form->{shipping};
    $err->{payment}  = 1 unless $form->{payment};
    $err->{phone}    = 1 if $form->{phone} !~ /^\d{10}$/;
    $err->{discount} = 1 if $form->{discount} and $form->{discount} !~ /^\d+(\.\d+)?$/;
    if (defined $opt and $opt->{products} eq 'check') {
        $err->{products} = 1 unless $form->{products};
    }
    $err->{file} = 1 if $form->{payment} eq 'cashless' and !$form->{file};
    $err->{mkad} = 1 if $form->{shipping} eq 'delivery_mkad' and $form->{mkad} !~ /^\d+$/;

    delete $form->{file};

    return ($form, $err);
}

sub _send_order {
    my ($order, $with_file) = @_;
    return unless $order;

    my $body = engine('template')->apply_layout(
        engine('template')->apply_renderer('email/order.tpl', { order => $order }),
        {}, { layout => 'blank.tpl' }
    );

    # Отправка заказа менеджеру
    my %letter = (
        to          => vars->{glob_vars}->{email},
        subject     => "Новый заказ (№ $order->{data}->{id})",
        body        => $body,
    );

    my $file;
    if ($with_file) {
        my $upload = upload('file');
        if ($upload) {
            my $zip = func::generate_light . '.zip';
            my $zip_path = "/tmp/$zip";
            `zip $zip_path $upload->{tempname}`;

            $file = $order->{data}->{id} . '.' . lc(($upload->basename =~ /\.(\w+)$/)[0]);
            move($upload->tempname, path(vars->{orders_dir}, $file));
            chmod 0664, path(vars->{orders_dir}, $file);

            $letter{attachment} = [{
                Disposition => 'attachment',
                Type        => 'AUTO',
                Path        => $zip_path,
                Filename    => $zip,
            }];
            $letter{attachment_delete} = 1;
        }
    }

    func::email(%letter);

    # Отправка заказа покупателю
    if ($order->{data}->{email}) {
        my %letter = (
            to          => $order->{data}->{email},
            subject     => "Вы сделали заказ",
            body        => $body,
        );
        func::email(%letter);
    }

    func::send_sms(
        phone   => $order->{data}->{phone},
        message => "Номер Вашего заказа - $order->{data}->{id}",
    );

    return $file;
}

true;
