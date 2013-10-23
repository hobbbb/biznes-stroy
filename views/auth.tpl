[% WRAPPER inc/wrap.tpl title = 'Вход в личный кабинет' crumbs = [ { 'name' => 'Вход в личный кабинет' } ] %]
    <div class="auth">
        <div class="block l w1">
            <form action="/auth/login/" method="post">
            <input type="hidden" name="referer" value="[% referer %]">
                <fieldset>
                    <h3>Вход в личный кабинет</h3>
                    <ul>
                        <li>
                            <label class="label">Телефон:</label>
                            <input type="text" name="phone" class="js_phone_format" />
                        </li>
                        <li>
                            <label class="label">Пароль:</label>
                            <input type="password" name="password" />
                            <a href="javascript: void(0)" onClick="$('.js_auth_restore').show()">Забыли?</a></li>
                        <li class="center">
                            <span class="check">
                                <input id="check1" class="customCheckbox" type="checkbox" name="remember" value="1" checked />
                                <label for="check1">Запомнить меня</label>
                            </span>
                        </li>
                        <li class="submit">
                            <span class="btn-orange green">
                                <span class="arr">Войти</span>
                                <input value="" type="submit" />
                            </span>
                        </li>
                    </ul>
                </fieldset>
            </form>

            <div class="block popup dnone js_auth_restore">
                <form action="/auth/restore/" method="post">
                    <fieldset>
                        <h3>Заполните данную форму</h3>
                        <ul class="ind2">
                            <li>
                                <label class="label">Телефон:</label>
                                <input type="text" name="phone" class="js_phone_format" />
                            </li>
                            <li>или</li>
                            <li>
                                <label class="label">E-mail:</label>
                                <input type="text" name="email" />
                            </li>
                            <li class="submit">
                                <span class="btn-orange green">
                                    <span class="arr">Отправить</span>
                                    <input value="" type="submit" />
                                </span>
                            </li>
                        </ul>
                    </fieldset>
                </form>
                <div class="pop-arr"></div>
            </div>
            <!-- end .block-->
        </div>
        <!-- end .block-->

        <div class="block r">
        <form action="/auth/register/" method="post">
            <fieldset>
                <h3>Регистрация</h3>
                <ul class="ind2">
                    <li>
                        <label class="label">Телефон:</label>
                        <input type="text" name="phone" value="[% form.phone %]" class="js_phone_format [% 'red' IF err.phone %]" />
                    </li>
                    <li>
                        [% '<span class="err">Такой телефон уже существует</span>' IF err.phone_exist %]
                    </li>
                    <li>
                        <label class="label">ФИО:</label>
                        <input type="text" name="fio" value="[% form.fio %]" [% 'class="red"' IF err.fio %] />
                    </li>
                    <li>
                        <label class="label">E-mail:</label>
                        <input type="text" name="email" value="[% form.email %]" [% 'class="red"' IF err.email %] />
                    </li>
                    <li>
                        [% '<span class="err">Такой E-mail уже существует</span>' IF err.email_exist %]
                    </li>
                    <li>
                        <label class="label">Адрес:</label>
                        <input type="text" name="address" value="[% form.address %]" [% 'class="red"' IF err.address %] />
                    </li>
                    <li>
                        <span class="check">
                            <input id="check1" class="customCheckbox" type="checkbox" name="notify_news" value="1" checked />
                            <label for="check1">Подписка на новости</label>
                        </span>
                    </li>
                    <li class="dnone">
                        <input type="text" name="code"  placeholder="5+3" />
                    </li>
                    <li class="submit">
                        <span class="btn-orange green">
                            <span class="arr">Зарегистрироваться</span>
                            <input value="" type="submit" />
                        </span>
                    </li>
                </ul>
            </fieldset>
        </form>
        </div>
        <!-- end .block-->

    </div>
    <!-- end .auth-->
[% END %]
