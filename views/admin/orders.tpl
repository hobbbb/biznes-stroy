[% PROCESS inc/vars.tpl %]

<div class="row-fluid">
    <div class="span12">
        <h3>[% orders_status.$status || 'Все' %]</h3>

        [% IF vars.loged.acs.admin %]
            <ul class="nav nav-pills">
                <li [% 'class="active"' IF type != 'all' %]><a href="/admin/orders/[% status %]/">Свои</a></li>
                <li [% 'class="active"' IF type == 'all' %]><a href="/admin/orders/[% status %]/?type=all">Все</a></li>
            </ul>
        [% END %]

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th class="span1">№</th>
                    <th>Товар</th>
                    <th>Поставщик</th>
                    <th>Кол-во</th>
                    <th>Цена</th>
                    [% '<th>Время</th>' UNLESS vars.loged.acs.driver_only %]
                    <th>Доставка / Оплата</th>
                    <th>Контакты</th>
                    <th>Комментарии</th>
                    <th>Продукты</th>
                    [% '<th>Реквизиты</th>' UNLESS vars.loged.acs.driver_only %]
                    [% '<th>Менеджер</th>' IF vars.loged.acs.admin %]
                    <th class="span3"></th>
                </tr>
            </thead>
            <tbody>
            [% FOR i = orders;
                SET itogo = func.order_itogo(i.id);
                SET odd = loop.index % 2 == 0 ? 1 : 0;
            %]
                <tr [% 'style="background-color: #F5F5F5;"' IF odd %] data-linked_del="[% i.id %]">
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.id %]</td>
                    <td><a href="/products/[% i.product_list.0.products_id %]/" target="_blank">[% i.product_list.0.name %]</a></td>
                    <td>[% i.product_list.0.supplier || '-' %]</td>
                    <td>[% i.product_list.0.quantity %]</td>
                    <td>[% i.product_list.0.price %]</td>
                    [% UNLESS vars.loged.acs.driver_only %]
                        <td rowspan="[% i.product_list.size + 1 %]">[% i.registered %]</td>
                    [% END %]
                    <td rowspan="[% i.product_list.size + 1 %]">[% shipping.${i.shipping} %]<br>[% payment.${i.payment} %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">
                        [% i.phone | html %]<br>
                        [% i.fio | html %] [% '<a href="#" class="tt" data-toggle="tooltip" data-placement="top" title="Оформил: ' _ i.user.fio _ '"><i class="icon-info-sign"></i></a>' IF i.user.id %]<br>
                        [% i.email | html %]
                        <script>$('.tt').tooltip()</script>
                    </td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.comments | html | replace('\n', '<br>') %]</td>
                    <td rowspan="[% i.product_list.size + 1 %]">[% i.products | html | replace('\n', '<br>') %]</td>
                    [% UNLESS vars.loged.acs.driver_only %]
                        <td rowspan="[% i.product_list.size + 1 %]">[% i.file ? '<a href="/upload/orders/' _ i.file _ '" target="_blank">' _ i.file _ '</a>' : '-' %]</td>
                    [% END %]
                    [% IF vars.loged.acs.admin %]
                        <td rowspan="[% i.product_list.size + 1 %]">[% i.manager.fio %]</td>
                    [% END %]
                    <td rowspan="[% i.product_list.size + 1 %]">
                        [% IF status == 'new' %]
                            <div><a href="javascript: void(0)" data-url="/admin/orders/to/process/[% i.id %]/" class="btn btn-mini span12 pd3 js_order_process">Взять в работу</a></div>
                        [% ELSIF status == 'process' %]
                            [% INCLUDE _cancel %]
                            [% IF i.bills_id %]
                                [% IF i.bill.status == 'wait' %]
                                    [% IF 0 %]<div><a href="#modal_bill_payment" data-toggle="modal" class="btn btn-mini span12 pd3 js_order_bill_payment" data-orders_id="[% i.id %]"><i class="icon-ok" title="Оплатить и Завершить заказ"></i></a></div>[% END %]
                                [% END %]
                            [% ELSE %]
                                [% IF vars.loged.id == i.managers_id %]
                                    <!-- <div><a href="javascript: void(0)" data-url="/admin/orders/to/new/[% i.id %]/" class="btn btn-mini span12 pd3 js_order_new"><i class="icon-folder-close" title="Отменить обработку заказа"></i></a></div> -->
                                    <div><a href="/admin/orders/to/bill/[% i.id %]/" class="btn btn-mini span12 pd3">Выставить счет</a></div>
                                    [% IF i.shipping == 'self' %]
                                        <div><a href="/admin/orders/to/pickup/[% i.id %]/" class="btn btn-mini span12 pd3">В самовывоз</a></div>
                                    [% ELSE %]
                                        <div><a href="#modal_to_delivery" data-toggle="modal" class="btn btn-mini span12 pd3 js_to_delivery" data-orders_id="[% i.id %]">В доставку</a></div>
                                    [% END %]
                                [% END %]

                                [% IF vars.loged.acs.admin %]
                                    <div><a href="#modal_to_manager" data-toggle="modal" class="btn btn-mini span12 pd3 js_to_manager" data-orders_id="[% i.id %]" data-managers_id="[% i.managers_id %]">Передать другому</a></div>
                                [% END %]
                            [% END %]
                        [% ELSIF status == 'pickup' %]
                            [% IF vars.loged.id == i.managers_id %]
                                [% INCLUDE _cancel %]
                                [% INCLUDE _done %]
                            [% END %]
                        [% ELSIF status == 'delivery' %]
                            [% IF vars.loged.acs.admin OR vars.loged.acs.driver %]
                                [% INCLUDE _done big = 1 %]
                            [% END %]
                        [% END %]

                        [% UNLESS status.grep('^pickup|delivery|done|cancel$').size %]
                            [% INCLUDE _not_available %]
                            [% IF vars.loged.acs.admin %]
                                [% INCLUDE _delete %]
                            [% END %]
                        [% END %]
                    </td>
                </tr>
                [% FOR p = i.product_list; NEXT IF loop.first; %]
                    <tr [% 'style="background-color: #F5F5F5;"' IF odd %] class="js_linked_del_[% i.id %]">
                        <td><a href="/products/[% p.products_id %]/" target="_blank">[% p.name %]</a></td>
                        <td>[% p.supplier || '-' %]</td>
                        <td>[% p.quantity %]</td>
                        <td>[% p.price %]</td>
                    </tr>
                [% END %]
                [% IF i.product_list.size; %]
                <tr class="js_linked_del_[% i.id %]">
                    <td colspan="4" style="font-weight: bold; text-align: right; [% 'background-color: #F5F5F5;' IF odd %]">
                        <div>Итого: [% itogo.overal %] руб.</div>
                        <div>[% 'Итого с доставкой: ' _ itogo.with_delivery _ ' руб.' IF itogo.with_delivery %]</div>
                    </td>
                </tr>
                [% END %]
            [% END %]
            </tbody>
        </table>
    </div>
