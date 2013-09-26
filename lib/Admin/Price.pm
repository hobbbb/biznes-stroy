package Admin::Price;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;
use Spreadsheet::ParseExcel;
use Encode qw(decode encode);

my $cfg_path        = path(config->{public}, 'price.cfg');
my $categories_dir  = path(config->{public}, 'upload', 'categories');
my $products_dir    = path(config->{public}, 'upload', 'products');
my @db_fields = qw/id name worksheet start_row end_row overjump_row only_row
categories_name products_name stop_symbol products_price products_short_descr
main_category uniq change_products_price price_diff_koef supplier comments/;

prefix '/admin/price' => sub {
    any ['get', 'post'] => '/' => sub {
        my $vars = {};

        if (request->method() eq 'POST') {
            ($vars->{form}, $vars->{err}) = _check_cfg(\%{params()});

            unless (scalar keys %{$vars->{err}}) {
                # Сохранить конфиг
                if (params->{action} eq 'save') {
                    if ($vars->{form}->{id}) {
                        my $id = delete $vars->{form}->{id};
                        database->quick_update('cfg_for_price', { id => $id }, $vars->{form});
                        $vars->{form}->{id} = $id;
                    }
                    else {
                        delete $vars->{form}->{id};
                        database->quick_insert('cfg_for_price', $vars->{form});
                        $vars->{form}->{id} = database->last_insert_id(undef, undef, undef, undef);
                    }
                }
                # Распарсить
                elsif (params->{action} eq 'parse') {
                    my $CFG = $vars->{form};

                    # Поля товаров
                    my @fields = ('products_name', 'products_short_descr', 'products_price');

                    my $upload = upload('xls') or $vars->{err}->{xls} = 1;
                    my $xls = $upload->tempname unless $vars->{err}->{xls};
                    halt 'NEED *.xls FILE!!!' if $xls and $xls !~ /\.xls$/;

                    unless (scalar keys %{$vars->{err}}) {
                        $vars->{only_categories} = 1; # Парсим только категории [если не найдём ни одного товара]

                        # Выясняем всё про основную категорию
                        $vars->{main_category} = _check_category( id => $CFG->{main_category} );
                        halt 'NEED main_category' unless $vars->{main_category}->{name};

                        # Парсим прайс
                        if ($vars->{main_category}->{name}) {
                            my $parser = Spreadsheet::ParseExcel->new();
                            my $workbook = $parser->parse($xls) or halt $parser->error();
                            my $worksheet = $workbook->worksheet($CFG->{worksheet} - 1 || 0);

                            my @rows = ();
                            my ($row_min, $row_max) = $worksheet->row_range();
                            my $current_ROW = $CFG->{start_row} ? $CFG->{start_row} - 1 : $row_min;
                            my $end_ROW = $CFG->{end_row} ? $CFG->{end_row} - 1 : $row_max;

                            for my $i ($current_ROW .. $end_ROW) { # цикл по строкам таблицы
                                if ($CFG->{only_row}) {
                                    # Считываем только нужные строки
                                    my $jump_ROW = $i + 1;
                                    my $arr = _diap($CFG->{only_row});
                                    next unless ($CFG->{only_row} and grep(/^$jump_ROW$/, @$arr));
                                }
                                else {
                                    # Перепрыгиваем ненужные строки
                                    my $jump_ROW = $i + 1;
                                    my $arr = _diap($CFG->{overjump_row});
                                    next if ($CFG->{overjump_row} and grep(/^$jump_ROW$/, @$arr));
                                }

                                # Обрабатываем строку
                                my %row = (row => $i + 1);
                                for my $f (@fields, 'categories_name') {
                                    next unless $CFG->{$f};

                                    my @vals = ();
                                    for my $n (split /\s*\+\s*/, $CFG->{$f}) {
                                        # Для текста
                                        if ($n =~ m/'(.*?)'/) {
                                            my $txt = $1;
                                            $txt =~ s!<br>!\n!g;
                                            push @vals, $txt;
                                            next;
                                        }

                                        # Для номера колонки
                                        my $cell = $worksheet->get_cell($i, $n - 1);
                                        if ($cell) {
                                            my $v;
                                            if ($f eq 'products_price') {
                                                if ($cell->value() !~ /[А-Яа-яЁё]/) {
                                                    my $price = $cell->unformatted();
                                                    if ($CFG->{"change_$f"}) {
                                                        my $formula = $CFG->{"change_$f"};
                                                        $formula =~ s!$f!$price!g;
                                                        $price = eval $formula;
                                                    }
                                                    $v = sprintf('%.2f', $price) if $price;
                                                }
                                            }
                                            else {
                                                $v = func::trim($cell->value());
                                            }
                                            push @vals, $v if $v;
                                        }
                                    }
                                    $row{$f} = join('', @vals);
                                }
                                # Удаляем мусорные значения
                                if ($row{products_name} and $row{products_price}) {
                                    delete $row{categories_name};
                                    $vars->{only_categories} = 0;
                                }
                                else {
                                    delete @row{@fields};
                                }
                                # Создаём массив распарсенных строк
                                push @rows, \%row if ($row{categories_name} || $row{products_name});
                            }

                            my $i = 0;
                            for my $r (@rows) {
                                $i++;

                                if ($r->{categories_name}) { # Заполняются категории
                                    if ($rows[$i]->{categories_name} && !$vars->{only_categories}) {
                                        next;
                                    }

                                    my $cat = _check_category( name => $r->{categories_name} );
                                    $cat->{row} = $r->{row};
                                    push @{$vars->{categories_name}}, $cat;
                                }
                                elsif ($r->{products_name}) { # Заполняются товары
                                    my $last_cat = 0;
                                    if ($vars->{categories_name}) {
                                        $last_cat = scalar @{$vars->{categories_name}} - 1;
                                        $r->{categories_id} = $vars->{categories_name}->[$last_cat]->{id};
                                    }

                                    my $list = _check_product($CFG, $r);
                                    push @{$vars->{categories_name}->[$last_cat]->{products}}, @$list;
                                }
                            }

                            # Вытягиваем товары из базы из этих категорий, для возможного их удаления
                            for my $cat (@{$vars->{categories_name}}) {
                                if ($cat->{id}) {
                                    my @products = (0);
                                    for (@{$cat->{products}}) {
                                        push @products, $_->{id} if $_->{id};
                                    }

                                    my $exist = [ database->quick_select('products', "categories_id = $cat->{id} AND id NOT IN (" . join(',', @products) . ")") ];
                                    for my $e (@$exist) {
                                        my $img = database->quick_select('products_images', { products_id => $e->{id} }, { order_by => 'id', limit => 1 });
                                        push @{$cat->{products}}, {
                                            categories_id        => $cat->{id},
                                            products_price       => $e->{price},
                                            img                  => $img->{image},
                                            id                   => $e->{id},
                                            products_short_descr => $e->{short_descr},
                                            products_name        => $e->{name},
                                            from_db              => 1,
                                        };
                                    }
                                }
                            }

                            $vars->{manufacturers} = [ database->quick_select('manufacturers', {}) ];
                        }
                    }
                }
            }
        }

        $vars->{configs} = [ database->quick_select('cfg_for_price', {}) ];
        $vars->{tree} = BiznesStroy::categories_tree();

        template 'admin/price.tpl', $vars;
    };

    post '/update/' => sub {
        my @params = params;

        # Считываем все параметры по категориям
        my $hash = {};
        for (grep(/^category\.\d+\.id$/, @params)) {
            my $cid = (/^category\.(\d+)\.\w+$/)[0];

            for my $c (grep(/^category\.$cid\.\w+$/, @params)) {
                my $field = ($c =~ /^category\.$cid\.(\w+)$/)[0];
                $hash->{$cid}->{$field} = param($c);
                if ($field eq 'file') {
                    $hash->{$cid}->{file_field} = $c;
                }
            }

            for my $p (grep(/^$cid\.product\.\d+\.id/, @params)) {
                my $pid = ($p =~ /^$cid\.product\.(\d+)\.id/)[0];

                my $h = {};
                for (grep(/^$cid\.product\.$pid\./, @params)) {
                    my $field = (/^$cid\.product\.$pid\.(\w+)$/)[0];
                    my $v = param($_);
                    $v =~ s!\n!<br>!g;
                    $h->{$field} = $v;

                    if ($field eq 'file') {
                        $h->{file_field} = $_;
                    }
                }
                push @{$hash->{$cid}->{products}}, $h;
            }
        }

        # Если нет ни одной категории, то пробуем получить товары для категории 1
        unless (scalar keys %$hash) {
            my $cid = 1;

            for my $p (grep(/^$cid\.product\.\d+\.id/, @params)) {
                my $pid = ($p =~ /^$cid\.product\.(\d+)\.id/)[0];

                my $h = {};
                for (grep(/^$cid\.product\.$pid\./, @params)) {
                    my $field = (/^$cid\.product\.$pid\.(\w+)$/)[0];
                    my $v = param($_);
                    $v =~ s!\n!<br>!g;
                    $h->{$field} = $v;

                    if ($field eq 'file') {
                        $h->{file_field} = $_;
                    }
                }
                push @{$hash->{$cid}->{products}}, $h;
            }
        }

        # Обновление базы
        my $main_category = param('main_category_id');
        my $manufacturers_id = param('manufacturers_id');
        for my $k (keys %$hash) {
            my $el = $hash->{$k};
            if (param('update_price')) {
                for my $p (@{$el->{products}}) {
                    _update_price($p) if $p->{enabled};
                }
            }
            else {
                if ($el->{enabled}) {
                    my $categories_id = _upload_category($main_category, $el);
                    halt 'no $categories_id' unless $categories_id;

                    for my $p (@{$el->{products}}) {
                        if ($p->{enabled}) {
                            $p->{categories_id} = $categories_id;
                            $p->{manufacturers_id} = $manufacturers_id;
                            _upload_product($p);
                        }
                        elsif ($p->{delete}) {
                            Admin::Catalog::delete_product($p->{id});
                        }
                    }
                }
            }
        }
        redirect "http://". request->host ."/admin/price/";
    };

    ajax '/get_cfg/:id/' => sub {
        my $cfg = database->quick_select('cfg_for_price', { id => params->{id} });
        to_json($cfg);
    };
};

