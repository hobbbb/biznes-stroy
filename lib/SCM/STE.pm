# Simple Config Manager - SinglePage TreeTable Editing
package SCM::STE;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use func;

sub tree {
    my ($params, $parent_id, $http_params) = @_;
    $http_params->{parent_id} = $parent_id;

    my $current_level = _current_level($params, $parent_id);
    my $p = {
        SCRIPT      => $params->{SCRIPT},
        ENTITY      => $params->{ENTITY},
        LEVEL_LIMIT => ($current_level == $params->{MAX_LEVEL}) ? 1 : 0,
        parent_id   => $parent_id,
        breadcrumbs => _breadcrumbs($params, $parent_id),
    };

    if (request->method() eq 'POST') {
        my $caller = caller;
        no strict 'refs';
        *_check_item = *{$caller . '::_check_item'};
        ($p->{form}, $p->{err}) = _check_item($http_params);

        unless (scalar keys %{$p->{err}}) {
            database->quick_insert($params->{TABLE}, $p->{form});
            redirect "http://". request->host . $p->{SCRIPT} . ($parent_id ? "$parent_id/" : '');
        }
    }

    $p->{list} = [ database->quick_select($params->{TABLE}, { parent_id => $parent_id }, { order_by => 'sort' }) ];

    return template $params->{TPL}, $p;
}

sub edit {
    my ($params, $http_params) = @_;

    my $p = {
        SCRIPT      => $params->{SCRIPT},
        ENTITY      => $params->{ENTITY},
    };

    my $item = database->quick_select($params->{TABLE}, { id => params->{id}});
    if ($item->{id}) {
        $http_params->{parent_id} = $item->{parent_id};

        $p->{parent_id} = $item->{parent_id};
        $p->{breadcrumbs} = _breadcrumbs($params, $item->{parent_id});

        if (request->method() eq 'POST') {
            my $caller = caller;
            no strict 'refs';
            *_check_item = *{$caller . '::_check_item'};
            ($p->{form}, $p->{err}) = _check_item($http_params, $item);

            if (scalar keys %{$p->{err}}) {
                $p->{form}->{id} = $item->{id};
            }
            else {
                database->quick_update($params->{TABLE}, { id => $item->{id} }, $p->{form});
                return redirect "http://". request->host . $params->{SCRIPT} . ($item->{parent_id} ? "$item->{parent_id}/" : '');
            }
        }
        else {
            $p->{form} = $item;
        }

        $p->{list} = [ database->quick_select($params->{TABLE}, { parent_id => $item->{parent_id} }, { order_by => 'sort' }) ];

        return template $params->{TPL}, $p;
    }
}

sub del {
    return unless request->is_ajax();

    my ($params, $http_params) = @_;

    my $item = database->quick_select($params->{TABLE}, { id => $http_params->{id}});
    if ($item->{id}) {
        _recursive_del($params, $item);
    }

    return 1;
}

sub rearrange {
    return unless request->is_ajax();

    my ($params, $http_params) = @_;

    my $id = $http_params->{'id[]'};
    my $i = 1;
    for (@$id) {
        database->quick_update($params->{TABLE}, { id => $_ }, { sort => $i });
        $i++;
    }
}



sub _breadcrumbs {
    my ($params, $parent_id) = @_;

    my @bc = ();
    while ($parent_id) {
        my $item = database->quick_select($params->{TABLE}, { id => $parent_id });
        push @bc, $item;
        $parent_id = $item->{parent_id};
    }
    @bc = reverse @bc;

    return \@bc;
}

sub _recursive_del {
    my ($params, $item) = @_;

    my $childs = [ database->quick_select($params->{TABLE}, { parent_id => $item->{id} }) ];
    for (@$childs) {
        _recursive_del($params, $_);
    }
    database->quick_delete($params->{TABLE}, { id => $item->{id} });
}

sub _current_level {
    my ($params, $parent_id, $i) = @_;
    return 0 unless $parent_id;
    $i ||= 1;

    my $item = database->quick_select($params->{TABLE}, { id => $parent_id }, { columns => [qw/parent_id/] });
    if ($item->{parent_id}) {
        _current_level($params, $item->{parent_id}, $i++);
    }

    return $i;
}

true;
