package Admin::Content;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;

any ['get', 'post'] => '/' => sub {
    my $p = { action => 'list' };

    $p->{content} = [ database->quick_select('content', {}) ];
    for (@{$p->{content}}) {
        $_->{products_cnt} = database->selectrow_array('SELECT count(*) FROM content_products WHERE content_id = ?', undef, $_->{id});
    }

    template 'admin/content.tpl', $p;
};

any ['get', 'post'] => '/add/' => sub {
    my $p = {};

    if (request->method() eq 'POST') {
        ($p->{form}, $p->{err}) = _check_content(\%{params()});

        unless (scalar keys %{$p->{err}}) {
            $p->{form}->{seo_url} ||= func::make_alias($p->{form}->{name});
            database->quick_insert('content', $p->{form});
            my $id = database->last_insert_id(undef, undef, undef, undef);
            redirect "http://". request->host ."/admin/content/";
        }
    }

    template 'admin/content.tpl', $p;
};

any ['get', 'post'] => qr{ /(?<id>\d+)/(?<link_products>products)?/?$ }x => sub {
    my $value_for = captures;

    my $p = { link_products => $value_for->{link_products} };

    my $content = database->quick_select('content', { id => $value_for->{id} });
    if ($content->{id}) {
        if (request->method() eq 'POST') {
            ($p->{form}, $p->{err}) = _check_content(\%{params()});

            if (scalar keys %{$p->{err}}) {
                $p->{form}->{id} = $content->{id};
            }
            else {
                database->quick_update('content', { id => $content->{id} }, $p->{form});
                if ($value_for->{link_products}) {
                    database->quick_delete('content_products', { content_id => $content->{id} });
                    my $products_ids = ref params->{products_id} eq 'ARRAY' ? params->{products_id} : [ params->{products_id} ];
                    for my $id (@$products_ids) {
                        database->quick_insert('content_products', { content_id => $content->{id}, products_id => $id });
                    }
                }
                redirect "http://". request->host ."/admin/content/";
            }
        }
        else {
            $p->{form} = $content;
            if ($value_for->{link_products}) {
                my $content_products = [
                    database->quick_select('content_products', { content_id => $content->{id} }, { columns => [qw(products_id)] })
                ];
                $p->{link} = { map { $_->{products_id} => 1 } @$content_products };
                $p->{products} = [ database->quick_select('products', {}) ];
            }
            else {
                my $content_products = [
                    database->quick_select('content_products', { content_id => $content->{id} }, { columns => [qw(products_id)] })
                ];
                if (scalar @$content_products) {
                    $p->{products} = [ database->quick_select('products', { id => [map {$_->{products_id}} @$content_products] }) ];
                }
            }
        }

        template 'admin/content.tpl', $p;
    }
};

ajax '/del/:id/' => sub {
    return unless vars->{loged}->{acs}->{admin};

    my $content = database->quick_select('content', { id => params->{id}});
    if ($content->{id}) {
        database->quick_delete('content', { id => $content->{id} });
    }
    return 1;
};

sub _check_content {
    my $params = shift;
    my ($form, $err) = ({},{});

    for (qw/name descr seo_url seo_title seo_keywords seo_description/) {
        $form->{$_} = $params->{$_};
    }
    $form->{name}    = func::trim($form->{name});
    $form->{seo_url} = func::trim($form->{seo_url});

    $err->{name} = 1 if length($form->{name}) < 3;

    return ($form, $err);
}

true;
