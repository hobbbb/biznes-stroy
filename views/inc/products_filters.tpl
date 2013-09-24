<ul class="sort1">
    <li><a [% 'class="active"' IF filt == 'special' %] href="[% INCLUDE inc/products_uri_params.tpl filt = 'special' %]">Специальные цены</a></li>
    <li><a [% 'class="active"' IF filt == 'hit' %] href="[% INCLUDE inc/products_uri_params.tpl filt = 'hit' %]">Лидеры продаж</a></li>
    <li><a [% 'class="active"' IF filt == 'new' %] href="[% INCLUDE inc/products_uri_params.tpl filt = 'new' %]">Новинки</a></li>
</ul>
