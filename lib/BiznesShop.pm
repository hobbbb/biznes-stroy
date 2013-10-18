package BiznesShop;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Thumbnail;
use Dancer::Plugin::Ajax;
use func;
use XML::Simple;

load_app 'Users';
load_app 'Admin';
load_app 'Search';
load_app 'Orders';

hook before => sub {
    var orders_dir => path(config->{public}, 'upload', 'orders');

    if (params->{_openstat}) {
        cookie _openstat => 1, http_only => 0, expires => '1 month';
    }

    if (request->path_info =~ m!^/admin!) {
        set layout => 'admin.tpl';
    }
    else {
        set layout => 'main.tpl';
    }

    my $glob_vars = [ database->quick_select('glob_vars', {}) ];
    my $gb;
    for (@$glob_vars) {
        my @s = split /\./, $_->{name};
        if (scalar @s > 1) {
            $gb->{$s[0]}->{$s[1]} = $_->{val};
        }
        else {
            $gb->{$s[0]} = $_->{val};
        }
    }
    var glob_vars => $gb;

    var loged => Users::check_auth();
    Users::last_visit();
};

hook before_template_render => sub {
    my $tokens = shift;

    $tokens->{top_menu} = [ database->quick_select('top_menu', {}, { order_by => 'sort' }) ];
    $tokens->{categories_tree} = categories_tree(0, { enabled => 1 });

    $tokens->{footer_content_list} = [ database->quick_select('footer_content', { parent_id => 0 }, { order_by => 'sort' }) ];
    for (@{$tokens->{footer_content_list}}) {
        $_->{childs} = [ database->quick_select('footer_content', { parent_id => $_->{id} }, { order_by => 'sort' }) ];
    }

    # subs
    $tokens->{func} = {
        generate       => sub { func::generate($_[0]) },
        price_in_words => sub { func::price_in_words($_[0]) },
    };
};

get '/404/' => sub {
    status 'not_found';
    return template '404.tpl';
};

get '/' => sub {
    my $p = {};

    $p->{product_of_day} = database->selectrow_hashref('SELECT * FROM products WHERE enabled = 1 AND price > 0 AND stock_till > NOW()  ORDER BY RAND() LIMIT 1');
    unless ($p->{product_of_day}) {
        $p->{product_of_day} = database->selectrow_hashref('SELECT * FROM products WHERE enabled = 1 AND price > 0 ORDER BY RAND() LIMIT 1');
        $p->{product_of_day}->{stock_till} = undef;
    }
    $p->{product_of_day}->{image} = database->quick_lookup('products_images', { products_id => $p->{product_of_day}->{id} }, 'image');

    $p->{banners_list} = [ database->quick_select('banners', {}, { order_by => 'sort' }) ];
    $p->{biznes_stroy_list} = [ database->quick_select('biznes_stroy', {}) ];
    $p->{manufacturers_list} = [ database->quick_select('manufacturers', {}) ];

    $p->{hit_list} = [ database->quick_select('products', { hit => 1, enabled => 1 }, { limit => 4 }) ];
    func::products_get_image($p->{hit_list});
    $p->{special_list} = [ database->quick_select('products', { special => 1, enabled => 1 }, { limit => 4 }) ];
    func::products_get_image($p->{special_list});
    $p->{new_list} = [ database->quick_select('products', { new => 1, enabled => 1 }, { limit => 4 }) ];
    func::products_get_image($p->{new_list});

    return template 'index.tpl', $p;
};

get '/content/:id/' => sub {
    my $p = {};
    my $content = database->quick_select('content', { id => params->{id} });
    return redirect '/404/' if $content->{alias} and $content->{alias} eq 'admin';

    if ($content) {
        $p->{content} = $content;
        $p->{content}->{descr} =~ s/(\$\{\w+\})/_content_vars($1)/ge; # Заменяем переменные
        $p->{seo_title} = $p->{content}->{seo_title} || $p->{content}->{name};
        $p->{seo_keywords} = $p->{content}->{seo_keywords};
        $p->{seo_description} = $p->{content}->{seo_description};

        my $content_products = [
            database->quick_select('content_products', { content_id => $p->{content}->{id} }, { columns => [qw(products_id)] })
        ];
        if (scalar @$content_products) {
            my $filters = _products_filters(\%{params()});
            $p = { %$p, %{$filters->{tpl}} };
            $p->{products} = [ database->quick_select('products',
                { %{$filters->{where}}, enabled => 1, id => [ map { $_->{products_id} } @$content_products ] },
                $filters->{opts}
            ) ];
            func::products_get_image($p->{products});
        }
    }

    return template 'content.tpl', $p;
};

get '/footer_content/:id/' => sub {
    my $p = {};

    my $content = database->quick_select('footer_content', { id => params->{id} });
    if ($content) {
        $p->{content} = $content;
        $p->{content}->{descr} =~ s/(\$\{\w+\})/_content_vars($1)/ge; # Заменяем переменные
    }

    return template 'content.tpl', $p;
};