#============================================

sub _check_category {
    my %hash = @_;

    my $cat = {};
    if ($hash{name}) {
        $cat = database->quick_select('categories', { name => $hash{name} });
        $cat->{name} = $hash{name};
    }
    elsif ($hash{id}) {
        $cat = database->quick_select('categories', { id => $hash{id} });
        $cat->{id} = $hash{id};
    }
    return $cat;
}

sub _check_product {
    my ($cfg, $row) = @_;

    my %alias = (
        products_name => 'name',
    );

    my $where;
    for my $f (split/\+/, $cfg->{uniq}) {
        next unless $alias{$f};

        if ($cfg->{stop_symbol}) {
            # $where->{$alias{$f}} = { like => "$row->{$f}$cfg->{stop_symbol}%" };
            $where = "$alias{$f} LIKE " . database->quote("$row->{$f}$cfg->{stop_symbol}%") . " OR $alias{$f} = " . database->quote($row->{$f});
        }
        else {
            $where->{$alias{$f}} = $row->{$f};
        }
    }

    my @list = ();

    my $products = [ database->quick_select('products', $where) ];
    if (@$products) { # Совпадения в базе есть
        for my $p (@$products) {
            my $img = database->quick_lookup('products_images', { products_id => $p->{id} }, 'image', { order_by => 'id' });

            if ($row->{categories_id} and $p->{id}) {
                $p->{category_matched} = database->quick_lookup('products', { categories_id => $row->{categories_id}, id => $p->{id} }, 'id');
            }

            push @list, {
                id                   => $p->{id},
                price                => $p->{price},
                categories_id        => $p->{categories_id},
                category_matched     => $p->{category_matched},
                products_name        => $p->{name},
                img                  => $img,
                row                  => $row->{row},
                products_price       => $row->{products_price},
                products_short_descr => $row->{products_short_descr},
            };
        }
    }
    else {
        $row->{img} = database->quick_lookup('products_images', { products_id => $row->{id} }, 'image', { order_by => 'id' });

        if ($row->{categories_id} and $row->{id}) {
            $row->{category_matched} = database->quick_lookup('products', { categories_id => $row->{categories_id}, id => $row->{id} }, 'id');
        }

        push @list, $row;
    }

    return \@list;
}

