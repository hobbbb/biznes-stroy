[%-
    SET retail_price = product.price * (100 + category.retail_percent) / 100;
    SET middle_price = product.price * (100 + category.middle_percent) / 100;
-%]

<table class="three_price">
    <tr>
        <th>Розница</th>
        <th>Опт от [% category.retail_sum %]</th>
        <th>Крупный опт от [% category.middle_sum %]</th>
        <th>Кол-во</th>
        <th>Сумма</th>
    </tr>
    <tr>
        <td>[% retail_price %]</td>
        <td>[% middle_price %]</td>
        <td>[% product.price %]</td>
        <td>
            <span class="amount" style="padding: 0px;"><input type="text" value="1" class="amount js_buy_qnt" style="width: 40px !important;" data-product="[% product.id %]"></span>
        </td>
        <td class="js_buy_sum" data-product="[% product.id %]">[% retail_price %]</td>
    </tr>
</table>
