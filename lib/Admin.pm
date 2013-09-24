package Admin;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use File::Copy;
use func;

load_app 'Admin::Content', prefix => '/admin/content';
load_app 'Admin::Orders',  prefix => '/admin/orders';
load_app 'Admin::Users',   prefix => '/admin/users';
load_app 'Admin::Bills';
load_app 'Admin::Price';
load_app 'Admin::Catalog';

#-------------------------------------------------------------------------------

load_app 'SCM::SPE';
load_app 'Admin::SPE::manufacturers',    prefix => '/admin/manufacturers';
load_app 'Admin::SPE::banners',          prefix => '/admin/banners';
load_app 'Admin::SPE::top_menu',         prefix => '/admin/top_menu';
load_app 'Admin::SPE::discount_program', prefix => '/admin/discount_program';
load_app 'Admin::SPE::biznes_stroy',     prefix => '/admin/biznes_stroy';

#-------------------------------------------------------------------------------

load_app 'SCM::STE';
load_app 'Admin::STE::footer_content', prefix => '/admin/footer_content',
    settings => {
        ENTITY      => 'footer_content',
    };

#-------------------------------------------------------------------------------

prefix '/admin' => sub {
    get '/' => sub {
        template 'admin/index.tpl';
    };

    get '/help/:slug/' => sub {
        my $p = {};
        $p->{content} = database->quick_select('content', { seo_url => params->{slug}, alias => 'admin' });

        template 'admin/help.tpl', $p;
    };

    any ['get', 'post'] => '/glob_vars/' => sub {
        my $p = {};

        if (request->method() eq 'POST') {
            my $id = ref params->{id} eq 'ARRAY' ? params->{id} : [ params->{id} ];

            for (@$id) {
                database->quick_update('glob_vars', { id => $_ }, { val => params->{"val_$_"} });
            }
            redirect "http://". request->host ."/admin/glob_vars/";
        }

        my $where;
        if (params->{type} and params->{type} eq 'seller') {
            $where = 'name LIKE "seller_%"';
        }
        else {
            $where = 'name NOT LIKE "seller_%"';
        }
        $p->{glob_vars} = [ database->quick_select('glob_vars', $where) ];

        template 'admin/glob_vars.tpl', $p;
    };

    any ['get', 'post'] => '/backup/' => sub {
        halt 'NO config->{dump_path}' unless config->{dump_path};

        my $p = {};

        my $dump_path = config->{dump_path};
        my $db = config->{plugins}->{Database};

        chdir $dump_path;
        if (request->method() eq 'POST') {
            if (params->{action} eq 'restore') {
                my $cmd = 'mysql -u'.$db->{username} . ( $db->{password} ? ' -p'.$db->{password}.' ' : ' ') .
                    $db->{database} . ' < ' . $dump_path . params->{dump};
                `$cmd`;
            }
            elsif (params->{action} eq 'delete') {
                unlink params->{dump} if -f params->{dump};
            }
            elsif (params->{action} eq 'backup') {
                my $cmd = 'mysqldump -u'.$db->{username} . ( $db->{password} ? ' -p'.$db->{password}.' ' : ' ') . $db->{database} . ' > ' .
                    $dump_path . 'dump-$(date +%F-%H-%M)---'. $db->{username} . '.sql';
                `$cmd`;
            }
            redirect "http://". request->host ."/admin/backup/";
        }

        for (glob('*.sql')) {
            push @{$p->{dumps}}, {
                file    => $_,
                uid     => (stat($_))[5],
            };
        }

        $p->{db} = $db;
        template 'admin/backup.tpl', $p;
    };

    prefix '/search' => sub {
        any '/' => sub {
            my $p = {
                search_word => params->{search_word},
            };

            if ($p->{search_word}) {
                $p->{products} = Search::products($p->{search_word}, {}, { order_by => 'name' });
                func::products_get_image($p->{products});
            }

            template 'admin/search.tpl', $p;
        };

        ajax '/user/' => sub {
            my $sword = database->quote(params->{search_word} . '%');
            my $users = [ database->quick_select('users', "role IS NULL AND (inn LIKE $sword OR firm LIKE $sword OR fio LIKE $sword)", { limit => params->{limit} }) ];
            return to_json($users);
        };
    };
};

sub fUpload {
    my %p = @_;
    $p{field} ||= 'image';

    if ($p{only_del}) {
        my $file = path($p{dir}, $p{del});
        unlink $file if -f $file;
        return '';
    }
    else {
        my $upload = upload($p{field});
        if ($upload) {
            if ($p{del}) {
                my $file = path($p{dir}, $p{del});
                unlink $file if -f $file;
            }
            my $filename = $p{ind} ? "$p{id}_$p{ind}" : $p{id};
            my $file = $filename . '.' . lc(($upload->basename =~ /\.(\w+)$/)[0]);
            move($upload->tempname, path($p{dir}, $file));
            chmod 0664, path($p{dir}, $file);
            return $file;
        }
    }
}

true;
