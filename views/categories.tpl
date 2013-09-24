[% INCLUDE inc/breadcrumbs.tpl alias = 'categories' crumbs = breadcrumbs.reverse %]

[%-filt;
    IF products.size OR filt;
        INCLUDE inc/products_filters.tpl;
    END;
-%]

<h1>[% category.name %]</h1>

[% IF categories.size %]
    <div class="catalog-sections">
    [% FOR c = categories %]
        [% IF loop.index % 5 == 0 %]
            <div class="clearfix">
        [% END %]

            <div class="fl">
                <div class="top"><a href="[% INCLUDE inc/link.tpl alias='categories' item=c %]">[% c.name %]</a></div>
                <div class="photo">
                    <a href="[% INCLUDE inc/link.tpl alias='categories' item=c %]">
                    <span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                        <img src="/resize/100/categories/[% c.image %]/" alt=" " />
                    <!--[if lte IE 7]></span></span><![endif]--></span>
                    </a>
                </div>
                <!-- end .photo-->
              <a class="all" href="[% INCLUDE inc/link.tpl alias='categories' item=c %]">Посмотреть все</a> </div>
            <!-- end .fl-->

        [% IF loop.last OR loop.count % 5 == 0 %]
            </div>
        [% END %]

        [% IF !loop.last AND loop.count % 5 == 0 %]
            <div class="sep">
                <div class="fl"></div>
                <div class="fl"></div>
                <div class="fl"></div>
                <div class="fl"></div>
                <div class="fl"></div>
            </div>
        [% END %]
    [% END %]
    </div>
    <!-- end .catalog-sections-->
[% END %]

[% IF products.size %]
    [% INCLUDE inc/products_list.tpl list=products %]
[% END %]

[% IF category.descr %]
    <div class="grey-text">[% category.descr %]</div>
    <!-- end .grey-text-->
[% END %]