get '/categories/:slug/' => sub {
    my $p = {};

    my $filters = _products_filters(\%{params()});
    $p = { %$p, %{$filters->{tpl}} };

    if (params->{slug} =~ /^\d+$/) {
        $p->{category} = database->quick_select('categories', { enabled => 1, id => params->{slug} });
        send_error("Not found", 404) unless $p->{category};

        $p->{breadcrumbs}       = _categories_bread_crumbs($p->{category});
        $p->{seo_title}         = $p->{category}->{seo_title} || $p->{category}->{name};
        $p->{seo_keywords}      = $p->{category}->{seo_keywords};
        $p->{seo_description}   = $p->{category}->{seo_description};

        $p->{categories} = [ database->quick_select('categories', { enabled => 1, parent_id => $p->{category}->{id} }, { order_by => 'sort' }) ];
        unless (scalar @{$p->{categories}}) {
            $p->{products} = [ database->quick_select('products',
                { %{$filters->{where}}, enabled => 1, categories_id => $p->{category}->{id} },
                $filters->{opts}
            ) ];
            func::products_get_image($p->{products});
        }
    }
    elsif (params->{slug} eq 'sale') {
        $p->{products}  = [ database->quick_select('products', { enabled => 1, sale_price => { 'gt' => 0 } }, $filters->{opts}) ];
        func::products_get_image($p->{products});

        $p->{category}->{name} = 'Распродажа';
        push @{$p->{breadcrumbs}}, { name => 'Распродажа' };
    }
    elsif (params->{slug} eq 'hits') {
        $p->{products}  = [ database->quick_select('products', { hit => 1, enabled => 1 }, $filters->{opts}) ];
        func::products_get_image($p->{products});

        $p->{category}->{name} = 'Лидеры продаж';
        push @{$p->{breadcrumbs}}, { name => 'Лидеры продаж' };
    }
    elsif (params->{slug} eq 'special') {
        $p->{products}  = [ database->quick_select('products', { special => 1, enabled => 1 }, $filters->{opts}) ];
        func::products_get_image($p->{products});

        $p->{category}->{name} = 'Специальные цены';
        push @{$p->{breadcrumbs}}, { name => 'Специальные цены' };
    }
    elsif (params->{slug} eq 'new') {
        $p->{products}  = [ database->quick_select('products', { new => 1, enabled => 1 }, $filters->{opts}) ];
        func::products_get_image($p->{products});

        $p->{category}->{name} = 'Новые';
        push @{$p->{breadcrumbs}}, { name => 'Новые' };
    }

    return template 'categories.tpl', $p;
};

get qr{/manufacturers/((\d+)?/)?} => sub {
    my $p = {};

    my $id = (splat)[1] || 0;

    if ($id) {
        my $filters = _products_filters(\%{params()});
        $p = { %$p, %{$filters->{tpl}} };
        $p->{manufacturer} = database->quick_select('manufacturers', { id => $id });
        $p->{products}     = [ database->quick_select('products',
            { %{$filters->{where}}, enabled => 1, manufacturers_id => $id },
            $filters->{opts}
        ) ];
        func::products_get_image($p->{products});
    }
    else {
        $p->{manufacturers_list} = [ database->quick_select('manufacturers', {}) ];
    }

    return template 'manufacturers.tpl', $p;
};

get '/products/:id/' => sub {
    my $p = {};

    $p->{product} = database->quick_select('products', { enabled => 1, id => params->{id} });
    send_error("Not found", 404) unless $p->{product};

    my $category = database->quick_select('categories', { enabled => 1, id => $p->{product}->{categories_id} });
    $p->{breadcrumbs}       = _categories_bread_crumbs($category, { name => $p->{product}->{name} });
    $p->{seo_title}         = $p->{product}->{seo_title} || $p->{product}->{name};
    $p->{seo_keywords}      = $p->{product}->{seo_keywords};
    $p->{seo_description}   = $p->{product}->{seo_description};
    $p->{product}->{images} = [ database->quick_select('products_images', { products_id => $p->{product}->{id} }, { columns => [qw/image/], order_by => 'image' }) ];

    return template 'product.tpl', $p;
};

get '/resize/:sz/:dir/:image/' => sub {
    my $path = path(config->{public}, 'upload', param('dir'), param('image'));
    return resize $path => { w => param('sz'), h => param('sz'), s => 'max' };
};

