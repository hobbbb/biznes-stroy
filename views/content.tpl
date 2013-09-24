[% WRAPPER inc/wrap.tpl title = content.name crumbs = [ { 'name' => content.name } ] %]
    <div class="clearfix">
        [% content.descr %]
    </div>

    [% IF products.size OR filt %]
        <div class="hr op"></div>
        [% INCLUDE inc/products_filters.tpl %]
        <h2>[% content.name %]</h2>

        [% INCLUDE inc/products_list.tpl list=products %]
    [% END %]
[% END %]
