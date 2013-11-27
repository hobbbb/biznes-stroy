[%-
    PROCESS inc/vars.tpl;
    SET itogo = func.order_itogo(order.data.id);
-%]

Номер заказа: [% order.data.id %]<br>
Доставка: [% shipping.${order.data.shipping} %]<br>
Оплата: [% payment.${order.data.payment} %]<br>
Телефон: [% order.data.phone %]<br>
[% 'ФИО: ' _ order.data.fio _ '<br>' IF order.data.fio %]
[% 'E-mail:  ' _ order.data.email _ '<br>' IF order.data.email %]
[% 'Комментарии: ' _ order.data.comments _ '<br>' IF order.data.comments %]
[% 'Товары: ' _ order.data.products _ '<br>' IF order.data.products %]
[% 'Скидка: ' _ order.data.discount _ '%<br>' IF order.data.discount %]

[% FOR p = order.product_list %]
    <p>
        Товар: [% p.name %]<br>
        [% IF p.manufacturer %]Производитель: [% p.manufacturer.name %]<br>[% END %]
        Количество: [% p.quantity %]<br>
        Цена: [% p.price %] руб.<br>
        Сумма: [% p.price * p.quantity %] руб.<br>
    </p>
[% END %]

Итого: [% itogo.overal %] руб.<br>
[% 'Итого с доставкой: ' _ itogo.with_delivery _ ' руб.' IF itogo.with_delivery %]
