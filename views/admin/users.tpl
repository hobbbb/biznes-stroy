[% IF action == 'list' %]
    <div class="row-fluid">
        <div class="span2">
            <div class="span2 well" data-spy="affix">
                <p><a href="/admin/users/add/" class="btn btn-block">Добавить</a></p>
            </div>
        </div>

        <div class="span10">
            <h3>Пользователи</h3>

            <ul class="nav nav-pills">
                <li [% 'class="active"' IF type == 'all' %]><a href="/admin/users/">Все</a></li>
                <li [% 'class="active"' IF type == 'normal' %]><a href="/admin/users/?type=normal">Обычные</a></li>
                <li [% 'class="active"' IF type == 'tech' %]><a href="/admin/users/?type=tech">Технические</a></li>
                <li [% 'class="active"' IF type == 'ph' %]><a href="/admin/users/?type=ph">Физлица</a></li>
                <li [% 'class="active"' IF type == 'ur' %]><a href="/admin/users/?type=ur">Юрлица</a></li>
                <li [% 'class="active"' IF type == 'partner' %]><a href="/admin/users/?type=partner">Партнеры</a></li>
            </ul>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th class="span1"></th>
                        <th>ФИО</th>
                        <th>E-mail</th>
                        <th>Телефон</th>
                        <th>Суммарная покупка</th>
                        <th>Адрес</th>
                        <th>X_REAL_IP</th>
                        <th class="span1"></th>
                        <th class="span1"></th>
                    </tr>
                </thead>
                <tbody>
                [% FOR i = users %]
                    <tr>
                        <td>[% '<i class="icon-signal"></i>' IF i.online %]</td>
                        <td>[% i.fio %]</td>
                        <td>[% i.email %]</td>
                        <td>[% i.phone %]</td>
                        <td>[% i.summary_buy %]</td>
                        <td>[% i.address %]</td>
                        <td>[% i.x_real_ip %]</td>
                        <td><a href="/admin/users/edit/[% i.id %]/"><i class="icon-pencil"></i></a></td>
                        <td><a href="javascript: void(0)" data-url="/admin/users/del/[% i.id %]/" class="js_delete"><i class="icon-trash"></i></a></td>
                    </tr>
                [% END %]
                </tbody>
            </table>
        </div>
    </div>
