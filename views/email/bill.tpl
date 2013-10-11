<script>
    $(function() {
        $('.js_send').click(function(){
            $.ajax({
                type: "POST",
                url: "/admin/bill/send/[% id %]/",
                success: function(ans) {
                    $('.js_wait').hide();
                    alert('Счет отправлен на почту!');
                },
                error: function(ans) {
                    alert('Операция не позволяется!');
                }
            });
        });

        $('.js_print').click(function(){
            $('#js_div_buttons').hide();
            window.print();
            $('#js_div_buttons').show();
        });
        $('.js_print2').click(function(){
            $('#js_div_buttons').hide();
            $('#js_stamp').hide();
            window.print();
            $('#js_div_buttons').show();
        });
    });
</script>

<div style="width: 1000px; font-size: 11pt; font-family: sans;">
    <div style="font-weight: bold;">[% vars.glob_vars.seller.firm %]</div>
    <div>[% vars.glob_vars.seller.legal_address %]</div>

    <div style="padding-top: 30px; font-weight: bold; text-align: center;">Реквизиты для заполнения платежного поручения</div>
    <table border="1" style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: 1px solid black;">
        <tr>
            <td>ИНН [% vars.glob_vars.seller.inn %]</td>
            <td>КПП [% vars.glob_vars.seller.kpp %]</td>
            <td rowspan="2" valign="top">Сч. №</td>
            <td rowspan="2" valign="top">[% vars.glob_vars.seller.current_account %]</td>
        </tr>
        <tr>
            <td colspan="2">[% vars.glob_vars.seller.firm %]</td>
        </tr>
        <tr>
            <td rowspan="2" colspan="2" style="width: 65%;">Банк продавца<br>[% vars.glob_vars.seller.bank %]</td>
            <td style="width: 10%;">БИК</td>
            <td style="border-bottom-color: white;">[% vars.glob_vars.seller.bik %]</td>
        </tr>
        <tr>
            <td>Сч. №</td>
            <td>[% vars.glob_vars.seller.correspondent_account %]</td>
        </tr>
    </table>

    <div style="font-size: 10pt; padding: 20px 30px 0px 30px; align: center;">
        "Внимание! Оплата данного счета означает согласие с условиями поставки товара. Уведомление об оплате обязательно, в противном случае не гарантируется наличие товара на складе. Товар отпускается по факту прихода денег на р/с Поставщика, самовывозом, при наличии доверенности и паспорта."
    </div>

    <div style="font-size: 18pt; padding: 30px; font-weight: bold; text-align: center;">Счет № S-[% id %] от [% date %]</div>
    <table style="width: 100%; border-spacing: 0px; border-collapse: collapse;">
        <tr>
            <td width="120px;">Покупатель:</td>
            <td style="border-bottom: 1px solid black;">[% buyer.type == 'ph' ? buyer.fio : buyer.firm %]</td>
        </tr>
        <tr>
            <td>Адрес:</td>
            <td style="border-bottom: 1px solid black;">[% buyer.address %]</td>
        </tr>
        <tr>
            <td>ИНН/КПП:</td>
            <td style="border-bottom: 1px solid black;">[% buyer.inn %]/[% buyer.kpp %]</td>
        </tr>
    </table>

    <br>

    <table border="1" style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: 1px solid black;">
        <tr>
            <th>№</th>
            <th>Наименование товара</th>
            <th>ЕД. изм</th>
            <th>Кол-во</th>
            <th>Цена за ед., без НДС, руб</th>
            <th>Сумма без НДС, руб.</th>
            <th>НДС %</th>
            <th>Сумма НДС, руб.</th>
            <th>Всего с НДС, руб.</th>
        </tr>
        [%
            SET total = {
                'quantity'          => 0,
                'price'             => 0,
                'price_without_nds' => 0,
                'sum'               => 0,
                'sum_without_nds'   => 0,
                'nds'               => 0,
            };

            IF delivery_by_positions;
                SET plus = delivery / products.size;
            END;

            FOR p IN products;
                IF plus;
                    p.price = p.price + plus / p.quantity;
                END;

                SET p.sum = p.quantity * p.price;
                SET p.sum_without_nds = (p.sum / 118) * 100;
                SET p.price_without_nds = (p.price / 118) * 100;
                SET p.nds = (p.price / 118) * 18;

                FOR f IN total;
                    total.${f.key} = total.${f.key} + p.${f.key};
                END;
        %]
            <tr>
                <td>[% loop.count %]</td>
                <td>[% p.name %]</td>
                <td></td>
                <td>[% p.quantity %]</td>
                <td>[% USE String(p.price_without_nds); String.format('%02.2f'); %]</td>
                <td>[% USE String(p.sum_without_nds); String.format('%02.2f'); %]</td>
                <td>18</td>
                <td>[% USE String(p.nds); String.format('%02.2f'); %]</td>
                <td>[% USE String(p.sum); String.format('%02.2f'); %]</td>
            </tr>
        [% END %]
        <tr>
            <td colspan="3">Итого:</td>
            <td>[% total.quantity %]</td>
            <td>[% USE String(total.price_without_nds); String.format('%02.2f'); %]</td>
            <td>[% USE String(total.sum_without_nds); String.format('%02.2f'); %]</td>
            <td>-</td>
            <td>[% USE String(total.nds); String.format('%02.2f'); %]</td>
            <td>[% USE String(total.sum); String.format('%02.2f'); %]</td>
        </tr>
    </table>
    <div>Всего наименований [% products.size %], на сумму [% total.sum %] рублей.</div>
    <div>Сумма прописью: [% func.price_in_words(total.sum) %]. Без НДС.</div>

    <div style="padding-top: 30px;"></div>
    <table style="width: 1000px">
        <tr>
            <td style="width: 150px;">Руководитель предприятия</td>
            <td style="width: 350px; border-bottom: 1px solid black;">
                [% vars.glob_vars.seller.general_manager %]
            </td>
            <td style="width: 120px;text-align: right;">Бухгалтер</td>
            <td style="width: 350px; border-bottom: 1px solid black;">
                [% vars.glob_vars.seller.main_accountant %]
            </td>
        </tr>
    </table>
    <div style="position: relative; top: -55px; left: 430px;">
        <img src="http://[% request.env.HTTP_HOST %]/images/podpis.png" width="100px">
    </div>

    <div style="position: relative; top: -135px; left: 910px;">
        <img src="http://[% request.env.HTTP_HOST %]/images/podpis.png" width="100px">
    </div>

    <div style="font-size: 10pt; padding: 0px 60px 60px 60px;">
        Обращаем Ваше внимание на то, что для осуществления платежа мы выставляем Вам СЧЕТ. Следовательно если Вами была произведена оплата по СЧЕТУ, то СЧЕТ-ФАКТУРУ оплачивать не надо. Во избежание ошибок, просим Вас быть внимательными!
    </div>
    <div style="position: relative; top: -250px; left: 100px;" id="js_stamp"><img src="http://[% request.env.HTTP_HOST %]/images/pechat.png" width="250px"></div>

    [% UNLESS clean %]
        <div id="js_div_buttons">
            <button class="js_print">Печать (с печатями)</button>
            <button class="js_print2">Печать (без печатей)</button>
            <button class="js_wait js_send">Отослать на почту</button>
            <button class="js_wait" onClick="location.href='/admin/bill/note/invoice/[% id %]/'">Счет-фактура</button>
            <button class="js_wait" onClick="location.href='/admin/bill/note/delivery/[% id %]/'">Накладная</button>
        </div>
    [% END %]
</div>
