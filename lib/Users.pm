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
                $form->{password} = func::generate(8);
                $form->{x_real_ip} = request->{env}->{HTTP_X_REAL_IP};
                database->quick_insert('users', $form);

                func::send_sms(
                    phone   => $form->{phone},
                    message => "Вы зарегистрировались на сайте " . request->host . ", пароль $form->{password}",
                );

                if (_login($form->{phone}, $form->{password}, 1)) {
                    return redirect 'http://'. request->host .'/';
                }
            }
        }

        template 'auth.tpl', { form => $form, err => $err };
    };

    post '/login/' => sub {
        return redirect 'http://'. request->host .'/' if check_auth();

        if (_login(params->{phone}, params->{password}, params->{remember})) {
            return redirect params->{referer};
        }

        template 'auth.tpl', { referer => params->{referer} || request->referer };
    };

    post '/restore/' => sub {
        return redirect 'http://'. request->host .'/' if check_auth();

        my $user;
        if (params->{phone}) {
            $user = database->quick_select('users', { phone => params->{phone} });
        }
        elsif (params->{email}) {
            $user = database->quick_select('users', { email => params->{email} });
        }

        if ($user) {
            if (params->{phone}) {
                func::send_sms(
                    phone   => $user->{phone},
                    message => "Ваш пароль: $user->{password}",
                );
            }
            elsif (params->{email}) {
                my $body = engine('template')->apply_layout(
                    engine('template')->apply_renderer('email/restore.tpl', { user => $user }),
                    {}, { layout => 'blank.tpl' }
                );
                func::email(
                    to      => $user->{email},
                    subject => 'Восстановление пароля',
                    body    => $body,
                );
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

    for (qw/phone fio email address password notify_news code/) {
        $form->{$_} = $params->{$_};
    }
    $form->{email} = func::trim(lc $form->{email});
    $form->{notify_news} = $form->{notify_news} ? 1 : 0;

    $form->{phone} =~ s/^\+7//;

    $err->{phone}   = 1 if $form->{phone} !~ /^\d{10}$/;
    $err->{fio}     = 1 if length($form->{fio}) < 3;
    $err->{email}   = 1 if $form->{email} and $form->{email} !~ /^.+@.+\.[a-z]{2,4}$/;
    $err->{address} = 1 if $form->{address} and $form->{address} =~ /(ftp|http|\.ru|\.org|\.com)/;

    if ($regcode) {
        if ($form->{password}) {
            $err->{password} = 1 if $form->{password} !~ /^.{6,50}$/;
        }
        else {
            delete $form->{password};
        }
    }

    for my $f (qw/phone email/) {
        next unless $form->{$f};

        my $where = { $f => $form->{$f} };
        if ($regcode) {
            $where->{regcode} = { 'ne' => $regcode };
        }
        $err->{$f} = $err->{"$f\_exist"} = 1 if database->quick_select('users', $where);
    }

    $err->{code} = 1 if $form->{code};
    delete $form->{code};

    return ($form, $err);
}

sub _login {
    my ($phone, $password, $remember) = @_;

    if ($phone and $password) {
        $phone =~ s/^\+7//;
        my $regcode = database->quick_lookup('users', { phone => $phone, password => $password }, 'regcode');
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

        my @roles = qw/admin manager content driver/;
        if ($user->{role}) {
            if ($user->{role} eq 'admin') {
                map { $user->{acs}->{$_} = 1 } @roles;
            }
            else {
                for my $r (@roles) {
                    if ($user->{role} eq $r) {
                        $user->{acs}->{$r} = 1;
                        $user->{acs}->{"$r\_only"} = 1;
                    }
                }
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
                for (qw!
                        orders
                        bill
                        search
                    !) {
                    if (request->path_info =~ m!^/admin/$_!) {
                        $access = 1;
                        last;
                    }
                }
            }
            if ($user->{acs}->{content}) {
                for (qw!
                        catalog
                        categories
                        products
                        content
                    !) {
                    if (request->path_info =~ m!^/admin/$_!) {
                        $access = 1;
                        last;
                    }
                }
            }
            if ($user->{acs}->{driver}) {
                for (qw!
                        orders/delivery
                        orders/to/done
                    !) {
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