</div>

[% BLOCK _cancel %]
    <div><a href="javascript: void(0)" data-url="/admin/orders/to/cancel/[% i.id %]/" class="btn btn-mini span12 pd3 js_order_cancel"><i class="icon-remove"></i> Отменить</a></div>
[% END %]

[% BLOCK _done %]
    <div><a href="javascript: void(0)" data-url="/admin/orders/to/done/[% i.id %]/" class="btn btn-[% big ? 'large' : 'mini' %] span12 pd3 js_order_done"><i class="icon-ok"></i> Завершить</a></div>
[% END %]

[% BLOCK _delete %]
    <div><a href="javascript: void(0)" data-url="/admin/orders/del/[% i.id %]/" class="btn btn-mini span12 pd3 js_delete"><i class="icon-trash"></i> Удалить</a></div>
[% END %]

[% BLOCK _not_available %]
    <div><a href="javascript: void(0)" data-url="/admin/orders/to/cancel/[% i.id %]/?reason=not_available" class="btn btn-mini span12 pd3 js_order_cancel"><i class="icon-remove"></i> Нет в наличии</a></div>
[% END %]

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

<div id="modal_to_delivery" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <form class="form-horizontal" method="get" action="">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Дата доставки</h3>
        </div>
        <div class="modal-body">
            <div class="control-group">
                <label class="control-label" for="date">Дата</label>
                <div class="controls">
                    <div class="input-append">
                        <input type="text" id="date" name="date" value="" class="datepicker">
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary">В доставку</button>
        </div>
    </form>
</div>
