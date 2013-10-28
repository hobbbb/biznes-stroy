[%
    SET shipping = {
        'none'          => 'Неизвестно',
        'self'          => 'Самовывоз',
        'delivery'      => 'Доставка',
        'delivery_mkad' => 'Доставка за МКАД',
    };
    SET payment = {
        'cash'          => 'Наличные',
        'cashless'      => 'Безнал',
    };
    SET content_alias = {
        'admin'         => 'Для админки',
        'main'          => 'Главная',
    };
    SET orders_status = {
        'new'           => 'Поступившие',
        'process'       => 'В работе',
        'pickup'        => 'В самовывозе',
        'delivery'      => 'В доставке',
        'done'          => 'Завершенные',
        'cancel'        => 'Отмененные',
    };
    SET bills_status = {
        'current'       => 'Текущий',
        'stop'          => 'Приостановленный',
        'wait'          => 'Ожидает оплаты',
        'paid'          => 'Оплаченный',
    };
%]