[% ELSE %]
    <div class="row-fluid">
    <form class="form-horizontal" method="post" action="" enctype="multipart/form-data">
        <div class="span7">
            <fieldset>
                <legend>[% form.id ? 'Редактировать' : 'Добавить' %]</legend>

                [% INCLUDE submit_buttons %]

                [% IF form.id %]
                    <div class="control-group">
                        <label class="control-label">Время регистрации</label>
                        <div class="controls">[% form.registered %]</div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Последнее посещение</label>
                        <div class="controls">[% form.last_visit %]</div>
                    </div>
                [% END %]
                <div class="control-group [% 'error' IF err.role %]">
                    <label class="control-label" for="role">Роль</label>
                    <div class="controls">
                        <select name="role" id="role" class="span12" [% 'disabled' IF form.role == 'admin' %]>
                            [% IF form.role == 'admin' %]
                                <option value="admin">Администратор</option>
                            [% ELSE %]
                                <option value="">-- Не выбрано --</option>
                                <option value="manager" [% 'selected' IF form.role == 'manager' %]>Менеджер</option>
                                <option value="content" [% 'selected' IF form.role == 'content' %]>Контентщик</option>
                            [% END %]
                        </select>
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.type %]">
                    <label class="control-label" for="type">Тип</label>
                    <div class="controls">
                        <select name="type" id="type" class="span12 js_user_type">
                                <option value="ph">Физическое лицо</option>
                                <option value="ur" [% 'selected' IF form.type == 'ur' %]>Юридическое лицо</option>
                        </select>
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.email %]">
                    <label class="control-label" for="email">Email</label>
                    <div class="controls">
                        <input type="text" id="email" name="email" value="[% form.email | html %]" placeholder="Email" class="span12">
                        [% '<span class="label label-important">Такой E-mail уже существует</span>' IF err.email_exist %]
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.phone %]">
                    <label class="control-label" for="phone">Телефон</label>
                    <div class="controls"><input type="text" id="phone" name="phone" value="[% form.phone | html %]" placeholder="Телефон" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.fio %]">
                    <label class="control-label" for="fio">ФИО</label>
                    <div class="controls"><input type="text" id="fio" name="fio" value="[% form.fio | html %]" placeholder="ФИО" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.address %]">
                    <label class="control-label" for="address">Адрес</label>
                    <div class="controls"><textarea id="address" name="address" class="span12">[% form.address | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.password %]">
                    <label class="control-label" for="password">Пароль</label>
                    <div class="controls"><input type="text" id="password" name="password" value="[% form.password | html %]" placeholder="Пароль" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.is_partner %]">
                    <label class="control-label" for="is_partner">Партнер</label>
                    <div class="controls"><input type="checkbox" id="is_partner" name="is_partner" class="js_is_partner" [% 'checked' IF form.is_partner %]></div>
                </div>

                [% INCLUDE submit_buttons %]

            </fieldset>
        </div>

        <div class="span5 hide" id="js_partner_block">
            <fieldset>
                <legend>Партнер</legend>

                <div class="control-group [% 'error' IF err.partner_discount %]">
                    <label class="control-label" for="partner_discount">Скидка партнера</label>
                    <div class="controls"><input type="text" id="partner_discount" name="partner_discount" value="[% form.partner_discount | html %]" placeholder="Скидка партнера" class="span12"></div>
                </div>
            </fieldset>
        </div>

        <div class="span5 hide" id="js_ur_block">
            <fieldset>
                <legend>Реквизиты юрлица</legend>
                <div class="control-group [% 'error' IF err.firm %]">
                    <label class="control-label" for="firm">Полное наименование</label>
                    <div class="controls"><textarea id="firm" name="firm" placeholder="Полное наименование" class="span12">[% form.firm | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.ogrn %]">
                    <label class="control-label" for="ogrn">ОГРН</label>
                    <div class="controls"><input type="text" id="ogrn" name="ogrn" value="[% form.ogrn | html %]" placeholder="ОГРН" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.inn %]">
                    <label class="control-label" for="inn">ИНН</label>
                    <div class="controls">
                        <input type="text" id="inn" name="inn" value="[% form.inn | html %]" placeholder="ИНН" class="span12">
                        [% '<span class="label label-important">Такой ИНН уже существует</span>' IF err.inn_exist %]
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.kpp %]">
                    <label class="control-label" for="kpp">КПП</label>
                    <div class="controls"><input type="text" id="kpp" name="kpp" value="[% form.kpp | html %]" placeholder="КПП" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.legal_address %]">
                    <label class="control-label" for="legal_address">Юридический адрес</label>
                    <div class="controls"><textarea id="legal_address" name="legal_address" placeholder="Юридический адрес" class="span12">[% form.legal_address | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.actual_address %]">
                    <label class="control-label" for="actual_address">Фактический адрес</label>
                    <div class="controls"><textarea id="actual_address" name="actual_address" placeholder="Фактический адрес" class="span12">[% form.actual_address | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.general_manager %]">
                    <label class="control-label" for="general_manager">Генеральный директор</label>
                    <div class="controls"><textarea id="general_manager" name="general_manager" placeholder="Генеральный директор" class="span12">[% form.general_manager | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.main_accountant %]">
                    <label class="control-label" for="main_accountant">Главный бухгалтер</label>
                    <div class="controls"><textarea id="main_accountant" name="main_accountant" placeholder="Главный бухгалтер" class="span12">[% form.main_accountant | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.bank %]">
                    <label class="control-label" for="bank">Полное наименование банка</label>
                    <div class="controls"><textarea id="bank" name="bank" placeholder="Полное наименование банка" class="span12">[% form.bank | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.current_account %]">
                    <label class="control-label" for="current_account">Расчетный счет</label>
                    <div class="controls"><input type="text" id="current_account" name="current_account" value="[% form.current_account | html %]" placeholder="Расчетный счет" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.bik %]">
                    <label class="control-label" for="bik">БИК</label>
                    <div class="controls"><input type="text" id="bik" name="bik" value="[% form.bik | html %]" placeholder="БИК" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.correspondent_account %]">
                    <label class="control-label" for="correspondent_account">Корреспондентский счет</label>
                    <div class="controls"><input type="text" id="correspondent_account" name="correspondent_account" value="[% form.correspondent_account | html %]" placeholder="Корреспондентский счет" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.okpo %]">
                    <label class="control-label" for="okpo">ОКПО</label>
                    <div class="controls"><input type="text" id="okpo" name="okpo" value="[% form.okpo | html %]" placeholder="ОКПО" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.okato %]">
                    <label class="control-label" for="okato">ОКАТО</label>
                    <div class="controls"><input type="text" id="okato" name="okato" value="[% form.okato | html %]" placeholder="ОКАТО" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.tax_inspection %]">
                    <label class="control-label" for="tax_inspection">Налоговая инспекция</label>
                    <div class="controls"><textarea id="tax_inspection" name="tax_inspection" placeholder="Налоговая инспекция" class="span12">[% form.tax_inspection | html %]</textarea></div>
                </div>
            </fieldset>
        </div>
    </form>
    </div>
[% END %]

[% BLOCK submit_buttons %]
    <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn btn-primary">Сохранить</button>
          <a href="/admin/users/" class="btn">Отмена</a>
        </div>
    </div>
[% END %]
