[% WRAPPER inc/wrap.tpl crumbs = [ { 'name' => 'Мои данные' } ] %]
    <form method="post" action="">
        [% discount_program = INCLUDE inc/discount_program.tpl summary_buy = vars.loged.summary_buy %]
        [% IF discount_program > 0 %]
            <p><b>Скидка по дисконтной программе: <span class="err">[% discount_program %]%</span><b></p>
        [% END %]

        <p>&nbsp;</p>
        <span class="Requirement"> поля, отмеченные *, обязательны для заполнения </span>
        <fieldset class="form">
            <legend>Введите свои данные</legend>
            <p>&nbsp;</p>
            <p>
                <input type="text" name="phone" value="[% form.phone %]" placeholder="Телефон" class="js_phone_format [% 'f_err' IF err.phone %]" /> <span class="Requirement">*</span>
                [% '<span class="err">Такой телефон уже существует</span>' IF err.phone_exist %]
            </p>
            <p><input type="text" name="fio" value="[% form.fio %]" placeholder="ФИО" [% 'class="f_err"' IF err.fio %] /> <span class="Requirement">*</span></p>
            <p>
                <input type="text" name="email" value="[% form.email %]" placeholder="E-mail" [% 'class="f_err"' IF err.email %] />
                [% '<span class="err">Такой E-mail уже существует</span>' IF err.email_exist %]
            </p>
            <p><input type="text" name="address" value="[% form.address %]" placeholder="Адрес" [% 'class="f_err"' IF err.address %] /></p>
            <p>&nbsp;</p>
            <p><input type="checkbox" name="notify_news" value="1" [% 'checked' IF form.notify_news %] /> Подписка на новости</p>
            <p>&nbsp;</p>
            <p><input type="password" name="password" placeholder="Новый пароль" [% 'class="f_err"' IF err.password %] /></p>
        </fieldset>
        <p>&nbsp;</p>
        <input type="submit" value="Сохранить">
    </form>
[% END %]
