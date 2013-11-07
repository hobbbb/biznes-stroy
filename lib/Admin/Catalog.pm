package Admin::Catalog;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;

my $categories_dir = path(config->{public}, 'upload', 'categories');
my $products_dir = path(config->{public}, 'upload', 'products');

prefix '/admin/catalog' => sub {
    post '/move_to_category/' => sub {
        if (params->{category} =~ /^\d+$/) {
            my $cat = params->{category};
            if (params->{categories}) {
                database->quick_update('categories', { id => [ split(/,/, params->{categories}) ] }, { parent_id => $cat });
            }
            if (params->{products}) {
                database->quick_update('products', { id => [ split(/,/, params->{products}) ] }, { categories_id => $cat });
            }
            redirect "http://". request->host ."/admin/catalog/$cat/";
        }
    };

    get qr{/(\d+)?/?} => sub {
        my ($parent_id) = splat;
        my $p = {};

        $p->{parent_id} = $parent_id || 0;
        $p->{categories} = [ database->quick_select('categories', { parent_id => $p->{parent_id} }, { order_by => 'sort' }) ];
        for (@{$p->{categories}}) {
            $_->{categories_cnt} = database->selectrow_array('SELECT count(*) FROM categories WHERE parent_id = ?', undef, $_->{id});
            $_->{products_cnt} = database->selectrow_array('SELECT count(*) FROM products WHERE categories_id = ?', undef, $_->{id});
        }
        $p->{products} = [ database->quick_select('products', { categories_id => $p->{parent_id} }, { order_by => 'sort' }) ];
        $p->{breadcrumbs} = _breadcrumbs($parent_id);

        $p->{tree} = BiznesShop::categories_tree();
        template 'admin/catalog.tpl', $p;
    };
};

prefix '/admin/categories' => sub {
    any ['get', 'post'] => '/add/' => sub {
        my $p = { parent_id => params->{parent_id} };
        if (request->method() eq 'POST') {
            ($p->{form}, $p->{err}) = _check_category(\%{params()});

            delete $p->{form}->{image};
            unless (scalar keys %{$p->{err}}) {
                $p->{form}->{seo_url} ||= func::make_alias($p->{form}->{name});
                database->quick_insert('categories', $p->{form});
                my $id = database->last_insert_id(undef, undef, undef, undef);
                my $file = Admin::fUpload(
                    dir => $categories_dir,
                    id  => $id,
                );
                database->quick_update('categories', { id => $id }, { image => $file }) if $file;
                redirect "http://". request->host ."/admin/catalog/$p->{form}->{parent_id}/";
            }
        }
        $p->{tree} = BiznesShop::categories_tree();
        template 'admin/categories.tpl', $p;
    };

    any ['get', 'post'] => '/edit/:id/' => sub {
        my $p = {};
        my $category = database->quick_select('categories', { id => params->{id} });
        if ($category->{id}) {
            if (request->method() eq 'POST') {
                ($p->{form}, $p->{err}) = _check_category(\%{params()});

                if (scalar keys %{$p->{err}}) {
                    $p->{form}->{image} = $category->{image};
                }
                else {
                    $p->{form}->{image} = Admin::fUpload(
                        dir      => $categories_dir,
                        id       => $category->{id},
                        del      => $category->{image},
                        only_del => param('del_image'),
                    );
                    delete $p->{form}->{image} unless defined $p->{form}->{image};
                    database->quick_update('categories', { id => $category->{id} }, $p->{form});

                    if (exists $p->{form}->{middle_sum} or exists $p->{form}->{retail_sum}) {
                        my $categories = _all_sub_categories($category->{id});
                        my $where = scalar @$categories ? { id => $categories } : {};
                        database->quick_update('categories', $where, {
                            middle_sum      => $p->{form}->{middle_sum},
                            middle_percent  => $p->{form}->{middle_percent},
                            retail_sum      => $p->{form}->{retail_sum},
                            retail_percent  => $p->{form}->{retail_percent},
                        });
                    }

                    redirect "http://". request->host ."/admin/catalog/$category->{parent_id}/";
                }
            }
            else {
                $p->{form} = $category;
            }
        }
        $p->{tree} = BiznesShop::categories_tree();
        template 'admin/categories.tpl', $p;
    };

    ajax '/del/:id/' => sub {
        return unless vars->{loged}->{acs}->{admin};

        my $p = {};
        my $category = database->quick_select('categories', { id => params->{id} });
        if ($category->{id}) {
            _del_category($category);
        }
        return 1;
    };

    ajax '/rearrange/' => sub {
        my $id = params->{'id[]'};
        my $i = 1;
        for (@$id) {
            database->quick_update('categories', { id => $_ }, { sort => $i });
            $i++;
        }
    };
};

