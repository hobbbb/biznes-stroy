[% WRAPPER inc/wrap.tpl title = 'Оформление заказа' crumbs = [ { 'name' => 'Оформление заказа' } ] %]
    <div class="bordered-block order-block">
    [% IF success %]
        <p>Спасибо за заказ.</p>
        <p>В ближайшее время с вами свяжется наш менеджер для подтверждения заказа.</p>

        [% INCLUDE email/order.tpl order = order %]
    [% ELSE %]
        <p class="err [% 'dnone' UNLESS err.no_products OR !products.size %]" id="js_shopping_cart_empty">Нет ни одного товара для заказа</p>

        <form action="" method="post" id="js_shopping_cart" [% 'class="dnone"' IF !products.size OR err.no_products %] enctype="multipart/form-data">
            <div class="clearfix">
                <table class="cart">
                [%
                    SET total = 0;
                    FOR p = products;
                    SET total = total + p.price * p.qnt;
                %]
                    <tr>
                        <td class="photo">
                            [% IF p.image %]<a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">
                                <img src="/resize/135/products/[% p.image %]/" alt=" " />
                            </a>[% END %]
                        </td>
                        <td><a href="[% INCLUDE inc/link.tpl alias='products' item=p %]">[% p.name %]</a></td>
                        <td class="w1"><div class="amount">
                            <span class="minus js_minus" data-minus="qnt_[% p.id %]"></span>
                            <input type="hidden" name="id" value="[% p.id %]">
                            <input type="text" name="qnt_[% p.id %]" value="[% p.qnt %]" class="js_qnt" id="qnt_[% p.id %]">
                            <span class="plus js_plus" data-plus="qnt_[% p.id %]"></span>
                        </div></td>
                        <td class="price">[% p.price %] руб.</td>
                        <td class="w1"><a class="delete js_del" href="javascript: void(0);"></a></td>
                    </tr>
                [% END %]
                </table>
                <!-- end .cart-->

                <div class="choose"> Способы доставки:
                    <ul class="checks">
                        <li>
                            <input class="customRadio js_shipping" type="radio" id="shipping_self" name="shipping" value="self" [% 'checked' IF form.shipping == 'self' || !form.shipping %] />
                            <label for="shipping_self">Самовывоз, бесплатно.</label>
                        </li>
                        <li class="js_shipping_with_delivery [% 'dnone' UNLESS total >= (vars.glob_vars.delivery_min_sum || 0) %]">
                            <input class="customRadio js_shipping" type="radio" id="shipping_delivery" name="shipping" value="delivery" data-delivery_price="[% vars.glob_vars.delivery_price || 0 %]" [% 'checked' IF form.shipping == 'delivery' %] />
                            <label for="shipping_delivery">Курьером, [% vars.glob_vars.delivery_price || 0 %] руб.</label>
                        </li>
                        <li class="js_shipping_with_delivery [% 'dnone' UNLESS total >= (vars.glob_vars.delivery_min_sum || 0) %]">
                            <input class="customRadio js_shipping" type="radio" id="shipping_delivery_mkad" name="shipping" value="delivery_mkad" data-delivery_price="[% vars.glob_vars.delivery_price || 0 %]" data-delivery_mkad_price="[% vars.glob_vars.delivery_mkad_price || 0 %]" [% 'checked' IF form.shipping == 'delivery_mkad' %] />
                            <label for="shipping_delivery_mkad">Доставка за МКАД</label>
                            <input type="text" id="js_mkad_length" name="mkad" value="[% form.mkad %]" size="11" placeholder="Км от МКАД" class="js_delivery_mkad [% 'f_err' IF err.mkad %]"><span id="js_delivery_mkad_price"></span>
                            <div class="js_delivery_mkad [% 'dnone' UNLESS err.mkad %]">
                                Стоимость одного километра: [% vars.glob_vars.delivery_mkad_price || 0 %] руб.
                            </div>
                        </li>
                    </ul>

                    Способы оплаты:
                    <span class="check">
                        <input class="customRadio js_payment" type="radio" id="payment_cash" name="payment" value="cash" [% 'checked' IF form.payment == 'cash' || !form.payment %] />
                        <label for="payment_cash">Наличными</label>
                    </span>
                    <div class="check">
                        <input class="customRadio js_payment" type="radio" id="payment_cashless" name="payment" value="cashless" [% 'checked' IF form.payment == 'cashless' %] />
                        <label for="payment_cashless">Безнал</label>
                    </div>
                </div>
                <!-- end .choose-->
            </div>

            <div class="total">
                <span style="float: left;">
                    [% IF vars.loged AND !vars.loged.is_partner AND !vars.loged.acs.keys %]
                        [% discount = INCLUDE inc/discount_program.tpl summary_buy = overal + vars.loged.summary_buy %]
                        [% IF discount > 0 %]
                            <!--div><strong>Старая цена: [% overal %] руб.<br></strong></div>
                            <div><strong>Новая цена: [% SET overal = overal - overal * discount / 100; overal; %] руб.<br></strong></div-->
                        [% END %]
                    [% ELSE %]
                    [% END %]

                    Общая стоимость без учета доставки: <strong><span id="js_shopping_cart_total">[% total %]</span> руб.</strong>
                    <div id="js_total_with_delivery" class="dnone">Общая стоимость с доставкой: <strong>[% total %] руб.</strong></div>
                </span>
                <span style="float: right;">
                    <div id="js_shopping_cart_cashless_file">
                        <b>Загрузите реквизиты</b><span class="Requirement">*</span>
                        <input type="file" name="file" value="[% form.file %]" [% 'class="err"' IF err.file %]>
                    </div>
                </span>
            </div>

            <div class="hr"></div>

            <div class="clearfix">
                <div class="third">
                    <!-- <h3>Быстрая покупка</h3> -->

                    <input type="hidden" name="users_id" value="[% vars.loged.id %]">
                    [% IF discount %]
                        <!--input type="hidden" name="discount" value="[% discount %]"-->
                    [% END %]

                    <ul class="form">
                        <li>
                            <input type="text" name="phone" value="[% form.phone || vars.loged.phone %]" placeholder="Телефон" class="js_phone_format [% 'f_err' IF err.phone %]">
                            <span class="Requirement">*</span>
                            <div style="margin-left: 10px; font-size: 8pt">Формат: +79261234567</div>
                        </li>
                        <li>
                            <input type="text" name="fio" value="[% form.fio || vars.loged.fio %]" placeholder="ФИО">
                        </li>
                        <li>
                            <input type="text" name="email" value="[% form.email || vars.loged.email %]" placeholder="E-Mail">
                        </li>
                    </ul>
                </div>
                <div class="third">
                    <ul class="form">
                        <li>
                            <textarea name="comments" cols="60" rows="5" placeholder="Адрес доставки и комментарии">[% form.comments %]</textarea>
                        </li>
                    </ul>
                </div>

                <!--div class="third">
                    <h3>Вход в личный кабинет</h3>
                    <ul class="form">
                        <li>
                            <input value="E-mail" type="text" />
                        </li>
                        <li>
                            <input value="Пароль" type="text" />
                        </li>
                    </ul>
                </div>
                <div class="third r">
                    <h3>Регистрация</h3>
                    <ul class="form">
                        <li>
                            <input value="E-mail" type="text" />
                        </li>
                        <li>
                            <input value="Телефон" type="text" />
                        </li>
                        <li>
                            <input value="ФИО" type="text" />
                        </li>
                        <li>
                            <input value="Адрес" type="text" />
                        </li>
                        <li>
                            <input value="Пароль" type="text" />
                        </li>
                        <li>
                            <input value="Подтвердить пароль" type="text" />
                        </li>
                    </ul>
                </div-->
            </div>

            <div class="center"><button class="btn-orange green" type="submit"><span class="arr">Оформить заказ</span></button></div>
        </form>
    [% END %]
    </div>
[% END %]
