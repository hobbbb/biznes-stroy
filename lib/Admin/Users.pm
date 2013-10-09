package Admin::Users;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;

ajax '/get/:id/' => sub {
    my $user = database->quick_select('users', { id => params->{id} });
    return to_json($user);
};

any ['get', 'post'] => '/' => sub {
    my $p = {
        action  => 'list',
        type    => params->{type} || 'all',
    };

    my $where = {};
    if ($p->{type} eq 'normal') {
        $where->{role} = undef;
    }
    elsif ($p->{type} eq 'tech') {
        $where->{role} = ['admin', 'manager'];
    }
    elsif ($p->{type} eq 'partner') {
        $where->{is_partner} = 1;
    }
    elsif (grep(/^$p->{type}$/, ('ph', 'ur'))) {
        $where->{type} = $p->{type};
    }

    $p->{users} = [ database->quick_select('users', $where) ];
    for (@{$p->{users}}) {
        my $diff = func::date_diff($_->{last_visit});
        if (defined $diff) {
            $_->{online} = 1 if ($diff / 60) < 2;
        }
    }
    template 'admin/users.tpl', $p;
};

any '/add/' => sub {
    my $p = {};

    if (request->is_ajax) { # Для сохранения из модального окна
        $p = _add_user();
        return to_json($p);
    }
    elsif (request->is_post) {
        $p = _add_user();
        unless (scalar keys %{$p->{err}}) {
            redirect "http://". request->host ."/admin/users/";
        }
    }

    template 'admin/users.tpl', $p;
};

any '/edit/:id/' => sub {
    my $p = {};

    my $user = database->quick_select('users', { id => params->{id}});
    if ($user->{id}) {
        if (request->is_ajax) { # Для сохранения из модального окна
            $p = _edit_user($user);
            return to_json($p);
        }
        elsif (request->is_post) {
            $p = _edit_user($user);
            unless (scalar keys %{$p->{err}}) {
                redirect "http://". request->host ."/admin/users/";
            }
        }
        else {
            $p->{form} = $user;
        }

        $p->{users} = [ database->quick_select('users', {}) ];
        template 'admin/users.tpl', $p;
    }
};

ajax '/del/:id/' => sub {
    my $user = database->quick_select('users', { id => params->{id}});
    if ($user->{id}) {
        database->quick_delete('users', { id => $user->{id} });
    }
    return 1;
};

sub _add_user {
    my $p = {};
    ($p->{form}, $p->{err}) = _check_admin_user(\%{params()});

    unless (scalar keys %{$p->{err}}) {
        $p->{form}->{registered} = func::now();
        $p->{form}->{regcode} = func::generate();
        database->quick_insert('users', $p->{form});
        $p->{id} = database->last_insert_id(undef, undef, undef, undef);
    }

    return $p;
}

sub _edit_user {
    my $user = shift;

    my $p = {};
    ($p->{form}, $p->{err}) = _check_admin_user(\%{params()}, $user->{regcode});

    if (scalar keys %{$p->{err}}) {
        $p->{form}->{id} = $user->{id};
        $p->{form}->{registered} = $user->{registered};
        $p->{form}->{last_visit} = $user->{last_visit};
    }
    else {
        database->quick_update('users', { id => $user->{id} }, $p->{form});
        $p->{id} = $user->{id};
    }

    return $p;
}

sub _check_admin_user {
    my ($params, $regcode) = @_;
    my ($form, $err) = ({},{});

    for (
        qw/type phone email fio address password firm ogrn inn kpp legal_address actual_address general_manager main_accountant
        bank current_account bik correspondent_account okpo okato tax_inspection partner_discount is_partner role/
    ) {
        $form->{$_} = $params->{$_};
    }
    $form->{is_partner} = $form->{is_partner} ? 1 : 0;
    $form->{email}      = func::trim(lc $form->{email});
    $form->{type}     ||= 'ph';

    $err->{phone}                   = 1 if $form->{phone} !~ /^\d+$/;
    $err->{email}                   = 1 if $form->{email} !~ /^.+@.+\.[a-z]{2,4}$/;
    $err->{fio}                     = 1 if length($form->{fio}) < 3;
    $err->{password}                = 1 if $form->{password} !~ /^.{6,50}$/;
    $err->{partner_discount}        = 1 if $form->{partner_discount} and $form->{partner_discount} !~ /^\d{1,2}$/;

    if ($form->{type} eq 'ur') {
        $err->{ogrn}                    = 1 if $form->{ogrn} and length($form->{ogrn}) != 13;
        $err->{inn}                     = 1 if $form->{inn} and length($form->{inn}) != 10 and length($form->{inn}) != 12;
        $err->{kpp}                     = 1 if $form->{kpp} and length($form->{kpp}) != 9;
        $err->{bik}                     = 1 if $form->{bik} and length($form->{bik}) != 9;
        $err->{current_account}         = 1 if $form->{current_account} and length($form->{current_account}) != 20;
        $err->{correspondent_account}   = 1 if $form->{correspondent_account} and length($form->{correspondent_account}) != 20;
        $err->{okpo}                    = 1 if $form->{okpo} and length($form->{okpo}) != 8 and length($form->{okpo}) != 10;
        $err->{okato}                   = 1 if $form->{okato} and $form->{okato} !~ /^\d{2,11}$/;

        map { $err->{$_} = 1 unless $form->{$_} } qw/firm ogrn inn kpp legal_address actual_address general_manager main_accountant
            bank current_account bik correspondent_account okpo/;
    }

    if ($regcode) {
        $err->{email} = $err->{email_exist} = 1 if database->quick_select('users', { email => $form->{email}, regcode => { 'ne' => $regcode } });
        $err->{inn} = $err->{inn_exist} = 1 if $form->{inn} and database->quick_select('users', { inn => $form->{inn}, regcode => { 'ne' => $regcode } });
    }
    else {
        $err->{email} = $err->{email_exist} = 1 if database->quick_select('users', { email => $form->{email} });
        $err->{inn} = $err->{inn_exist} = 1 if $form->{inn} and database->quick_select('users', { inn => $form->{inn} });
    }

    map { delete $form->{$_} unless $form->{$_} } qw/partner_discount role firm ogrn inn kpp legal_address actual_address general_manager main_accountant
        bank current_account bik correspondent_account okpo okato tax_inspection/;

    return ($form, $err);
}

true;
