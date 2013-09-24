<style>
    table { width: 100%; border-spacing: 0px; border-collapse: collapse; }
    .cc td { text-align: center; }
    .lbl { text-align: center; font-size: 8pt; }
    .bb { border-bottom: 1px solid black; }
    .ar { text-align: right!important; }
    .ac { text-align: center!important; }
    .B { border: 1px solid black; }
</style>

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
    <div class="ar">Унифицированная форма № [% buyer.type == 'ur' ? 'ТОРГ-12' : 'ОП-4' %]</div>
    <div class="ar">Утверждена постановлением Госкомстата России от 25.12.98 № 132</div>

[% IF buyer.type == 'ur' %]

    <table border="0">
        <colgroup>
            <col width="130px">
            <col width="">
            <col width="">
            <col width="150px">
            <col width="150px">
        </colgroup>
        <tr>
            <td colspan="4"></td>
            <td class="B ac">Код</td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td class="ar">Форма по  ОКУД</td>
            <td class="B ac">0330212</td>
        </tr>
        <tr>
            <td colspan="3" class="bb"></td>
            <td class="ar">по ОКПО</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td colspan="3" class="lbl">организация-грузоотправитель, адрес, телефон, факс, банковские реквизиты</td>
            <td></td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td colspan="4" class="bb">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="3" class="lbl">структурное подразделение</td>
            <td class="ar">Вид деятельности по ОКДП</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td>Грузополучатель</td>
            <td colspan="2" class="bb"></td>
            <td class="ar">по ОКПО</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="2" class="lbl">наименование организации, адрес, номер телефона, банковские реквизиты</td>
            <td></td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td>Поставщик</td>
            <td colspan="2" class="bb"></td>
            <td class="ar">по ОКПО</td>
        </tr>
        <tr>
            <td></td>
            <td colspan="2" class="lbl">наименование организации, адрес, номер телефона, банковские реквизиты</td>
            <td></td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td>Плательщик</td>
            <td colspan="2" class="bb"></td>
            <td class="bb ar">по ОКПО</td>
        </tr>
        <tr>
            <td></td>
            <td colspan="2" class="lbl">наименование организации, адрес, номер телефона, банковские реквизиты</td>
            <td rowspan="2" class="ar B">номер</td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td>Основание</td>
            <td colspan="2" class="bb"></td>
        </tr>
        <tr>
            <td colspan="3" class="lbl">договор, заказ-наряд</td>
            <td class="ar B">дата</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td colspan="2"></td>
            <td class="ar">Транспортная накладная</td>
            <td class="ar B">номер</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td class="ar B">дата</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td class="ar">Вид операции</td>
            <td class="B"></td>
        </tr>
    </table>

    <br><br>

    <table border="0" align="center" style="width: 50%;">
        <tr>
            <td></td>
            <td class="B">Номер документа</td>
            <td class="B">Дата составления</td>
        </tr>
        <tr>
            <td>ТОВАРНАЯ НАКЛАДНАЯ</td>
            <td style="border: 2px solid black;"></td>
            <td style="border: 2px solid black;"></td>
        </tr>
    </table>

    <br><br>

    <table border="1" class="B cc">
        <tr>
            <th rowspan="2">Номер по порядку</th>
            <th colspan="2">Товар</th>
            <th colspan="2">Единица измерения</th>
            <th rowspan="2">Вид упаковки</th>
            <th colspan="2">Количество</th>
            <th rowspan="2">Масса брутто</th>
            <th rowspan="2">Количество (масса нетто)</th>
            <th rowspan="2">Цена, руб. коп.</th>
            <th rowspan="2">Сумма без учета НДС, руб. коп.</th>
            <th colspan="2">НДС</th>
            <th rowspan="2">Сумма с учетом НДС, руб. коп.</th>
        </tr>
        <tr>
            <th>наименование, характеристика, сорт, артикул товара</th>
            <th>код</th>
            <th>наименование</th>
            <th>код по ОКЕИ</th>
            <th>в одном месте</th>
            <th>мест, штук</th>
            <th>ставка, %</th>
            <th>сумма, руб. коп.</th>
        </tr>
        <tr>
            <th>1</th>
            <th>2</th>
            <th>3</th>
            <th>4</th>
            <th>5</th>
            <th>6</th>
            <th>7</th>
            <th>8</th>
            <th>9</th>
            <th>10</th>
            <th>11</th>
            <th>12</th>
            <th>13</th>
            <th>14</th>
            <th>15</th>
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
                <td>[% loop.count %]</td>
                <td>[% p.name %]</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>[% USE String(p.sum_without_nds); String.format('%02.2f'); %]</td>
                <td>18</td>
                <td>[% USE String(p.nds); String.format('%02.2f'); %]</td>
                <td>[% USE String(p.sum); String.format('%02.2f'); %]</td>
            </tr>
        [% END %]
        <tr>
            <td colspan="7" class="ar">Итого</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td>[% USE String(total.sum_without_nds); String.format('%02.2f'); %]</td>
            <td>-</td>
            <td>[% USE String(total.nds); String.format('%02.2f'); %]</td>
            <td>[% USE String(total.sum); String.format('%02.2f'); %]</td>
        </tr>
    </table>

    <br><br>

    <table border="0">
        <colgroup>
            <col width="100px">
            <col width="">
            <col width="">
            <col width="150px">
            <col width="150px">
            <col width="150px">
        </colgroup>
        <tr>
            <td colspan="2">Товарная накладная имеет приложение на</td>
            <td colspan="2" class="bb"></td>
            <td colspan="2">листах</td>
        </tr>
        <tr>
            <td>и содержит</td>
            <td colspan="3" class="bb"></td>
            <td colspan="2">порядковых номеров записей</td>
        </tr>
        <tr>
            <td></td>
            <td colspan="3" class="lbl">прописью</td>
            <td></td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td colspan="2"></td>
            <td style="text-align: center;">Масса груза (нетто)</td>
            <td colspan="2" class="bb"></td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td colspan="2" class="lbl">прописью</td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td>Всего мест</td>
            <td class="bb"></td>
            <td style="text-align: center;">Масса груза (брутто)</td>
            <td colspan="2" class="bb"></td>
        </tr>
        <tr>
            <td></td>
            <td class="lbl">прописью</td>
            <td></td>
            <td colspan="2" class="lbl">прописью</td>
            <td></td>
        </tr>
    </table>

    <br><br>

    <span style="width: 50%; float: left;">
        <table border="0" style="width: 95%;">
            <colgroup>
                <col width="">
                <col width="">
                <col width="20px">
                <col width="40px">
                <col width="20px">
                <col width="40px">
                <col width="40px">
                <col width="40px">
            </colgroup>
            <tr>
                <td colspan="4">Приложение (паспорта, сертификаты и т.п.) на</td>
                <td colspan="3" class="bb"></td>
                <td>листах</td>
            </tr>
            <tr>
                <td colspan="4"></td>
                <td colspan="3" class="lbl">прописью</td>
                <td></td>
            </tr>
            <tr>
                <td colspan="4">Всего отпущено на сумму</td>
                <td colspan="4" class="bb"></td>
            </tr>
            <tr>
                <td colspan="4"></td>
                <td colspan="4" class="lbl">прописью</td>
            </tr>
            <tr>
                <td colspan="5" class="bb"></td>
                <td>руб.</td>
                <td class="bb"></td>
                <td>коп.</td>
            </tr>
            <tr>
                <td>Отпуск груза разрешил</td>
                <td class="bb"></td>
                <td></td>
                <td class="bb"></td>
                <td></td>
                <td colspan="3" class="bb"></td>
            </tr>
            <tr>
                <td></td>
                <td class="lbl">должность</td>
                <td></td>
                <td class="lbl">подпись</td>
                <td></td>
                <td colspan="3" class="lbl">расшифровка подписи</td>
            </tr>
            <tr>
                <td>Главный (старший) бухгалтер)</td>
                <td class="bb"></td>
                <td></td>
                <td class="bb"></td>
                <td></td>
                <td colspan="3" class="bb"></td>
            </tr>
            <tr>
                <td></td>
                <td class="lbl">должность</td>
                <td></td>
                <td class="lbl">подпись</td>
                <td></td>
                <td colspan="3" class="lbl">расшифровка подписи</td>
            </tr>
            <tr>
                <td>Отпуск груза произвел</td>
                <td class="bb"></td>
                <td></td>
                <td class="bb"></td>
                <td></td>
                <td colspan="3" class="bb"></td>
            </tr>
            <tr>
                <td></td>
                <td class="lbl">должность</td>
                <td></td>
                <td class="lbl">подпись</td>
                <td></td>
                <td colspan="3" class="lbl">расшифровка подписи</td>
            </tr>
            <tr>
                <td style="text-align: center;">М.П.</td>
                <td class="bb">"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"</td>
                <td></td>
                <td class="bb"></td>
                <td colspan="3" class="bb"></td>
                <td>года</td>
            </tr>
        </table>
    </span>

    <span style="width: 48%; float: right; border-left: 1px solid black;">
        <table border="0" align="right" style="width: 95%;">
            <colgroup>
                <col width="">
                <col width="100px">
                <col width="">
                <col width="40px">
                <col width="20px">
                <col width="20px">
                <col width="40px">
                <col width="20px">
            </colgroup>
            <tr>
                <td>По доверенности N</td>
                <td class="bb"></td>
                <td>от</td>
                <td class="bb">"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"</td>
                <td></td>
                <td colspan="2" class="bb"></td>
                <td>г</td>
            </tr>
            <tr>
                <td>выданной</td>
                <td class="bb"></td>
                <td colspan="7" class="bb"></td>
            </tr>
            <tr>
                <td></td>
                <td colspan="7" class="lbl">кем, кому (организация, должность, фамилия, и., о.)</td>
            </tr>
            <tr>
                <td colspan="8" class="bb">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="8" class="bb">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="8">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="8">&nbsp;</td>
            </tr>
            <tr>
                <td>Груз принял</td>
                <td class="bb"></td>
                <td></td>
                <td class="bb"></td>
                <td></td>
                <td colspan="3" class="bb"></td>
            </tr>
            <tr>
                <td></td>
                <td class="lbl">должность</td>
                <td></td>
                <td class="lbl">подпись</td>
                <td></td>
                <td colspan="3" class="lbl">расшифровка подписи</td>
            </tr>
            <tr>
                <td>Груз получил грузополучатель</td>
                <td class="bb"></td>
                <td></td>
                <td class="bb"></td>
                <td></td>
                <td colspan="3" class="bb"></td>
            </tr>
            <tr>
                <td></td>
                <td class="lbl">должность</td>
                <td></td>
                <td class="lbl">подпись</td>
                <td></td>
                <td colspan="3" class="lbl">расшифровка подписи</td>
            </tr>
            <tr>
                <td style="text-align: center;">М.П.</td>
                <td class="bb">"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"</td>
                <td></td>
                <td class="bb"></td>
                <td colspan="3" class="bb"></td>
                <td>года</td>
            </tr>
        </table>
    </span>

