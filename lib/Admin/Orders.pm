package Admin::Orders;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;
use func;

get '/' => sub {
    my $p = {};

    $p->{orders} = [ database->quick_select('orders', {}, { order_by => { 'desc' => 'registered' } }) ];
    for (@{$p->{orders}}) {
        $_->{user} = database->quick_select('users', { id => $_->{users_id} }) if $_->{users_id};
        $_->{product_list} = [ database->quick_select('orders_products', { orders_id => $_->{id} }) ];
    }

    return template 'admin/orders.tpl', $p;
};

get '/:status/' => sub {
    my $loged = vars->{loged};
    my $p = { status => params->{status} };

    $p->{managers} = [ database->quick_select('users', { role => ['admin', 'manager'] }) ];

    if ($p->{status} eq 'month') {
        $p->{orders} = [ database->quick_select('orders', "registered >= NOW() - INTERVAL 31 DAY", { order_by => { 'desc' => 'registered' } }) ];
    }
    else {
        my $where = { status => $p->{status} };
        if ($p->{status} ne 'new') {
            $where->{managers_id} = $loged->{id} if $loged->{role} eq 'manager';
        }

        $p->{orders} = [ database->quick_select('orders', $where, { order_by => { 'desc' => 'registered' } }) ];
    }

    for my $o (@{$p->{orders}}) {
        $o->{user} = database->quick_select('users', { id => $o->{users_id} }) if $o->{users_id};
        $o->{manager} = database->quick_select('users', { id => $o->{managers_id} }) if $o->{managers_id};
        $o->{product_list} = [ database->quick_select('orders_products', { orders_id => $o->{id} }) ];

        if ($o->{bills_id}) {
            $o->{bill} = database->quick_select('bills', { id => $o->{bills_id} });
        }
    }

    return template 'admin/orders.tpl', $p;
};

get '/to/:action/:id/' => sub {
    my $loged = vars->{loged};

    if (params->{action} eq 'process') {
        my $order = database->quick_select('orders', { id => params->{id}, status => 'new' });
        if ($order->{id}) {
            database->quick_update('orders', { id => $order->{id} }, { status => 'process', managers_id => $loged->{id} });

            func::send_sms(
                phone   => $order->{phone},
                message => "Заказ номер $order->{id} взят в обработку. Ваш менеджер - $loged->{fio}",
            );

            return redirect "http://". request->host ."/admin/orders/process/";
        }
    }
    elsif (params->{action} eq 'new') {
        my $order = database->quick_select('orders', { id => params->{id}, status => 'process', managers_id => $loged->{id} });
        if (!$order->{bills_id} and $order->{id}) {
            database->quick_update('orders', { id => $order->{id} }, { status => 'new', managers_id => undef });
        }
    }
    elsif (params->{action} eq 'done') {
        my $order = database->quick_select('orders', { id => params->{id}, status => 'process', managers_id => $loged->{id} });
        if (!$order->{bills_id} and $order->{id}) {
            database->quick_update('orders', { id => $order->{id} }, { status => 'done' });
        }
    }
    elsif (params->{action} eq 'cancel') {
        my $order = database->quick_select('orders', { id => params->{id}, status => 'process', managers_id => $loged->{id} });
        if ($order->{id}) {
            database->quick_update('orders', { id => $order->{id} }, { status => 'cancel' });
            if ($order->{bills_id}) {
                database->quick_delete('bills', { id => $order->{bills_id} });
            }
        }
    }
    elsif (params->{action} eq 'bill') {
        my $order = database->quick_select('orders', { id => params->{id}, status => 'process', managers_id => $loged->{id} });
        if ($order->{id}) {
            database->quick_update('bills',
                { managers_id => $loged->{id}, status => 'current' },
                { status => 'stop' }
            );
            database->quick_insert('bills', { managers_id => $loged->{id}, comments => $order->{products}, status => 'current' });
            my $bills_id = database->last_insert_id(undef, undef, undef, undef);

            my $products = [ database->quick_select('orders_products', { orders_id => $order->{id} }) ];
            for my $p (@$products) {
                database->quick_insert('bills_products',
                    { bills_id => $bills_id, products_id => $p->{products_id}, name => $p->{name}, quantity => $p->{quantity}, price => $p->{price} }
                );
            }

            database->quick_update('orders', { id => $order->{id} }, { bills_id => $bills_id });
        }
        return redirect "http://". request->host ."/admin/bills/";
    }

    return redirect "http://". request->host ."/admin/orders/new/";
};

ajax '/del/:id/' => sub {
    my $loged = vars->{loged};

    my $status = 'new';
    my $where = {
        id => params->{id},
        status => ['new', 'process']
    };
    $where->{users_id} = $loged->{id} if $loged->{role} eq 'manager';

    my $order = database->quick_select('orders', $where);
    if ($order->{id}) {
        if ($order->{file}) {
            unlink vars->{orders_dir} . "/$order->{file}" if -f vars->{orders_dir} . "/$order->{file}";
        }

        database->quick_delete('orders', { id => $order->{id} });
        if ($order->{bills_id}) {
            database->quick_delete('bills', { id => $order->{bills_id} });
        }
        $status = $order->{status};
    }

    return 1;
};

post '/to/:action/:id/' => sub {
    my $loged = vars->{loged};

    if (params->{action} eq 'manager') {
        if (params->{managers_id} and $loged->{role} eq 'admin') {
            my $order = database->quick_select('orders', { id => params->{id}, bills_id => undef });
            if ($order->{id}) {
                database->quick_update('orders', { id => $order->{id} }, { managers_id => params->{managers_id} });
            }
        }
    }
    elsif (params->{action} eq 'done') {
        my $order = database->quick_select('orders', { id => params->{id}, status => 'process', managers_id => $loged->{id} });
        if ($order->{id}) {
            my $res = Bills::pay_bill( bills_id => $order->{bills_id}, comments => params->{comments} );
            if ($res == 1) {
                database->quick_update('orders', { id => $order->{id} }, { status => 'done' });
                return redirect "http://". request->host ."/admin/bills/";
            }
        }
    }

    return redirect "http://". request->host ."/admin/orders/process/";
};

true;