prefix '/admin/products' => sub {
    any ['get', 'post'] => '/add/' => sub {
        my $p = {
            categories_id => params->{categories_id},
            form => { enabled => 1 },
        };
        if (request->method() eq 'POST') {
            ($p->{form}, $p->{err}) = _check_product(\%{params()});

            unless (scalar keys %{$p->{err}}) {
                $p->{form}->{seo_url} ||= func::make_alias($p->{form}->{name});
                database->quick_insert('products', $p->{form});
                my $id = database->last_insert_id(undef, undef, undef, undef);
                for my $i (1..4) {
                    my $file = Admin::fUpload(
                        dir     => $products_dir,
                        id      => $id,
                        field   => "image_$i",
                        ind     => $i,
                    );
                    database->quick_insert('products_images', { products_id => $id, image => $file }) if $file;
                }
                redirect "http://". request->host ."/admin/catalog/$p->{form}->{categories_id}/";
            }
        }
        $p->{manufacturers} = [ database->quick_select('manufacturers', {}) ];
        $p->{tree} = BiznesShop::categories_tree();
        template 'admin/products.tpl', $p;
    };

    any ['get', 'post'] => '/edit/:id/' => sub {
        my $p = {};
        my $product = database->quick_select('products', { id => params->{id} });
        if ($product->{id}) {
            my $_images = [ database->quick_select('products_images', { products_id => $product->{id} }) ];
            my $images = [];
            for (@$_images) {
                if ($_->{image} =~ /$product->{id}_(\d+)/) {
                    $images->[$1-1] = $_;
                }
            }

            if (request->method() eq 'POST') {
                ($p->{form}, $p->{err}) = _check_product(\%{params()});

                if (scalar keys %{$p->{err}}) {
                    for (@$images) {
                        if ($_->{image} and $_->{image} =~ /^\d+_(\d+)\./) {
                            $p->{form}->{"image_$1"} = $_->{image};
                        }
                    }
                }
                else {
                    database->quick_update('products', { id => $product->{id} }, $p->{form});
                    for my $i (1..4) {
                        my $file = Admin::fUpload(
                            dir      => $products_dir,
                            id       => $product->{id},
                            del      => $images->[$i-1]->{image},
                            field    => "image_$i",
                            ind      => $i,
                            only_del => param("del_image_$i"),
                        );
                        if (defined $file) {
                            database->quick_delete('products_images', { id => $images->[$i-1]->{id} });
                            if ($file) {
                                database->quick_insert('products_images', { products_id => $product->{id}, image => $file });
                            }
                        }
                    }
                    redirect "http://". request->host ."/admin/catalog/$product->{categories_id}/";
                }
            }
            else {
                $p->{form} = $product;
                for (@$images) {
                    if ($_->{image} and $_->{image} =~ /^\d+_(\d+)\./) {
                        $p->{form}->{"image_$1"} = $_->{image};
                    }
                }
            }
        }
        $p->{manufacturers} = [ database->quick_select('manufacturers', {}) ];
        $p->{tree} = BiznesShop::categories_tree();
        template 'admin/products.tpl', $p;
    };

    ajax '/del/:id/' => sub {
        return unless vars->{loged}->{acs}->{admin};

        my $p = {};
        my $product = database->quick_select('products', { id => params->{id} });
        if ($product->{id}) {
            delete_product($product->{id});
        }
        return 1;
    };

    any ['get', 'post'] => '/all/' => sub {
        my $p = { action => 'all' };
        $p->{categories_id} = (defined params->{categories_id} and params->{categories_id} =~ /^\d+$/) ? params->{categories_id} : undef;

        if (request->method() eq 'POST') {
            my $ids = params->{id};
            for my $id (@$ids) {
                my $product = {};
                for my $f (qw/price article short_descr/) {
                    $product->{$f} = params->{"$f\_$id"};
                }
                $product->{name} = func::trim(params->{"name_$id"});
                $product->{enabled} = params->{"enabled_$id"} ? 1 : 0;
                $product->{yandex_market} = params->{"yandex_market_$id"} ? 1 : 0;
                database->quick_update('products', { id => $id }, $product);
            }
        }

        if (defined $p->{categories_id}) {
            my $categories = _all_sub_categories($p->{categories_id});
            my $where = scalar @$categories ? { categories_id => $categories } : {};
            $p->{products} = [ database->quick_select('products', $where) ];
        }

        $p->{tree} = BiznesShop::categories_tree();
        template 'admin/products.tpl', $p;
    };

    ajax '/rearrange/' => sub {
        my $id = params->{'id[]'};
        my $i = 1;
        for (@$id) {
            database->quick_update('products', { id => $_ }, { sort => $i });
            $i++;
        }
    };
};

