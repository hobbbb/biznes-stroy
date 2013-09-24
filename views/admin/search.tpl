<div class="row-fluid">
    <div class="span7">
        [% IF products.size %]
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th class="span2">&nbsp;</th>
                        <th>Название</th>
                        <th>Цена</th>
                        <th>Краткое описание</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                [% FOR i = products %]
                    <tr>
                        <td>[% IF i.image %]<img src="/resize/50/products/[% i.image %]/" class="img-rounded">[% END %]</td>
                        <td>[% i.name %]</td>
                        <td>[% i.price %]</td>
                        <td>[% i.short_descr %]</td>
                        <td><a href="javascript: void(0)" data-product="[% i.id %]" class="js_to_bill_cart"><i class="icon-shopping-cart"></i></a></td>
                    </tr>
                [% END %]
                </tbody>
            </table>
        [% ELSE %]
            <p>Ничего не найдено</p>
        [% END %]
    </div>

    [% INCLUDE admin/inc/bill_cart.tpl %]
</div>
