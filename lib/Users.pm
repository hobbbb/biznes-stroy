package Users;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use func;

prefix '/auth' => sub {
    get '/' => sub {
        return redirect 'http://'. request->host .'/' if check_auth();

        template 'auth.tpl', { referer => params->{referer} || request->referer };
    };

    any ['get', 'post'] => '/register/' => sub {
        return redirect 'http://'. request->host .'/' if check_auth();

        my ($form, $err) = ({},{});

        if (request->method() eq 'POST') {
            my %params = params;
            ($form, $err) = _check_user(\%params);

            unless (scalar keys %$err) {
                $form->{registered} = func::now();
                $form->{regcode} = func::generate();
                $form->{x_real_ip} = request->{env}->{HTTP_X_REAL_IP};
                database->quick_insert('users', $form);

                if (_login($form->{email}, $form->{password}, 1)) {
                    return redirect 'http://'. request->host .'/';
                }
            }
        }

        template 'auth.tpl', { form => $form, err => $err };
    };

    post '/login/' => sub {
        return redirect 'http://'. request->host .'/' if check_auth();

        if (_login(params->{email}, params->{password}, params->{remember})) {
            return redirect params->{referer};
        }

        template 'auth.tpl', { referer => params->{referer} || request->referer };
    };

    post '/restore/' => sub { # TODO: remake method
        return redirect 'http://'. request->host .'/' if check_auth();

        my $p = {};

        $p->{form}->{email} = params->{email};
        $p->{err}->{email} = 1 unless $p->{form}->{email};

        unless (scalar keys %{$p->{err}}) {
            my $user = database->quick_select('users', { email => $p->{form}->{email} });
            if ($user) {
                my $body = engine('template')->apply_layout(
                    engine('template')->apply_renderer('email/restore.tpl', $user),
                    {}, { layout => 'blank.tpl' }
                );
                func::email(
                    to      => $user->{email},
                    subject => 'Восстановление пароля',
                    body    => $body,
                );
                # return redirect 'http://'. request->host .'/auth/';
            }
            else {
                $p->{err}->{email_not_exist} = 1;
            }
        }

        return redirect 'http://'. request->host .'/auth/';
    };

    get '/logout/' => sub {
        cookie code => '', expires => '0';
        return redirect 'http://'. request->host .'/';
    };

    any ['get', 'post'] => '/lk/' => sub {
        my $regcode = cookie 'code';
        return redirect 'http://'. request->host .'/' unless $regcode;

        my $p = {};

        if (request->method() eq 'POST') {
            my %params = params;
            ($p->{form}, $p->{err}) = _check_user(\%params, $regcode);

            unless (scalar keys %{$p->{err}}) {
                database->quick_update('users', { regcode => $regcode }, $p->{form});
            }
        }
        else {
            $p->{form} = database->quick_select('users', { regcode => $regcode });
        }

        $p->{discount_program} = [ database->quick_select('discount_program', {}) ];
        template 'lk.tpl', $p;
    };
};

sub _check_user {
    my ($params, $regcode) = @_;
    my ($form, $err) = ({},{});

    for (qw/phone fio email address password password2 code/) {
        $form->{$_} = $params->{$_};
    }
    $form->{email} = lc $form->{email};
    $form->{email} = func::trim($form->{email});

    $err->{phone} = 1 if $form->{phone} !~ /^\d{10}$/;
    $err->{email} = 1 if $form->{email} !~ /^.+@.+\.[a-z]{2,4}$/;
    $err->{fio} = 1 if length($form->{fio}) < 3;
    $err->{address} = 1 if ($form->{address} and $form->{address} =~ /(ftp|http|\.ru|\.org|\.com)/);
    if ($regcode) {
        $err->{email} = $err->{email_exist} = 1 if database->quick_select('users', { email => $form->{email}, regcode => { 'ne' => $regcode } });
        if ($form->{password}) {
            $err->{password} = $err->{password2} = 1 if $form->{password} !~ /^.{6,50}$/ or $form->{password} ne $form->{password2};
        }
        else {
            delete $form->{password};
        }
    }
    else {
        $err->{password} = $err->{password2} = 1 if $form->{password} !~ /^.{6,50}$/ or $form->{password} ne $form->{password2};
        $err->{email} = $err->{email_exist} = 1 if database->quick_select('users', { email => $form->{email} });
    }
    delete $form->{password2};

    $err->{code} = 1 if $form->{code};
    delete $form->{code};

    return ($form, $err);
}

sub _login {
    my ($email, $password, $remember) = @_;

    if ($email and $password) {
        my $regcode = database->quick_lookup('users', { email => $email, password => $password }, 'regcode');
        if ($regcode) {
            if ($remember) {
                cookie code => $regcode, expires => '1 year';
            }
            else {
                cookie code => $regcode;
            }
            return 1;
        }
    }
}

sub check_auth {
    my $regcode = cookie 'code';
    my $user;
    if ($regcode) {
        $user = database->quick_select('users', { regcode => $regcode });
        unless (defined $user) {
            cookie code => '', expires => '0';
            return;
        }
        if ($user->{role}) {
            if ($user->{role} eq 'admin') {
                $user->{acs}->{admin} = 1;
                $user->{acs}->{manager} = 1;
                $user->{acs}->{content} = 1;
            }
            elsif ($user->{role} eq 'manager') {
                $user->{acs}->{manager} = 1;
            }
            elsif ($user->{role} eq 'content') {
                $user->{acs}->{content} = 1;
            }
        }
    }

    if (request->path_info =~ m!^/admin!) {
        if (!defined $user or !scalar keys %{$user->{acs}}) {
            redirect '/404/';
        }

        if (request->path_info ne '/admin/') {
            my $access = 0;
            if ($user->{acs}->{manager}) {
                for (qw/orders bill search/) {
                    if (request->path_info =~ m!^/admin/$_!) {
                        $access = 1;
                        last;
                    }
                }
            }
            if ($user->{acs}->{content}) {
                for (qw/catalog categories products/) {
                    if (request->path_info =~ m!^/admin/$_!) {
                        $access = 1;
                        last;
                    }
                }
            }
            $access = 1 if $user->{acs}->{admin};

            return redirect '/admin/' unless $access;
        }
    }

    return $user;
}

sub last_visit {
    my $regcode = cookie 'code';
    if ($regcode) {
        database->quick_update('users', { regcode => $regcode }, { last_visit => func::now() });
    }
}

true;