[% ELSE %]

    <table border="0">
        <colgroup>
            <col width="">
            <col width="50px">
            <col width="150px">
            <col width="150px">
        </colgroup>
        <tr>
            <td colspan="3"></td>
            <td class="B ac">Код</td>
        </tr>
        <tr>
            <td colspan="2"></td>
            <td class="ar">Форма по  ОКУД</td>
            <td class="B ac">0330504</td>
        </tr>
        <tr>
            <td colspan="2" class="bb">[% vars.glob_vars.seller_firm %]</td>
            <td class="ar">по ОКПО</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td colspan="2" class="lbl">организация</td>
            <td></td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td colspan="3" class="bb">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="3" class="lbl">структурное подразделение</td>
            <td rowspan="2" class="B"></td>
        </tr>
        <tr>
            <td colspan="3" class="bb">&nbsp;</td>
        </tr>
        <tr>
            <td class="lbl">структурное подразделение "получатель"</td>
            <td colspan="2" class="ar">Вид деятельности по ОКДП</td>
            <td class="B"></td>
        </tr>
        <tr>
            <td colspan="2"></td>
            <td class="ar">Вид операции</td>
            <td class="B"></td>
        </tr>
    </table>

    <br><br>

    <table border="0" align="center" style="width: 50%;">
        <tr>
            <td></td>
            <td class="B ac">Номер документа</td>
            <td class="B ac">Дата составления</td>
        </tr>
        <tr>
            <td class="ac">НАКЛАДНАЯ НА ОТПУСК ТОВАРА</td>
            <td style="border: 2px solid black;"></td>
            <td style="border: 2px solid black;"></td>
        </tr>
    </table>

    <br><br>

    <table border="0">
        <colgroup>
            <col width="200px">
            <col width="">
            <col width="">
            <col width="50px">
            <col width="">
            <col width="50px">
            <col width="">
        </colgroup>
        <tr>
            <td>Отпущено на основании</td>
            <td class="bb"></td>
            <td class="ar">Время отпуска</td>
            <td class="bb"></td>
            <td>ч</td>
            <td class="bb"></td>
            <td>мин</td>
        </tr>
        <tr>
            <td></td>
            <td class="lbl">наименование, номер, дата документа</td>
        </tr>
        <tr>
            <td>Через</td>
            <td class="bb"></td>
        </tr>
        <tr>
            <td></td>
            <td class="lbl">фамилия, имя, отчество материально ответственного лица</td>
        </tr>
    </table>

    <br><br>

    <table border="1" class="B cc">
        <tr>
            <th rowspan="3">Номер по порядку</th>
            <th colspan="2">Продукты и товары</th>
            <th colspan="2">Единица измерения</th>
            <th colspan="4">Количество (масса)</th>
            <th colspan="2">По учетным ценам, руб. коп.</th>
            <th colspan="2">По ценам продажи, руб. коп.</th>
            <th rowspan="3">Примечание</th>
        </tr>
        <tr>
            <th rowspan="2">наименование, сорт</th>
            <th rowspan="2">код</th>
            <th rowspan="2">наименование</th>
            <th rowspan="2">код по ОКЕИ</th>
            <th rowspan="2">затребовано</th>
            <th colspan="3">отпущено</th>
            <th rowspan="2">цена</th>
            <th rowspan="2">сумма</th>
            <th rowspan="2">цена</th>
            <th rowspan="2">сумма</th>
        </tr>
        <tr>
            <th>мест, штук</th>
            <th>в одном месте</th>
            <th>всего</th>
        </tr>
        <tr>
            <th>1</th>
            <th>2</th>
            <th>3</th>
            <th>4</th>
            <th>5</th>
            <th>6</th>
            <th>7</th>
            <th>8</th>
            <th>9</th>
            <th>10</th>
            <th>11</th>
            <th>12</th>
            <th>13</th>
            <th>14</th>
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
                <td>[% loop.count %]</td>
                <td>[% p.name %]</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>[% p.quantity %]</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td>?</td>
                <td></td>
            </tr>
        [% END %]
        <tr>
            <td colspan="5" class="ar">Итого</td>
            <td>[% total.quantity %]</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td>?</td>
            <td></td>
        </tr>
    </table>

    <table border="0" style="margin-top: 40px; page-break-inside: avoid;">
        <colgroup>
            <col width="150px">
            <col width="">
            <col width="20px">
            <col width="">
            <col width="20px">
            <col width="30px">
            <col width="30px">
            <col width="30px">
            <col width="150px">
            <col width="40px">
            <col width="20px">
            <col width="20px">
            <col width="20px">
            <col width="160px">
        </colgroup>
        <tr>
            <td>Всего на сумму</td>
            <td colspan="7" class="bb"></td>
            <td class="ar">Отпустил</td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
        </tr>
        <tr>
            <td></td>
            <td colspan="7" class="lbl">прописью</td>
            <td></td>
            <td class="lbl">должность</td>
            <td></td>
            <td class="lbl">подпись</td>
            <td></td>
            <td class="lbl">расшифровка подписи</td>
        </tr>
        <tr>
            <td class="bb"></td>
            <td class="bb"></td>
            <td class="bb"></td>
            <td class="bb"></td>
            <td class="bb"></td>
            <td>руб.</td>
            <td class="bb"></td>
            <td>коп.</td>
            <td class="ar">Принял</td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
        </tr>
        <tr>
            <td colspan="5"></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td class="lbl">должность</td>
            <td></td>
            <td class="lbl">подпись</td>
            <td></td>
            <td class="lbl">расшифровка подписи</td>
        </tr>
        <tr>
            <td>Отпуск разрешил: Руководитель</td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
            <td></td>
            <td colspan="2" class="ar">Заведующий производством</td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
            <td></td>
            <td class="bb"></td>
        </tr>
        <tr>
            <td></td>
            <td class="lbl">должность</td>
            <td></td>
            <td class="lbl">подпись</td>
            <td></td>
            <td colspan="3" class="lbl">расшифровка подписи</td>
            <td></td>
            <td></td>
            <td></td>
            <td class="lbl">подпись</td>
            <td></td>
            <td class="lbl">расшифровка подписи</td>
        </tr>
    </table>

[% END %]
</div>

<div id="js_div_buttons" style="padding-top: 50px;">
    <button class="js_print">Печать</button>
</div>