sub _upload_category {
    my ($parent, $el) = @_;
    return unless $parent and $el->{name};

    unless ($el->{id}) {
        database->quick_insert('categories', {
            parent_id   => $parent,
            enabled     => 0,
            sort        => 0,
            name        => $el->{name},
            seo_url     => func::make_alias($el->{name}),

        });
        $el->{id} = database->last_insert_id(undef, undef, undef, undef);
    }

    if ($el->{id} and $el->{file}) {
        my $img = database->quick_lookup('categories', { id => $el->{id} }, 'image');
        my $file = Admin::fUpload(
            dir     => $categories_dir,
            id      => $el->{id},
            del     => $img,
            field   => $el->{file_field},
        );
        database->quick_update('categories', { id => $el->{id} }, { image => $file }) if $file;
    }
    return $el->{id};
}

sub _update_price {
    my $product = _product_alias(shift);
    return unless $product->{id} and $product->{price};

    database->quick_update('products', { id => $product->{id} }, { price => $product->{price} });
}

sub _upload_product {
    my $product = _product_alias(shift);

    if ($product->{id}) {
        my $data = {};
        for (qw(name price categories_id manufacturers_id short_descr supplier)) {
            $data->{$_} = $product->{$_} if $product->{$_};
        }
        unless (database->quick_lookup('products', { id => $product->{id} }, 'seo_url')) {
            $data->{seo_url} = func::make_alias($product->{name});
        }
        database->quick_update('products', { id => $product->{id} }, $data);
    }
    else {
        my $data = {
            sort    => 0,
            enabled => 1,
        };
        for (qw(name price categories_id manufacturers_id short_descr supplier)) {
            $data->{$_} = $product->{$_} if $product->{$_};
        }
        $data->{seo_url} = func::make_alias($data->{name}) if $data->{name};
        database->quick_insert('products', $data);
        $product->{id} = database->last_insert_id(undef, undef, undef, undef);
    }

    if ($product->{id} and $product->{file}) {
        my $img = database->quick_select('products_images', { products_id => $product->{id} }, { order_by => 'id', limit => 1 });
        my $ind = $img->{image} ? ($img->{image} =~ /^\d+_(\d+)\./)[0] : 1;
        my $file = Admin::fUpload(
            dir     => $products_dir,
            id      => $product->{id},
            del     => $img->{image},
            field   => $product->{file_field},
            ind     => $ind,
        );
        if (defined $file) {
            database->quick_delete('products_images', { id => $img->{id} });
            if ($file) {
                database->quick_insert('products_images', { products_id => $product->{id}, image => $file });
            }
        }
    }
}

