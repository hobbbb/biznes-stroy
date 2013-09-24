[% PROCESS inc/vars.tpl %]

<div class="row-fluid">
    <div class="span7">
        <h3>Счета</h3>

        <table class="table table-hover">
            <thead>
                <tr>
                    <th>№</th>
                    <th>Покупатель</th>
                    <th>Дата</th>
                    <th>Комментарии</th>
                    <th>Статус</th>
                    <th class="span1"></th>
                    <th class="span1"></th>
                </tr>
            </thead>
            <tbody>
            [% FOR i = bills %]
                <tr>
                    <td>S-[% i.id %]</td>
                    <td>[% i.buyer.type == 'ph' ? i.buyer.fio : i.buyer.firm %]</td>
                    <td>[% i.date %]</td>
                    <td>[% i.comments IF i.status == 'paid' %]</td>
                    <td>[% bills_status.${i.status} %]</td>
                    <td>[% IF i.status == 'stop' %]<a href="/admin/bill/to_current/[% i.id %]/"><i class="icon-share" title="Открыть карточку счета"></i></a>[% END %]</td>
                    <td><a href="javascript: void(0)" data-url="/admin/bill/del/[% i.id %]/" class="js_delete"><i class="icon-trash"></i></a></td>
                </tr>
            [% END %]
            </tbody>
        </table>
    </div>

    [% INCLUDE admin/inc/bill_cart.tpl redirect_after_close = '/admin/bills/' %]
</div>