sub _check_category {
    my $params = shift;
    my ($form, $err) = ({},{});

    for (qw/parent_id enabled name descr image middle_sum middle_percent retail_sum retail_percent
            seo_url seo_title seo_keywords seo_description/
    ) {
        $form->{$_} = $params->{$_} if exists $params->{$_};
    }
    $form->{enabled} = $form->{enabled} ? 1 : 0;
    $form->{name}    = func::trim($form->{name});
    $form->{seo_url} = func::trim($form->{seo_url});

    for my $t (qw/middle retail/) {
        for (qw/sum percent/) {
            $form->{"$t\_$_"} = undef if exists $params->{"$t\_$_"} and !$params->{"$t\_$_"};
        }
        if (exists $form->{"$t\_sum"} and $form->{"$t\_sum"} and $form->{"$t\_sum"} !~ /^\d{1,8}(\.\d{1,2})?$/) {
            $err->{"$t\_sum"} = 1;
            next;
        }
        if (exists $form->{"$t\_percent"} and $form->{"$t\_percent"} and
                ($form->{"$t\_percent"} !~ /^\d+$/ or $form->{"$t\_percent"} < 0 or $form->{"$t\_percent"} > 100)
        ) {
            $err->{"$t\_percent"} = 1;
            next;
        }
        if (($form->{"$t\_sum"} and !$form->{"$t\_percent"}) or (!$form->{"$t\_sum"} and $form->{"$t\_percent"})) {
            $err->{"$t\_sum"} = 1;
        }
    }

    $err->{parent_id} = 1 if !exists $form->{parent_id} or $form->{parent_id} !~ /^\d+$/;
    $err->{name}      = 1 if length($form->{name}) < 3;
    $err->{image}     = 1 if $form->{image} and lc($form->{image}) !~ /(jpg|jpeg|png)$/;

    return ($form, $err);
}

sub _check_product {
    my $params = shift;
    my ($form, $err) = ({},{});

    for (qw/categories_id manufacturers_id enabled name short_descr descr detailed_chars price sale_price
        stock_discount stock_price hit special new article supplier seo_url seo_title seo_keywords seo_description
        yandex_market/
    ) {
        $form->{$_} = $params->{$_};
    }
    $form->{enabled}       = $form->{enabled} ? 1 : 0;
    $form->{price}       ||= 0;
    $form->{hit}           = $form->{hit} ? 1 : undef;
    $form->{special}       = $form->{special} ? 1 : undef;
    $form->{new}           = $form->{new} ? 1 : undef;
    $form->{sale_price}  ||= undef;
    $form->{name}          = func::trim($form->{name});
    $form->{seo_url}       = func::trim($form->{seo_url});
    $form->{yandex_market} = $form->{yandex_market} ? 1 : undef;

    if ($params->{stock_till_date} =~ /^\d{4}\-\d{2}\-\d{2}$/ and $params->{stock_till_hour} =~ /^\d{2}$/ and $params->{stock_till_min} =~ /^\d{2}$/) {
        $form->{stock_till} = "$params->{stock_till_date} $params->{stock_till_hour}:$params->{stock_till_min}";
    }
    else {
        $err->{stock_till} = 1;
    }

    $err->{categories_id}    = 1 if $form->{categories_id} !~ /^\d+$/;
    $err->{manufacturers_id} = 1 if $form->{manufacturers_id} and $form->{manufacturers_id} !~ /^\d+$/;
    $err->{name}             = 1 if length($form->{name}) < 3;
    $err->{price}            = 1 if $form->{price} !~ /^\d{1,8}(\.\d{1,2})?$/;
    $err->{sale_price}       = 1 if $form->{sale_price} and $form->{sale_price} !~ /^\d{1,8}(\.\d{1,2})?$/;
    $err->{stock_discount}   = 1 if $form->{stock_discount} and $form->{stock_discount} !~ /^\d{1,8}$/;
    $err->{stock_price}      = 1 if $form->{stock_price} and $form->{stock_price} !~ /^\d{1,8}(\.\d{1,2})?$/;

    return ($form, $err);
}

sub _breadcrumbs {
    my $parent_id = shift;

    my @bc = ();
    while ($parent_id) {
        my $category = database->quick_select('categories', { id => $parent_id });
        push @bc, $category;
        $parent_id = $category->{parent_id};
    }
    @bc = reverse @bc;

    return \@bc;
}

sub _all_sub_categories {
    my $parent_id = shift || 0;

    my $categories = [];
    push @$categories, $parent_id;

    my $cat = [ database->quick_select('categories', { parent_id => $parent_id }, { columns => [qw/id/] }) ];
    for (@$cat) {
        my $c = _all_sub_categories($_->{id});
        push @$categories, @$c if scalar @$c;
    }

    return $categories;
}

sub _del_category {
    my $category = shift;

    my $childs = [ database->quick_select('categories', { parent_id => $category->{id} }) ];

    if ($category->{image}) {
        unlink "$categories_dir/$category->{image}" if -f "$categories_dir/$category->{image}";
    }
    my $products = [ database->quick_select('products', { categories_id => $category->{id} }) ];
    for (@$products) {
        delete_product($_->{id});
    }
    database->quick_delete('categories', { id => $category->{id} });

    for (@$childs) {
        _del_category($_);
    }
}

sub delete_product {
    my $id = shift;

    my $images = [ database->quick_select('products_images', { products_id => $id }) ];
    for (@$images) {
        if ($_->{image}) {
            unlink "$products_dir/$_->{image}" if -f "$products_dir/$_->{image}";
        }
    }

    database->quick_delete('products', { id => $id });
    database->quick_delete('products_images', { products_id => $id });
}

true;