sub _product_alias {
    my $product = shift;
    $product->{name}          = $product->{products_name};
    $product->{price}         = $product->{products_price};
    $product->{short_descr}   = $product->{products_short_descr};
    delete @$product{'products_name','products_price','products_short_descr'};

    return $product;
}

sub _diap {
    my @arr = ();
    for (split /,/, shift) {
        if (/^(\d+)\-(\d+)$/) {
            if ($1 < $2) {
                for my $_r ($1 .. $2) {
                    push @arr, $_r;
                }
            }
        }
        else {
            push @arr, $_;
        }
    }
    return \@arr;
}

sub _check_cfg {
    my $params = shift;
    my ($form, $err) = ({},{});

    for (@db_fields) {
        $form->{$_} = func::trim($params->{$_});
    }

    for (qw/name categories_name/) {
        $err->{$_} = 1 if length($form->{$_}) < 1;
    }

    for (qw/worksheet start_row main_category/) {
        $err->{$_} = 1 if $form->{$_} !~ /^\d+$/;
    }

    for (qw/end_row price_diff_koef/) {
        $err->{$_} = 1 if $form->{$_} and $form->{$_} !~ /^\d+$/;
    }

    for (qw/overjump_row only_row/) {
        $err->{$_} = 1 if $form->{$_} and $form->{$_} !~ /^(\d+([\-,](?!$))?)+$/;
    }

    return ($form, $err);
}

true;
