[% PROCESS inc/vars.tpl %]

Номер заказа: [% order.data.id %]<br>
Доставка: [% shipping.${order.data.shipping} %]<br>
Оплата: [% payment.${order.data.payment} %]<br>
Телефон: [% order.data.phone %]<br>
[% 'ФИО: ' _ order.data.fio _ '<br>' IF order.data.fio %]
[% 'E-mail:  ' _ order.data.email _ '<br>' IF order.data.email %]
[% 'Комментарии: ' _ order.data.comments _ '<br>' IF order.data.comments %]
[% 'Товары: ' _ order.data.products _ '<br>' IF order.data.products %]
[% 'Скидка: ' _ order.data.discount _ '%<br>' IF order.data.discount %]

[% SET itogo = 0; FOR p = order.product_list; SET itogo = itogo + (p.quantity * p.price); %]
    <p>
        Товар: [% p.name %]<br>
        [% IF p.manufacturer %]Производитель: [% p.manufacturer.name %]<br>[% END %]
        Количество: [% p.quantity %]<br>
        Цена: [% p.price %] руб.<br>
        Сумма: [% p.price * p.quantity %] руб.<br>
    </p>
[% END %]

[% IF order.data.discount %]
    Итого: [% itogo - itogo * order.data.discount / 100 %] руб.<br>
[% ELSE %]
    Итого: [% itogo %] руб.<br>
[% END %]

[% 'Итого с доставкой: ' _ (itogo + (vars.glob_vars.delivery_price || 0)) _ ' руб.' IF order.data.shipping == 'delivery' %]
[% 'Итого с доставкой: ' _ (itogo + (vars.glob_vars.delivery_price || 0) + (vars.glob_vars.delivery_mkad_price || 0) * order.data.mkad) _ ' руб.' IF order.data.shipping == 'delivery_mkad' %]
