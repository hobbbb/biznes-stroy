[% INCLUDE inc/breadcrumbs.tpl alias = 'categories' crumbs = breadcrumbs.reverse %]

<div class="item">
    <h1>[% product.name %]</h1>
    <div class="right">
        [% IF product.sale_price %]
            <div class="price">
                [% INCLUDE inc/buy_button.tpl product=product %]
                <strong>[% product.sale_price %]</strong>
                Старая цена: <del><span>[% product.price %]</span></del>
            </div>
        [% ELSIF product.category.middle_percent || product.category.retail_percent %]
            [% INCLUDE inc/three_prices.tpl product=product category=product.category %]
            <br>
            <div class="price">
                [% INCLUDE inc/buy_button.tpl product=product %]
            </div>
        [% ELSE %]
            <div class="price">
                [% INCLUDE inc/buy_button.tpl product=product %]
                <strong>[% product.price %]</strong>
            </div>
        [% END %]

        <ul class="info-pics">
            [% IF product.hit %]<li class="bg-hit">ХИТ ПРОДАЖ</li>[% END %]
            [% IF product.new %]<li class="bg-new">НОВИНКА</li>[% END %]
            [% IF product.special %]<li class="bg-special">СПЕЦ.ЦЕНА</li>[% END %]
        </ul>
        <!-- end .info-pics-->

        <div class="descr">
            [% product.short_descr %]
        </div>
        <!-- end .descr-->

        <ul class="tabs2">
            <li><a class="tab active" href="#tab1">Описание</a></li>
            <li><a class="tab" href="#tab2">Технические характеристики</a></li>
        </ul>
        <!-- end .tabs2-->

        <div class="tab-hold" id="tab1">
            [% product.descr %]
        </div>
        <!-- end #tab1-->

        <div class="tab-hold" id="tab2">
            [% product.detailed_chars %]
        </div>
        <!-- end #tab2-->
    </div>
    <!-- end .right-->

    <div class="gallery">
        <div class="big">
            <ul>
            [% FOR i IN product.images %]
                <li><span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                    <img src="/resize/430/products/[% i.image %]/" alt=" " />
                <!--[if lte IE 7]></span></span><![endif]--></span></li>
            [% END %]
            </ul>
        </div>
        <!-- end .big-->

        <ul class="small">
            [% FOR i IN product.images %]
                <li><span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                    <img src="/upload/products/[% i.image %]/" alt=" " />
                <!--[if lte IE 7]></span></span><![endif]--></span></li>
            [% END %]
        </ul>
        <!-- end .small-->
    </div>
    <!-- end .gallery-->
</div>
<!-- end .item-->
