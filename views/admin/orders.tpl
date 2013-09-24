[% PROCESS inc/vars.tpl %]

<div class="row-fluid">
    <div class="span12">
        <h3>[% orders_status.$status || 'Все' %]</h3>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th class="span1">№</th>
                    <th>Товар</th>
                    <th>Поставщик</th>
                    <th>Кол-во</th>
                    <th>Цена</th>
                    <th>Время</th>
                    <th>Доставка / Оплата</th>
                    <th>Контакты</th>
                    <th>Комментарии</th>
                    <th>Продукты</th>
                    <th>Реквизиты</th>
                    [% IF vars.loged.acs.admin %]<th>Менеджер</th>[% END %]
                    <th class="span1"></th>
                </tr>
            </thead>
            <tbody>
            [% FOR i = orders;
                IF i.product_list.size; SET itogo = i.product_list.0.price * i.product_list.0.quantity; END;
                SET odd = loop.index % 2 == 0 ? 1 : 0;
            %]
                <tr [% 'style="background-color: #F5F5F5;"' IF odd %] data-linked_del="[% i.id %]">
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.id %]</td>
                    <td><a href="/products/[% i.product_list.0.products_id %]/" target="_blank">[% i.product_list.0.name %]</a></td>
                    <td>[% i.product_list.0.supplier || '-' %]</td>
                    <td>[% i.product_list.0.quantity %]</td>
                    <td>[% i.product_list.0.price %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.registered %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% shipping.${i.shipping} %]<br>[% payment.${i.payment} %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">
                        [% i.phone | html %]<br>
                        [% i.fio | html %] [% '<a href="#" class="tt" data-toggle="tooltip" data-placement="top" title="Оформил: ' _ i.user.fio _ '"><i class="icon-info-sign"></i></a>' IF i.user.id %]<br>
                        [% i.email | html %]
                        <script>$('.tt').tooltip()</script>
                    </td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.comments | html | replace('\n', '<br>') %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.products | html | replace('\n', '<br>') %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.file ? '<a href="/upload/orders/' _ i.file _ '" target="_blank">' _ i.file _ '</a>' : '-' %]</td>
                    [% IF vars.loged.acs.admin %]
                        <td rowspan="[% i.product_list.size + 1 %]">[% i.manager.fio %]</td>
                    [% END %]
                    <td rowspan="[% i.product_list.size + 1 %]">
                        [% IF status == 'new' %]
                            <div><a href="javascript: void(0)" data-url="/admin/orders/to/process/[% i.id %]/" class="js_order_process"><i class="icon-folder-open" title="Взять в обработку"></i></a></div>
                            <div><a href="javascript: void(0)" data-url="/admin/orders/del/[% i.id %]/" class="js_delete"><i class="icon-trash"></i></a></div>
                        [% ELSIF status == 'process' %]
                            [% IF i.bills_id %]
                                [% IF i.bill.status == 'wait' %]
                                    <div><a href="#modal_bill_payment" data-toggle="modal" class="js_order_bill_payment" data-orders_id="[% i.id %]"><i class="icon-ok" title="Оплатить и Завершить"></i></a></div>
                                [% END %]
                                <div><a href="javascript: void(0)" data-url="/admin/orders/to/cancel/[% i.id %]/" class="js_order_cancel"><i class="icon-remove" title="Отменить"></i></a></div>
                            [% ELSE %]
                                [% IF vars.loged.id == i.managers_id %]
                                    <div><a href="javascript: void(0)" data-url="/admin/orders/to/new/[% i.id %]/" class="js_order_new"><i class="icon-folder-close" title="Отменить обработку"></i></a></div>
                                    <div><a href="javascript: void(0)" data-url="/admin/orders/to/done/[% i.id %]/" class="js_order_done"><i class="icon-ok" title="Завершить"></i></a></div>
                                    <div><a href="javascript: void(0)" data-url="/admin/orders/to/cancel/[% i.id %]/" class="js_order_cancel"><i class="icon-remove" title="Отменить"></i></a></div>
                                    <div><a href="/admin/orders/to/bill/[% i.id %]/"><i class="icon-list-alt" title="Выставить счет"></i></a></div>
                                [% END %]
                                [% IF vars.loged.acs.admin %]<div><a href="#modal_to_manager" data-toggle="modal" class="js_to_manager" data-orders_id="[% i.id %]" data-managers_id="[% i.managers_id %]"><i class="icon-random" title="Передать в обработку"></i></a></div>[% END %]
                            [% END %]
                            <div><a href="javascript: void(0)" data-url="/admin/orders/del/[% i.id %]/" class="js_delete"><i class="icon-trash"></i></a></div>
                    [% END %]
                    </td>
                </tr>
                [% FOR p = i.product_list; NEXT IF loop.first; SET itogo = itogo + p.price * p.quantity; %]
                    <tr [% 'style="background-color: #F5F5F5;"' IF odd %]>
                        <td><a href="/products/[% p.products_id %]/" target="_blank">[% p.name %]</a></td>
                        <td>[% p.supplier || '-' %]</td>
                        <td>[% p.quantity %]</td>
                        <td>[% p.price %]</td>
                    </tr>
                [% END %]
                [% IF i.product_list.size; %]
                <tr class="js_linked_del_[% i.id %]">
                    <td colspan="4" style="font-weight: bold; text-align: right; [% 'background-color: #F5F5F5;' IF odd %]">
                        <div>
                            [% IF i.discount %]
                                Скидка: [% i.discount %]%; Итого: [% itogo - itogo * i.discount / 100 %]
                            [% ELSE %]
                                Итого: [% itogo %] руб.
                            [% END %]
                        </div>
                        <div>
                            [% 'Итого с доставкой: ' _ (itogo + (vars.glob_vars.delivery_price || 0)) _ ' руб.'
                                IF i.shipping == 'delivery' %]
                            [% 'Итого с доставкой: ' _ (itogo + (vars.glob_vars.delivery_price || 0) + (vars.glob_vars.delivery_mkad_price || 0) * i.mkad) _ ' руб.'
                                IF i.shipping == 'delivery_mkad' %]
                        </div>
                    </td>
                </tr>
                [% END %]
            [% END %]
            </tbody>
        </table>
    </div>
</div>

<div id="modal_bill_payment" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <form class="form-horizontal" method="post" action="">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Оплата счета</h3>
        </div>
        <div class="modal-body">
            <div class="control-group">
                <label class="control-label" for="comments">Комментарии</label>
                <div class="controls"><textarea id="comments" name="comments"></textarea></div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary">Оплатить счет</button>
        </div>
    </form>
</div>

<div id="modal_to_manager" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <form class="form-horizontal" method="post" action="">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Передать в обработку</h3>
        </div>
        <div class="modal-body">
            <div class="control-group">
                <label class="control-label" for="managers_id">Менеджер</label>
                <div class="controls">
                    <select name="managers_id" id="managers_id">
                        [% FOR m IN managers %]
                            <option value="[% m.id %]">[% m.fio %]</option>
                        [% END %]
                    </select>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary">Передать</button>
        </div>
    </form>
</div>
