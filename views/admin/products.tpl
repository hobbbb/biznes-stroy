<form class="form-horizontal" method="post" action="" enctype="multipart/form-data">
[% IF action == 'all' %]
    <div class="row-fluid">
        <div class="span2">
            <div class="span2 well" data-spy="affix">
                <p><button type="submit" class="btn btn-block">Сохранить</button></p>
            </div>
        </div>

        <div class="span10">
            <select class="span12" onChange="location.href='/admin/products/all/?categories_id=' + this.value">
                <option value="">-- Не выбрано -- </option>
                [% INCLUDE admin/inc/tree.tpl tree=tree select=categories_id %]
            </select>

            <div style="padding-top: 20px"></div>

            <table class="table table-condensed">
                <thead>
                    <tr>
                        <th><input type="checkbox" class="js_checkbox_for_many_enabled"> Отображать</th>
                        <th>Товар</th>
                        <th>Цена</th>
                        <th>Артикул</th>
                        <th>Краткое описание</th>
                        <th><input type="checkbox" class="js_checkbox_for_many_yandex_market"> Яндекс Маркет</th>
                    </tr>
                </thead>
                <tbody>
                [% FOR p = products %]
                    <tr [% 'class="error"' UNLESS p.enabled %]>
                        <input type="hidden" name="id" value="[% p.id %]">
                        <td><input type="checkbox" name="enabled_[% p.id %]" class="js_checkbox_on_of_enabled" [% 'checked' IF p.enabled %]></td>
                        <td><input type="text" name="name_[% p.id %]" value="[% p.name | html %]"></td>
                        <td><input type="text" name="price_[% p.id %]" value="[% p.price | html %]"></td>
                        <td><input type="text" name="article_[% p.id %]" value="[% p.article | html %]"></td>
                        <td><textarea name="short_descr_[% p.id %]" rows="1">[% p.short_descr | html %]</textarea></td>
                        <td><input type="checkbox" name="yandex_market_[% p.id %]" class="js_checkbox_on_of_yandex_market" [% 'checked' IF p.yandex_market %]></td>
                    </tr>
                [% END %]
                </tbody>
            </table>
        </div>
    </div>
