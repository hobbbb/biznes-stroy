package Admin::Bills;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;

get '/admin/bills/' => sub {
    my $p = {};

    $p->{bills} = [ database->quick_select('bills', { managers_id => vars->{loged}->{id} }, { order_by => { desc => 'id' } }) ];
    for (@{$p->{bills}}) {
        $_->{buyer} = database->quick_select('users', { id => $_->{buyers_id} });
    }

    template 'admin/bills.tpl', $p;
};

prefix '/admin/bill' => sub {
    ajax '/cart/' => sub {
        my $cart = _bill_get();
        return to_json($cart);
    };

    ajax '/add_product/' => sub {
        return unless params->{products_id};

        my $bills_id;

        my $product = database->quick_select('products', { id => params->{products_id}, enabled => 1 });
        if (%$product) {
            my $cart;
            if ($bills_id) {
                $cart = database->quick_select('bills', { managers_id => vars->{loged}->{id}, id => $bills_id });
            }
            else {
                $cart = database->quick_select('bills', { managers_id => vars->{loged}->{id}, status => 'current' });
            }

            if (defined $cart) { #-- Апдейт карточки
                $bills_id = $cart->{id};
                my $bills_product = database->quick_select('bills_products', { bills_id => $bills_id, products_id => $product->{id} });
                if (defined $bills_product) { #-- Товар существует
                    database->quick_update('bills_products',
                        { id => $bills_product->{id} },
                        { name => $product->{name}, quantity => $bills_product->{quantity} + 1, price => $product->{price} }
                    );
                }
                else { #-- Новый товар
                    database->quick_insert('bills_products',
                        { bills_id => $bills_id, products_id => $product->{id}, name => $product->{name}, quantity => 1, price => $product->{price} }
                    );
                }
            }
            else { #-- Новая карточка
                database->quick_insert('bills', { managers_id => vars->{loged}->{id}, status => 'current' });
                $bills_id = database->last_insert_id(undef, undef, undef, undef);
                database->quick_insert('bills_products',
                    { bills_id => $bills_id, products_id => $product->{id}, name => $product->{name}, quantity => 1, price => $product->{price} }
                );
            }
        }

        my $cart = _bill_get($bills_id);
        return to_json($cart);
    };

    ajax '/save/' => sub {
        my $bills_id = _bill_save(\%{params()});
        if ($bills_id) {
            my $cart = _bill_get($bills_id);
            return to_json($cart);
        }
    };

    ajax '/send/:bills_id/' => sub {
        my $cart = _bill_get(params->{bills_id});
        if ($cart->{buyers_id}) {
            $cart->{clean} = 1;

            my $body = engine('template')->apply_layout(
                engine('template')->apply_renderer('email/bill.tpl', $cart),
                {}, { layout => 'blank.tpl' }
            );

            my $email_to = "vars->{glob_vars}->{email}, $cart->{buyer}->{email}";
            func::email(
                to      => $email_to,
                subject => 'Счет',
                body    => $body,
            );

            # Переводим в ожидающие
            database->quick_update('bills',
                { managers_id => vars->{loged}->{id}, id => params->{bills_id} },
                { status => 'wait' }
            );
=c
            # Добавляем в заказы
            database->quick_insert('orders', {
                registered => func::now(),
                bills_id => params->{bills_id},
                status => 'wait',
                shipping => 'none',
                payment => 'cashless',
                users_id => vars->{loged}->{id},
                phone => $cart->{buyer}->{phone},
                fio => $cart->{buyer}->{fio},
                email => $cart->{buyer}->{email},
            });
=cut
            my $order_id = database->last_insert_id(undef, undef, undef, undef);
            # TODO: my $summary_buy = 0;
            for my $p (@{$cart->{products}}) {
                my $_product = {
                    orders_id   => $order_id,
                    products_id => $p->{products_id},
                    name        => $p->{name},
                    quantity    => $p->{quantity},
                    price       => $p->{price},
                };
                database->quick_insert('orders_products', $_product);
                # $summary_buy += $product->{price};
            }

            return 1;
        }
    };

    ajax '/del/:id/' => sub {
        my $bill = database->quick_select('bills', { managers_id => vars->{loged}->{id}, id => params->{id} });
        if ($bill->{id}) {
            database->quick_delete('bills', { id => $bill->{id} });
            database->quick_update('orders', { bills_id => $bill->{id} }, { bills_id => undef });
        }
        return 1;
    };

    get '/to_current/:bills_id/' => sub {
        if (params->{bills_id}) {
            database->quick_update('bills',
                { managers_id => vars->{loged}->{id}, status => 'current' },
                { status => 'stop' }
            );
            database->quick_update('bills',
                { managers_id => vars->{loged}->{id}, status => 'stop', id => params->{bills_id} },
                { status => 'current' }
            );
            redirect "http://". request->host ."/admin/bills/";
        }
    };

    post '/build/' => sub {
        my $error;

        my $bills_id = _bill_save(\%{params()});
        if ($bills_id) {
            my $cart = _bill_get($bills_id);
            if ($cart->{buyers_id} and @{$cart->{products}}) {
                set layout => 'blank.tpl';
                return template 'email/bill.tpl', $cart;
            }
            else {
                $error = 1;
            }
        }
        else {
            $error = 1;
        }

        halt 'Ah-ah-aaaa!' if $error;
    };

    get '/note/:slug/:id/' => sub {
        my $error;

        my $bill = database->quick_select('bills', { managers_id => vars->{loged}->{id}, id => params->{id} });
        if ($bill->{id}) {
            my $cart = _bill_get($bill->{id});
            if ($cart->{buyers_id}) {
                set layout => 'blank.tpl';
                if (params->{slug} eq 'invoice') {
                    return template 'admin/invoice.tpl', $cart;
                }
                elsif (params->{slug} eq 'delivery') {
                    return template 'admin/delivery_note.tpl', $cart;
                }
            }
            else {
                $error = 1;
            }
        }
        else {
            $error = 1;
        }

        halt 'Ah-ah-aaaa!' if $error;
    };
};

