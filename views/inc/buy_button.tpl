[% IF product.price AND product.price * 1 %]
    <a class="btn-orange buy-link js_buy_button" href="javascript: void(0)" data-product=[% product.id %]><span>Купить</span></a>
[% END %]