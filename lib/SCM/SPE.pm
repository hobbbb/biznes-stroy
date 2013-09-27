# Simple Config Manager - SinglePage PlainTable Editing
package SCM::SPE;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use File::Copy;
use SCM::utils;

sub main {
    my ($params, $http_params) = @_;

    my $TABLE  = $params->{table} || $params->{alias};
    my $SCRIPT = $params->{script} || "/admin/$params->{alias}/";
    my $TPL    = $params->{tpl} || 'admin/SPE.tpl';

    my $p = {
        %{$params},
        script => $SCRIPT,
    };

    if (request->method() eq 'POST') {
        # my $caller = caller;
        # no strict 'refs';
        # *_check_item = *{$caller . '::_check_item'};
        # ($p->{form}, $p->{err}) = _check_item($http_params);
        ($p->{form}, $p->{err}) = _check_item($params, $http_params);

        for (@{$params->{fields}}) {
            if ($_->{type} eq 'file') {
                delete $p->{form}->{$_->{name}};
            }
        }
        unless (scalar keys %{$p->{err}}) {
            database->quick_insert($TABLE, $p->{form});

            if ($params->{upload}) {
                my $id = database->last_insert_id(undef, undef, undef, undef);
                my $where;
                for (@{$params->{fields}}) {
                    if ($_->{type} eq 'file') {
                        my $file = _upload(
                            field   => $_->{name},
                            dir     => path(config->{public}, 'upload', $params->{alias}),
                            prefix  => $id,
                        );
                        $where->{$_->{name}} = $file if $file;
                    }
                }
                database->quick_update($TABLE, { id => $id }, $where) if $where;
            }

            return redirect "http://". request->host . $SCRIPT . '?' . request->{env}->{QUERY_STRING};
        }
    }

    my $where = {};
    for my $filter (grep(/^filter/, keys %$http_params)) {
        my $f = ($filter =~ /^filter_(.+)$/)[0];
        if (grep(/^$f$/, map { $_->{name} } @{$params->{fields}})) {
            $where->{$f} = $http_params->{$filter};
        }
    }

    my $options = {};
    $options->{order_by} = 'sort' if $params->{sortable};

    $p->{list} = [ database->quick_select($TABLE, $where, $options) ];

    return template $TPL, $p;
}

sub edit {
    my ($params, $http_params) = @_;

    my $TABLE  = $params->{table} || $params->{alias};
    my $SCRIPT = $params->{script} || "/admin/$params->{alias}/";
    my $TPL    = $params->{tpl} || 'admin/SPE.tpl';

    my $p = {
        %{$params},
        script => $SCRIPT,
    };

    my $item = database->quick_select($TABLE, { id => params->{id}});
    if ($item->{id}) {
        if (request->method() eq 'POST') {
            # my $caller = caller;
            # no strict 'refs';
            # *_check_item = *{$caller . '::_check_item'};
            # ($p->{form}, $p->{err}) = _check_item($http_params, $item);
            ($p->{form}, $p->{err}) = _check_item($params, $http_params, $item);

            if (scalar keys %{$p->{err}}) {
                $p->{form}->{id} = $item->{id};
                if ($params->{upload}) {
                    for (@{$params->{fields}}) {
                        if ($_->{type} eq 'file') {
                            $p->{form}->{$_->{name}} = $item->{$_->{name}};
                        }
                    }
                }
            }
            else {
                if ($params->{upload}) {
                    for (@{$params->{fields}}) {
                        if ($_->{type} eq 'file') {
                            $p->{form}->{$_->{name}} = _upload(
                                field    => $_->{name},
                                dir      => path(config->{public}, 'upload', $params->{alias}),
                                prefix   => $item->{id},
                                old      => $item->{$_->{name}},
                                delete   => param('del_' . $_->{name}),
                            );
                            delete $p->{form}->{$_->{name}} unless defined $p->{form}->{$_->{name}};
                        }
                    }
                }

                database->quick_update($TABLE, { id => $item->{id} }, $p->{form});
                return redirect "http://". request->host . $SCRIPT . '?' . request->{env}->{QUERY_STRING};
            }
        }
        else {
            $p->{form} = $item;
        }

        my $where = {};
        for my $filter (grep(/^filter/, keys %$http_params)) {
            my $f = ($filter =~ /^filter_(.+)$/)[0];
            if (grep(/^$f$/, map { $_->{name} } @{$params->{fields}})) {
                $where->{$f} = $http_params->{$filter};
            }
        }

        my $options = {};
        $options->{order_by} = 'sort' if $params->{sortable};

        $p->{list} = [ database->quick_select($TABLE, $where, $options) ];

        return template $TPL, $p;
    }
}

sub del {
    return unless request->is_ajax();

    my ($params, $http_params) = @_;

    my $TABLE = $params->{alias};

    my $item = database->quick_select($TABLE, { id => $http_params->{id}});
    if ($item->{id}) {
        if ($params->{upload}) {
            for (@{$params->{fields}}) {
                if ($_->{type} eq 'file' and $item->{$_->{name}} and -f path(config->{public}, 'upload', $params->{alias}) . "/$item->{$_->{name}}") {
                    unlink path(config->{public}, 'upload', $params->{alias}) . "/$item->{$_->{name}}";
                }
            }
        }

        database->quick_delete($TABLE, { id => $item->{id} });
    }

    return 1;
}

sub rearrange {
    return unless request->is_ajax();

    my ($params, $http_params) = @_;
    return unless $params->{sortable};

    my $TABLE = $params->{alias};

    my $id = [ map { $_ if /^\d+$/ } @{$http_params->{'id[]'}} ];
    if (@$id) {
        my $ids_list = join ", ", map { database->quote($_) } @$id;
        database->do("UPDATE $TABLE SET sort = field(id, $ids_list) WHERE id IN (" . join(',', @$id) . ")");
    }
}

sub _upload {
    my %p = @_;

    if ($p{field}) {
        my $upload = upload($p{field});
        if ($upload) {
            if ($p{old}) {
                my $file = path($p{dir}, $p{old});
                unlink $file if -f $file;
            }
            my $filename = $p{ind} ? "$p{prefix}_$p{ind}" : $p{prefix};
            my $file = $filename . '.' . lc(($upload->basename =~ /\.(\w+)$/)[0]);
            move($upload->tempname, path($p{dir}, $file));
            chmod 0664, path($p{dir}, $file);
            return $file;
        }
    }

    if ($p{delete}) {
        my $file = path($p{dir}, $p{old});
        unlink $file if -f $file;
        return '';
    }
}

sub _check_item {
    my ($params, $http_params, $item) = @_;
    my ($form, $err) = ({},{});

    for my $f (@{$params->{fields}}) {
        next if $f->{readonly};

        $form->{$f->{name}} = $http_params->{$f->{name}};

        if ($f->{type} eq 'text') {
            $form->{$f->{name}} = trim($form->{$f->{name}});
        }

        if (ref $f->{error} eq 'CODE') {
            if (&{$f->{error}}($form->{$f->{name}}, $http_params, $item)) {
                $err->{$f->{name}} = 1;
            }
        }
    }

    return ($form, $err);
}

true;
