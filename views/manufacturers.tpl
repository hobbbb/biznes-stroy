[% IF manufacturers_list.size %]
    [% SET crumbs = [ { 'name' => 'Производители' } ] %]
    [% WRAPPER inc/wrap.tpl title = 'Производители' %]
        <div class="catalog">
        [% FOR m = manufacturers_list %]
            <div class="catalog-item">
                    <div class="photo">
                        <a href="[% INCLUDE inc/link.tpl alias='manufacturers' item=m %]"><span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                            <img src="/resize/160/manufacturers/[% m.image %]/" width="132" height="131" alt=" " />
                        <!--[if lte IE 7]></span></span><![endif]--></span></a>
                    </div>
                    <!-- end .photo-->
                    <div class="nofloat">
                        <div class="name"><a href="[% INCLUDE inc/link.tpl alias='manufacturers' item=m %]">[% m.name %]</a></div>
                    </div>
            </div>
            <!-- end .catalog-item-->
        [% END %]
        </div>
    [% END %]
[% ELSE %]
    [% SET crumbs = [ { 'name' => 'Производители', url => '/manufacturers/' }, { 'name' => manufacturer.name } ] %]
    [% WRAPPER inc/wrap.tpl title = manufacturer.name filters = 1 %]
        [% IF products.size %]
            [% INCLUDE inc/products_list.tpl list=products %]
        [% END %]
    [% END %]
[% END %]