sub pay_bill {
    my %params = @_;

    if ($params{bills_id} =~ /^\d+$/) {
        return database->quick_update('bills', { id => $params{bills_id}, status => 'wait' }, { status => 'paid', comments => $params{comments} });
    }
}

sub _bill_save {
    my $params = shift;

    if ($params->{bills_id} =~ /^\d+$/) {
        my $cart = { date => $params->{date}, buyers_id => $params->{buyers_id} };
        $cart->{status}   = $params->{status} if $params->{status};
        $cart->{delivery} = $params->{delivery} if $params->{delivery};
        $cart->{delivery_by_positions} = $params->{delivery_by_positions};

        database->quick_update('bills', { managers_id => vars->{loged}->{id}, id => $params->{bills_id} }, $cart);

        if ($params->{products_id}) {
            my $products_id = ref $params->{products_id} eq 'ARRAY' ? $params->{products_id} : [ $params->{products_id} ];
            if (scalar @$products_id) {
                map { return unless /^\d+$/ } @$products_id;

                database->quick_delete('bills_products', "bills_id = $params->{bills_id} AND products_id NOT IN (" . join(',', @$products_id) . ")");

                for my $p_id (@$products_id) {
                    my $product = database->quick_select('products', { id => $p_id, enabled => 1 });
                    if (defined $product and $params->{"qnt_$p_id"}) {
                        database->quick_update('bills_products',
                            { bills_id => $params->{bills_id}, products_id => $p_id },
                            { name => $product->{name}, quantity => $params->{"qnt_$p_id"}, price => $product->{price} }
                        );
                    }
                    else {
                        database->quick_delete('bills_products', { bills_id => $params->{bills_id}, products_id => $p_id });
                    }
                }
            }
        }

        return $params->{bills_id};
    }
}

sub _bill_get {
    my $bills_id = shift;

    my $cart;

    if ($bills_id) {
        $cart = database->quick_select('bills', { managers_id => vars->{loged}->{id}, id => $bills_id }) || {};
    }
    else {
        $cart = database->quick_select('bills', { managers_id => vars->{loged}->{id}, status => 'current' }) || {};
    }

    if (%$cart) {
        return {} if $cart->{status} ne 'current';

        $cart->{products} = [ database->quick_select('bills_products', { bills_id => $cart->{id} }) ];
        $cart->{order} = database->quick_select('orders', { bills_id => $cart->{id} });

        if ($cart->{buyers_id}) {
            $cart->{buyer} = database->quick_select('users', { id => $cart->{buyers_id} });
        }
    }

    return $cart;
}

true;
