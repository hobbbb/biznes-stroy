<div id="modal_user_cart" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <form class="form-horizontal" method="post" action="" data-users-id="">
    <input type="hidden" id="password" name="password" value="" data-val="[% func.generate() %]">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Карточка покупатель</h3>
        </div>
        <div class="modal-body">
            <div class="control-group">
                <label class="control-label" for="type">Тип</label>
                <div class="controls">
                    <select name="type" id="type" data-val="ph" class="js_user_type">
                            <option value="ph">Физическое лицо</option>
                            <option value="ur" [% 'selected' IF form.type == 'ur' %]>Юридическое лицо</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="email">Email</label>
                <div class="controls">
                    <input type="text" id="email" name="email" value="" placeholder="Email">
                    <span class="label label-important hide js_email_exists">Такой E-mail уже существует</span>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="phone">Телефон</label>
                <div class="controls"><input type="text" id="phone" name="phone" value="" placeholder="Телефон"></div>
            </div>
            <div class="control-group">
                <label class="control-label" for="fio">ФИО</label>
                <div class="controls"><input type="text" id="fio" name="fio" value="" data-val="Вальтер Эго" placeholder="ФИО"></div>
            </div>

            <div class="hide" id="js_ur_block">
                <div class="control-group">
                    <label class="control-label" for="firm">Полное наименование</label>
                    <div class="controls"><textarea id="firm" name="firm" placeholder="Полное наименование"></textarea></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="ogrn">ОГРН</label>
                    <div class="controls"><input type="text" id="ogrn" name="ogrn" value="" placeholder="ОГРН"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inn">ИНН</label>
                    <div class="controls">
                        <input type="text" id="inn" name="inn" value="" placeholder="ИНН">
                        [% '<span class="label label-important">Такой ИНН уже существует</span>' IF err.inn_exist %]
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="kpp">КПП</label>
                    <div class="controls"><input type="text" id="kpp" name="kpp" value="" placeholder="КПП"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="legal_address">Юридический адрес</label>
                    <div class="controls"><textarea id="legal_address" name="legal_address" placeholder="Юридический адрес"></textarea></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="actual_address">Фактический адрес</label>
                    <div class="controls"><textarea id="actual_address" name="actual_address" placeholder="Фактический адрес"></textarea></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="general_manager">Генеральный директор</label>
                    <div class="controls"><textarea id="general_manager" name="general_manager" placeholder="Генеральный директор"></textarea></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="main_accountant">Главный бухгалтер</label>
                    <div class="controls"><textarea id="main_accountant" name="main_accountant" placeholder="Главный бухгалтер"></textarea></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="bank">Полное наименование банка</label>
                    <div class="controls"><textarea id="bank" name="bank" placeholder="Полное наименование банка"></textarea></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="current_account">Расчетный счет</label>
                    <div class="controls"><input type="text" id="current_account" name="current_account" value="" placeholder="Расчетный счет"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="bik">БИК</label>
                    <div class="controls"><input type="text" id="bik" name="bik" value="" placeholder="БИК"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="correspondent_account">Корреспондентский счет</label>
                    <div class="controls"><input type="text" id="correspondent_account" name="correspondent_account" value="" placeholder="Корреспондентский счет"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="okpo">ОКПО</label>
                    <div class="controls"><input type="text" id="okpo" name="okpo" value="" placeholder="ОКПО"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="okato">ОКАТО</label>
                    <div class="controls"><input type="text" id="okato" name="okato" value="" placeholder="ОКАТО"></div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="tax_inspection">Налоговая инспекция</label>
                    <div class="controls"><textarea id="tax_inspection" name="tax_inspection" placeholder="Налоговая инспекция"></textarea></div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary js_user_save">Сохранить</button>
        </div>
    </form>
</div>
