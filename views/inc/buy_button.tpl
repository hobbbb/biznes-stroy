[% IF product.price AND product.price * 1 %]
    <a class="btn-orange red buy-link js_buy_button" href="javascript: void(0)" data-product="[% product.id %]" data-qnt="1"><span>Купить</span></a>
[% END %]