get '/sitemap.xml' => sub {
    my $host = 'http://' . request->host;

    my @sitemap_urls = ();
    my $content = [ database->quick_select('content', {}) ];
    for (@$content) {
        push @sitemap_urls, {
            loc         => [ $_->{seo_url} ? "$host/$_->{seo_url}" : "$host/content/$_->{id}/" ],
            # priority    => [ '1.0' ],
            # changefreq  => [ 'daily' ],
        };
    }
    my $products = [ database->quick_select('products', { enabled => 1 }) ];
    for (@$products) {
        push @sitemap_urls, {
            loc      => [ $_->{seo_url} ? "$host/$_->{seo_url}" : "$host/products/$_->{id}/" ],
        };
    }
    my $categories = [ database->quick_select('categories', { enabled => 1 }) ];
    for (@$categories) {
        push @sitemap_urls, {
            loc      => [ $_->{seo_url} ? "$host/$_->{seo_url}" : "$host/categories/$_->{id}/" ],
        };
    }

    my %urlset = (
        xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9',
        url   => \@sitemap_urls
    );

    my $xs  = new XML::Simple( KeepRoot   => 1,
                               ForceArray => 0,
                               KeyAttr    => {urlset => 'xmlns'},
                               XMLDecl    => '<?xml version="1.0" encoding="UTF-8"?>' );
    my $xml = $xs->XMLout( { urlset => \%urlset } );

    content_type "text/xml";
    return $xml;
};

any ['get', 'ajax'] => '/search/' => sub {
    if (request->is_ajax) {
        my $products = Search::products(params->{name_startsWith}, {}, { order_by => 'name' });
        return to_json($products);
    }
    else {
        my $p = { search_word => params->{search_word} };

        if ($p->{search_word}) {
            my $filters = _products_filters(\%{params()});
            $p = { %$p, %{$filters->{tpl}} };
            $p->{products} = Search::products($p->{search_word}, $filters->{where}, $filters->{opts});
            func::products_get_image($p->{products});
        }

        return template 'search.tpl', $p;
    }
};

post '/content_feedback/' => sub {
    if (params->{phone}) {
        my $body = engine('template')->apply_layout(
            engine('template')->apply_renderer('email/content_feedback.tpl', { data => \%{params()} }),
            {}, { layout => 'blank.tpl' }
        );

        func::email(
            to      => vars->{glob_vars}->{email_content_feedback},
            subject => 'Обратная связь',
            body    => $body,
        );
    }

    return redirect params->{referer};
};

any qr!^/[^/]+$! => sub {
    my $path = request->uri;
    $path =~ s!^/!!;

    if ($path !~ /\//) {
        my $clean_path = ($path =~ /(.*?)\?/)[0];

        my $content = database->quick_select('content',
            'seo_url = ' . database->quote($path) . ' OR seo_url = ' . database->quote($clean_path)
        );
        if ($content->{id}) {
            forward "/content/$content->{id}/";
        }

        my $category = database->quick_select('categories',
            'enabled=1 AND seo_url = ' . database->quote($path) . ' OR seo_url = ' . database->quote($clean_path)
        );
        if ($category->{id}) {
            forward "/categories/$category->{id}/";
        }

        my $product = database->quick_select('products',
            'enabled=1 AND seo_url = ' . database->quote($path) . ' OR seo_url = ' . database->quote($clean_path)
        );
        if ($product->{id}) {
            forward "/products/$product->{id}/";
        }
    }

    return redirect '/404/';
};

sub categories_tree {
    my $parent_id = shift || 0;
    my $opts = shift;
    return if $opts and ref $opts ne 'HASH';

    my $where = { parent_id => $parent_id };
    $where->{enabled} = 1 if $opts->{enabled};

    my $categories = [ database->quick_select('categories', $where, { order_by => 'sort' }) ];
    for (@$categories) {
        $_->{childs} = categories_tree($_->{id}, $opts);
    }

    return $categories;
}

sub _products_filters {
    my $params = shift;

    my $p = {
        tpl   => {},
        where => {},
        opts  => { order_by => 'sort' },
    };

    if ($params->{sort} and $params->{direction} and $params->{direction} =~ /^asc|desc$/ and $params->{sort} =~ /^price|name$/) {
        $p->{tpl}->{sort} = $params->{sort};
        $p->{tpl}->{direction}->{$params->{sort}} = $params->{direction};
        $p->{opts}->{order_by} = { $params->{direction} => $params->{sort} };
    }

    if ($params->{filt}) {
        my @filters = qw/special hit new/;
        if (grep(/^$params->{filt}$/, @filters)) {
            $p->{tpl}->{filt} = $params->{filt};
            $p->{where}->{$params->{filt}} = 1;
        }
    }

    return $p;
}

sub _content_vars {
    my $var = shift;

    my $tpl = ($var =~ /^\$\{(\w+)\}$/)[0];
    return engine('template')->apply_layout(
        engine('template')->apply_renderer("inc/$tpl.tpl", {}),
        {}, { layout => 'null.tpl' }
    );
}

sub _categories_bread_crumbs {
    my ($el, $last) = @_;

    my @bc = ();
    push @bc, $last if $last;
    while (1) {
        push @bc, { name => $el->{name}, item => $el };
        last unless $el->{parent_id};
        $el = database->quick_select('categories', { id => $el->{parent_id} });
    }

    return \@bc;
}

true;
