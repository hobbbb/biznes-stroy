<div class="clearfix">
    [% IF hit_list.size %]
    <div class="third-block">
        <div class="top-title"> <span class="pic pic-leaders"></span> <a class="all" href="/categories/hits/">Посмотреть все</a> Лидеры продаж</div>
        <!-- end .top-title-->

        <div class="catalog-list">
        [% FOR p IN hit_list %]
            <div class="catalog-item">
                <div class="photo"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">
                    <span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                        <img src="/upload/products/[% p.image %]/" width="132" height="131" alt=" " />
                    <!--[if lte IE 7]></span></span><![endif]--></span>
                </a></div>
                <!-- end .photo-->
                <div class="nofloat">
                    <div class="name"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">[% p.name %]</a></div>
                    <div class="price">
                        [% IF p.sale_price %]
                            <div class="clearfix"><del><span>[% p.price %]</span></del> Старая цена:</div>
                        [% END %]
                        <strong>[% p.sale_price || p.price %]</strong>
                        [% INCLUDE inc/buy_button.tpl product=p %]
                    </div>
                    <!-- end .price-->
                    <a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">Подробнее</a>
                </div>
            </div>
            <!-- end .catalog-item-->
        [% END %]
        </div>
        <!-- end .catalog-list-->
    </div>
    <!-- end .third-block-->
    [% END %]

    [% IF special_list.size %]
    <div class="third-block">
        <div class="top-title"> <span class="pic pic-discount"></span> <a class="all" href="/categories/special/">Посмотреть все</a> Специальные цены:</div>
        <!-- end .top-title-->

        <div class="catalog-list">
        [% FOR p IN special_list %]
            <div class="catalog-item">
                <div class="photo"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">
                    <span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                        <img src="/upload/products/[% p.image %]/" width="132" height="131" alt=" " />
                    <!--[if lte IE 7]></span></span><![endif]--></span>
                </a></div>
                <!-- end .photo-->
                <div class="nofloat">
                    <div class="name"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">[% p.name %]</a></div>
                    <div class="price">
                        [% IF p.sale_price %]
                            <div class="clearfix"><del><span>[% p.price %]</span></del> Старая цена:</div>
                        [% END %]
                        <strong>[% p.sale_price || p.price %]</strong>
                        [% INCLUDE inc/buy_button.tpl product=p %]
                    </div>
                    <!-- end .price-->
                    <a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">Подробнее</a>
                </div>
            </div>
            <!-- end .catalog-item-->
        [% END %]
        </div>
        <!-- end .catalog-list-->
    </div>
    <!-- end .third-block-->
    [% END %]

    [% IF new_list.size %]
    <div class="third-block">
        <div class="top-title"> <span class="pic pic-new"></span> <a class="all" href="/categories/new/">Посмотреть все</a> Новинки:</div>
        <!-- end .top-title-->

        <div class="catalog-list">
        [% FOR p IN new_list %]
            <div class="catalog-item">
                <div class="photo"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">
                    <span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                        <img src="/upload/products/[% p.image %]/" width="132" height="131" alt=" " />
                    <!--[if lte IE 7]></span></span><![endif]--></span>
                </a></div>
                <!-- end .photo-->
                <div class="nofloat">
                    <div class="name"><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">[% p.name %]</a></div>
                    <div class="price">
                        [% IF p.sale_price %]
                            <div class="clearfix"><del><span>[% p.price %]</span></del> Старая цена:</div>
                        [% END %]
                        <strong>[% p.sale_price || p.price %]</strong>
                        [% INCLUDE inc/buy_button.tpl product=p %]
                    </div>
                    <!-- end .price-->
                    <a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">Подробнее</a>
                </div>
            </div>
            <!-- end .catalog-item-->
        [% END %]
        </div>
        <!-- end .catalog-list-->
    </div>
    <!-- end .third-block-->
    [% END %]
</div>

<div class="clearfix">
    <div class="third-block2">
    <div class="slider">
        <h3>Наши производители</h3>
        <div class="bg">
            <div class="prev"></div>
            <div class="next"></div>
            <div class="hold">
                <ul>
                [% FOR m IN manufacturers_list %]
                    <li>
                        <a href="[% INCLUDE inc/link.tpl alias='manufacturers' item=m %]">
                            [% IF m.image %]
                                <span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                                    <img src="/resize/70/manufacturers/[% m.image %]/" alt="" />
                                <!--[if lte IE 7]></span></span><![endif]--></span>
                            [% END %]
                            <span class="name">[% m.name %]</span>
                        </a>
                    </li>
                [% END %]
                </ul>
            </div>
            <!-- end .hold-->
            <div class="all"><a href="/manufacturers/">Все производители</a></div>
        </div>
        <!-- end .bg-->
    </div>
    <!-- end .slider-->
    </div>

    <!-- end .third-block2-->
    <div class="third-block">
        <h3>Бизнес-строй это:</h3>
        <div class="text-gallery">
            <ul>
                [% FOR b IN biznes_stroy_list %]
                <li>
                    <div class="quote">
                        <img src="/upload/biznes_stroy/[% b.image %]/" width="137" height="144" alt=" " />
                        <div class="nofloat">[% b.descr %]</div>
                    </div>
                    <!-- end .quote-->
                </li>
                [% END %]
            </ul>
        </div>
        <!-- end .text-gallery-->
    </div>
</div>
