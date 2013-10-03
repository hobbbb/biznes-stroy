<script>
    $(function() {
        $('.js_print').click(function(){
            $('#js_div_buttons').hide();
            window.print();
            $('#js_div_buttons').show();
        });
    });
</script>

<div style="width: 1000px;">
    <h3>СЧЕТ-ФАКТУРА ?3791? от ?24 Июня 2013 г.?</h3>
    <div>ИСПРАВЛЕНИЕ № --- от ---</div>
    <div>Продавец: [% vars.glob_vars.${'seller.firm'} %]</div>
    <div>Адрес: [% vars.glob_vars.${'seller.legal_address'} %]</div>
    <div>ИНН/КПП продавца: [% vars.glob_vars.${'seller.inn'} %] / [% vars.glob_vars.${'seller.kpp'} %]</div>
    <div>Грузоотправитель и его адрес: [% vars.glob_vars.${'seller.firm'} %]</div>
    <div>Грузополучатель и его адрес: [% buyer.type == 'ph' ? buyer.fio : buyer.firm %]</div>
    <div>К платежно-расчетному документу №  ________ от ________________</div>
    <div>Покупатель: [% buyer.type == 'ph' ? buyer.fio : buyer.firm %]</div>
    <div>Адрес: [% buyer.legal_address %]</div>
    <div>ИНН/КПП покупателя: [% buyer.inn %] / [% buyer.kpp %]</div>
    <div>Валюта: наименование, код: Российский рубль, 643</div>

    <br>

    <table border="1" style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: 1px solid black;">
        <tr>
            <th rowspan="2">Наименование товара (описание выполненных работ, оказанных услуг), иму- щественного права</th>
            <th colspan="2">Единица измерения </th>
            <th rowspan="2">Количество (объем)</th>
            <th rowspan="2">Цена (тариф) за единицу измерения</th>
            <th rowspan="2">Стоимость товаров (работ,  услуг), иму- щественных прав без налога -всего</th>
            <th rowspan="2">В том числе сумма акциза</th>
            <th rowspan="2">Налоговая ставка</th>
            <th rowspan="2">Сумма налога, предъявля- емая покупа- телю</th>
            <th rowspan="2">Стоимость товаров (работ, услуг), иму- щественных прав с налогом - всего</th>
            <th colspan="2">Страна происхождения товара</th>
            <th rowspan="2">Номер таможенной декларации</th>
        </tr>
        <tr>
            <th>код</th>
            <th>условное обозначение (национальное)</th>
            <th>цифровой код</th>
            <th>краткое наиме- нование</th>
        </tr>
        <tr>
            <th>1</th>
            <th>2</th>
            <th>2а</th>
            <th>3</th>
            <th>4</th>
            <th>5</th>
            <th>6</th>
            <th>7</th>
            <th>8</th>
            <th>9</th>
            <th>10</th>
            <th>10а</th>
            <th>11</th>
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

            FOR p IN products;
                SET p.sum = p.quantity * p.price;
                SET p.sum_without_nds = (p.sum / 118) * 100;
                SET p.price_without_nds = (p.price / 118) * 100;
                SET p.nds = (p.price / 118) * 18;

                FOR f IN total;
                    total.${f.key} = total.${f.key} + p.${f.key};
                END;
        %]
            <tr>
                <td>[% p.name %]</td>
                <td></td>
                <td></td>
                <td>[% p.quantity %]</td>
                <td>[% USE String(p.price); String.format('%02.2f'); %]</td>
                <td>[% USE String(p.price_without_nds); String.format('%02.2f'); %]</td>
                <td>Без акциза</td>
                <td>18%</td>
                <td>[% USE String(p.nds); String.format('%02.2f'); %]</td>
                <td>[% USE String(p.sum); String.format('%02.2f'); %]</td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        [% END %]
        <tr>
            <td colspan="5">Всего к оплате</td>
            <td>[% USE String(total.price_without_nds); String.format('%02.2f'); %]</td>
            <td colspan="2">x</td>
            <td>[% USE String(total.nds); String.format('%02.2f'); %]</td>
            <td>[% USE String(total.sum); String.format('%02.2f'); %]</td>
            <td colspan="3"></td>
        </tr>
    </table>

    <br><br>

    <table border="0" style="width: 100%; border-spacing: 0px; border-collapse: collapse;">
        <colgroup>
            <col width="">
            <col width="100px">
            <col width="20px">
            <col width="150px">
            <col width="">
            <col width="">
            <col width="100px">
            <col width="20px">
            <col width="150px">
        </colgroup>
        <tr>
            <td>Руководитель организации или иное уполномоченное лицо:</td>
            <td style="border-bottom: 1px solid black;"></td>
            <td></td>
            <td style="border-bottom: 1px solid black;"></td>
            <td colspan="2">Главный бухгалтер или иное уполномоченное лицо:</td>
            <td style="border-bottom: 1px solid black;"></td>
            <td></td>
            <td style="border-bottom: 1px solid black;"></td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align: center; font-size: 10pt;">подпись</td>
            <td></td>
            <td style="text-align: center; font-size: 10pt;">ф.и.о</td>
            <td colspan="2"></td>
            <td style="text-align: center; font-size: 10pt;">подпись</td>
            <td></td>
            <td style="text-align: center; font-size: 10pt;">ф.и.о</td>
        </tr>
        <tr>
            <td>Индивидуальный предприниматель:</td>
            <td style="border-bottom: 1px solid black;"></td>
            <td></td>
            <td style="border-bottom: 1px solid black;"></td>
            <td></td>
            <td colspan="4" style="border-bottom: 1px solid black;"></td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align: center; font-size: 10pt;">подпись</td>
            <td></td>
            <td style="text-align: center; font-size: 10pt;">ф.и.о</td>
            <td></td>
            <td colspan="4" style="text-align: center; font-size: 10pt;">реквизиты свидетельства о государственной регистрации индивидуального предпринимателя</td>
        </tr>
    </table>
</div>

<div id="js_div_buttons" style="padding-top: 50px;">
    <button class="js_print">Печать</button>
</div>
