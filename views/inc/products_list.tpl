[% UNLESS wo_order %]
    <div class="sort2">
        <span>Сортировать по:</span>
        <a href="[% INCLUDE inc/products_uri_params.tpl sort = 'price' direction = { price => (direction.price == 'asc' ? 'desc' : 'asc') } %]">Цене</a>
        <!--a href="#">Производителям</a-->
        <a href="[% INCLUDE inc/products_uri_params.tpl sort = 'name' direction = { name => (direction.name == 'asc' ? 'desc' : 'asc') } %]">Названию</a>
    </div>
    <!-- end .sort2-->
[% END %]

<div class="catalog">
[% FOR p = list %]
    <div class="catalog-item">
        <div class="photo">
            <a href="[% INCLUDE inc/link.tpl alias='products' item=p %]"><span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                <img src="/resize/160/products/[% p.image %]/" width="132" height="131" alt=" " />
            <!--[if lte IE 7]></span></span><![endif]--></span></a>
        </div>
        <!-- end .photo-->
        <div class="nofloat">
            <div class="name"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">[% p.name %]</a></div>
            <div class="descr">[% p.short_descr %]</div>
            <!-- end .descr-->

            <ul class="info-pics ind">
                [% IF p.hit %]<li class="bg-hit">ХИТ ПРОДАЖ</li>[% END %]
                [% IF p.new %]<li class="bg-new">НОВИНКА</li>[% END %]
                [% IF p.special %]<li class="bg-special">СПЕЦ.ЦЕНА</li>[% END %]
            </ul>
            <!-- end .info-pics-->

            [% IF p.sale_price %]
                <div class="price">
                    <div class="clearfix"><del><span>[% p.price %]</span></del> Старая цена:</div>
                    <strong>[% p.sale_price %]</strong>
                    [% INCLUDE inc/buy_button.tpl product=p %]
                </div>
            [% ELSIF category.middle_percent || category.retail_percent %]
                [% INCLUDE inc/three_prices.tpl product=p category=category %]
                <br>
                <div class="price">
                    [% INCLUDE inc/buy_button.tpl product=p %]
                </div>
            [% ELSE %]
                <div class="price">
                    <strong>[% p.price %]</strong>
                    [% INCLUDE inc/buy_button.tpl product=p %]
                </div>
            [% END %]
        </div>
    </div>
    <!-- end .catalog-item-->
[% END %]
</div>
<!-- end .catalog-->

[% IF 0 %]
    <div class="pagination">
        <div class="r">Всего страниц: 6</div>
        <ul>
            <li><strong>1</strong></li>
            <li><a href="#">2</a></li>
            <li><a href="#">3</a></li>
            <li><a href="#">4</a></li>
            <li><a href="#">5</a></li>
            <li><a href="#">6</a></li>
            <li><a href="#">Следующая</a></li>
        </ul>
    </div>
    <!-- end .pagination-->
[% END %]
