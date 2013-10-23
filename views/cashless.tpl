[% WRAPPER inc/wrap.tpl title = 'Заказ по безналу' crumbs = [ { 'name' => 'Заказ по безналу' } ] %]
    <div class="bordered-block order-block">
    [% IF success %]
        <p>Спасибо за заказ.</p>
        <p>Номер заказа - [% order.data.id %]</p>
        <p>В ближайшее время с вами свяжется наш менеджер для подтверждения заказа.</p>

        Вы заказали:
        <p>[% order.data.products %]</p>

    [% ELSE %]
        <form action="" method="post" enctype="multipart/form-data" id="js_shopping_cart" onsubmit="yaCounterXXXXXX.reachGoal('ORDER2'); return true;">
        <input type="hidden" name="users_id" value="[% vars.loged.id %]">
        <input type="hidden" name="fio" value="[% vars.loged.fio %]">
        <input type="hidden" name="email" value="[% vars.loged.email %]">
        <input type="hidden" name="payment" value="cashless">
            <div class="clearfix">
                <span class="Requirement">*</span>
                <textarea name="products" cols="60" rows="5" placeholder="Перечислите товар, который вы хотите приобрести" [% 'class="f_err"' IF err.products %]>[% form.products %]</textarea>

                <div class="choose"> Способы доставки:
                    <ul class="checks">
                        <li>
                            <input class="customRadio js_shipping" type="radio" id="shipping_self" name="shipping" value="self" [% 'checked' IF form.shipping == 'self' || !form.shipping %] />
                            <label for="shipping_self">Самовывоз, бесплатно.</label>
                        </li>
                        <li class="js_shipping_with_delivery">
                            <input class="customRadio js_shipping" type="radio" id="shipping_delivery" name="shipping" value="delivery" data-delivery_price="[% vars.glob_vars.delivery_price || 0 %]" [% 'checked' IF form.shipping == 'delivery' %] />
                            <label for="shipping_delivery">Курьером, [% vars.glob_vars.delivery_price || 0 %] руб.</label>
                        </li>
                        <li class="js_shipping_with_delivery">
                            <input class="customRadio js_shipping" type="radio" id="shipping_delivery_mkad" name="shipping" value="delivery_mkad" data-delivery_price="[% vars.glob_vars.delivery_price || 0 %]" data-delivery_mkad_price="[% vars.glob_vars.delivery_mkad_price || 0 %]" [% 'checked' IF form.shipping == 'delivery_mkad' %] />
                            <label for="shipping_delivery_mkad">Доставка за МКАД</label>
                            <input type="text" id="js_mkad_length" name="mkad" value="[% form.mkad %]" size="11" placeholder="Км от МКАД" class="js_delivery_mkad [% 'f_err' IF err.mkad %]"><span id="js_delivery_mkad_price"></span>
                            <div class="js_delivery_mkad [% 'dnone' UNLESS err.mkad %]">
                                Стоимость одного километра: [% vars.glob_vars.delivery_mkad_price || 0 %] руб.
                            </div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="hr"></div>

            <div class="clearfix">
                <div class="third">
                    <ul class="form">
                        <li>
                            <span class="Requirement">*</span>
                            <input type="text" name="phone" value="[% form.phone || vars.loged.phone %]" placeholder="Телефон" class="js_phone_format [% 'f_err' IF err.phone %]">
                            <div style="margin-left: 10px; font-size: 8pt">Формат: +79261234567</div>
                        </li>
                        <li>
                            <span class="Requirement">*</span>
                            <b>Загрузите реквизиты:</b> <input type="file" name="file" value="[% form.file %]" [% 'class="err"' IF err.file %]>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="center"><button class="btn-orange green" type="submit"><span class="arr">Оформить заказ</span></button></div>
        </form>
    [% END %]
    </div>
[% END %]