[% ELSE %]
    <div class="row-fluid">
        <div class="span8">
            <fieldset>
                <legend>[% form.id ? 'Редактировать' : 'Добавить' %] товар</legend>

                [% INCLUDE submit_buttons %]

                <div class="control-group [% 'error' IF err.enabled %]">
                    <label class="control-label" for="enabled">Отображать</label>
                    <div class="controls"><input type="checkbox" id="enabled" name="enabled" [% 'checked' IF form.enabled %]></div>
                </div>
                <div class="control-group [% 'error' IF err.categories_id %]">
                    <label class="control-label" for="categories_id">Категория</label>
                    <div class="controls">
                        <select name="categories_id" id="categories_id" class="span12">
                            [% INCLUDE admin/inc/tree.tpl tree=tree select=form.categories_id || categories_id %]
                        </select>
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.manufacturers_id %]">
                    <label class="control-label" for="manufacturers_id">Производитель</label>
                    <div class="controls">
                        <select name="manufacturers_id" id="manufacturers_id" class="span12">
                            <option value="0">---</option>
                            [% FOR m = manufacturers %]
                                <option value="[% m.id %]" [% 'selected' IF m.id == form.manufacturers_id %]>[% m.name %]</option>
                            [% END %]
                        </select>
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.name %]">
                    <label class="control-label" for="name">Название</label>
                    <div class="controls"><input type="text" id="name" name="name" value="[% form.name | html %]" placeholder="Название" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.short_descr %]">
                    <label class="control-label" for="short_descr">Краткое описание</label>
                    <div class="controls"><textarea id="short_descr" name="short_descr" placeholder="Краткое описание" class="js_editor">[% form.short_descr | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.detailed_chars %]">
                    <label class="control-label" for="detailed_chars">Подробные характеристики</label>
                    <div class="controls"><textarea id="detailed_chars" name="detailed_chars" placeholder="Подробные характеристики" class="js_editor">[% form.detailed_chars | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.descr %]">
                    <label class="control-label" for="descr">Описание</label>
                    <div class="controls"><textarea id="descr" name="descr" placeholder="Описание" class="js_editor">[% form.descr | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.price %]">
                    <label class="control-label" for="price">Цена</label>
                    <div class="controls"><input type="text" id="price" name="price" value="[% form.price | html %]" placeholder="Цена" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.sale_price %]">
                    <label class="control-label" for="sale_price">Распродажа по цене</label>
                    <div class="controls"><input type="text" id="sale_price" name="sale_price" value="[% form.sale_price | html %]" placeholder="Распродажа по цене" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.article %]">
                    <label class="control-label" for="article">Артикул</label>
                    <div class="controls"><input type="text" id="article" name="article" value="[% form.article | html %]" placeholder="Артикул" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.supplier %]">
                    <label class="control-label" for="supplier">Поставщик</label>
                    <div class="controls"><input type="text" id="supplier" name="supplier" value="[% form.supplier | html %]" placeholder="Поставщик" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.hit %]">
                    <label class="control-label" for="hit">Лидер продаж</label>
                    <div class="controls"><input type="checkbox" id="hit" name="hit" [% 'checked' IF form.hit %]></div>
                </div>
                <div class="control-group [% 'error' IF err.special %]">
                    <label class="control-label" for="special">Специальная цена</label>
                    <div class="controls"><input type="checkbox" id="special" name="special" [% 'checked' IF form.special %]></div>
                </div>
                <div class="control-group [% 'error' IF err.new %]">
                    <label class="control-label" for="new">Новинка</label>
                    <div class="controls"><input type="checkbox" id="new" name="new" [% 'checked' IF form.new %]></div>
                </div>
                <div class="control-group [% 'error' IF err.seo_url %]">
                    <label class="control-label" for="seo_url">SEO url</label>
                    <div class="controls"><input type="text" id="seo_url" name="seo_url" value="[% form.seo_url | html %]" placeholder="SEO url" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.seo_title %]">
                    <label class="control-label" for="seo_title">SEO title</label>
                    <div class="controls"><input type="text" id="seo_title" name="seo_title" value="[% form.seo_title | html %]" placeholder="SEO title" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.seo_keywords %]">
                    <label class="control-label" for="seo_keywords">SEO keywords</label>
                    <div class="controls"><input type="text" id="seo_keywords" name="seo_keywords" value="[% form.seo_keywords | html %]" placeholder="SEO keywords" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.seo_description %]">
                    <label class="control-label" for="seo_description">SEO description</label>
                    <div class="controls"><textarea id="seo_description" name="seo_description" class="span12">[% form.seo_description | html %]</textarea></div>
                </div>
                <div class="control-group [% 'error' IF err.yandex_market %]">
                    <label class="control-label" for="yandex_market">Яндекс Маркет</label>
                    <div class="controls"><input type="checkbox" id="yandex_market" name="yandex_market" [% 'checked' IF form.yandex_market %]></div>
                </div>

                [% INCLUDE submit_buttons %]

            </fieldset>
        </div>

        <div class="span4">
            <fieldset>
                <legend>Картинки</legend>
                [% FOR i = [1..4]; SET img = 'image_' _ i; %]
                    <div class="control-group [% 'error' IF err.$img %]">
                        <label class="control-label" for="image_[% i %]">Картинка [% i %]</label>
                        <div class="controls">
                            <input type="file" id="image_[% i %]" name="image_[% i %]">
                            [% IF form.$img %]
                                <a href="[% request.uri_base %]/upload/products/[% form.$img %]" target="_blank">
                                    <img src="/resize/100/products/[% form.$img %]/" class="img-rounded">
                                </a>
                                <input type="checkbox" name="del_image_[% i %]"> Удалить
                            [% END %]
                        </div>
                    </div>
                [% END %]
            </fieldset>

            <fieldset>
                <legend>Акция</legend>
                <div class="control-group [% 'error' IF err.stock_till %]">
                    <label class="control-label" for="stock_till_date">До</label>
                    <div class="controls">
                        [% SET matches = form.stock_till.match('^(\d{4}\-\d{2}\-\d{2}) (\d{2})\:(\d{2})(:\d{2})?$') %]
                        <input type="text" id="stock_till_date" name="stock_till_date" value="[% (matches.0 || '0000-00-00') | html %]" class="span3 datepicker">
                        <select id="stock_till_hour" name="stock_till_hour" class="span2">
                            [% FOR i = [0..23]; SET i = i < 10 ? '0' _ i : i; %]
                                <option value="[% i %]" [% 'selected' IF matches.1 == i %]>[% i %]</option>
                            [% END %]
                        </select>
                        :
                        <select id="stock_till_min" name="stock_till_min" class="span2">
                            [% FOR i = [0..59]; SET i = i < 10 ? '0' _ i : i; %]
                                <option value="[% i %]" [% 'selected' IF matches.2 == i %]>[% i %]</option>
                            [% END %]
                        </select>
                    </div>
                </div>
                <div class="control-group [% 'error' IF err.stock_price %]">
                    <label class="control-label" for="stock_price">Цена по акции</label>
                    <div class="controls"><input type="text" id="stock_price" name="stock_price" value="[% form.stock_price | html %]" placeholder="Цена по акции" class="span12 js_stock"></div>
                </div>
                <div class="control-group [% 'error' IF err.stock_discount %]">
                    <label class="control-label" for="stock_discount">Скидка по акции</label>
                    <div class="controls"><input type="text" id="stock_discount" name="stock_discount" value="[% form.stock_discount | html %]" placeholder="Скидка по акции" class="span12 js_stock"></div>
                </div>
            </fieldset>
        </div>
    </div>
[% END %]
</form>

[% BLOCK submit_buttons %]
    <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn btn-primary">Сохранить</button>
          <a href="/admin/catalog/[% form.categories_id %]/" class="btn">Отмена</a>
        </div>
    </div>
[% END %]
