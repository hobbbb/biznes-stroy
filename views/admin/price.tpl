<div class="row-fluid">
    <div class="accordion-group well" data-spy="affix" style="width: 96%">
        <div class="accordion-heading">
            <a class="accordion-toggle" data-toggle="collapse" href="#cfg_collapse">Свернуть / Развернуть</a>
        </div>
        <div id="cfg_collapse" class="accordion-body collapse in">
            <div class="accordion-inner">
                <form class="form-horizontal" method="post" action="" enctype="multipart/form-data">
                    <div class="span3">
                        <div class="control-group [% 'error' IF err.cfg %]">
                            <input type="hidden" name="id" id="js_price_cfg_id" value="[% form.id %]">
                            <label class="control-label" for="cfg">Конфиг</label>
                            <div class="controls">
                                <select name="cfg" id="js_price_cfg" class="span12">
                                    <option value="">-- Не выбран --</option>
                                    [% FOR f = configs %]
                                        <option value="[% f.id %]" [% 'selected' IF form.id == f.id %]>[% f.name %]</option>
                                    [% END %]
                                </select>
                            </div>
                        </div>
                        <div class="control-group [% 'error' IF err.xls %]">
                            <label class="control-label" for="xls">XLS прайс</label>
                            <div class="controls"><input type="file" id="xls" name="xls" class="span12"></div>
                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <button type="submit" name="action" value="parse" class="btn btn-primary">Распарсить</button>
                            </div>
                        </div>
                        <div class="control-group [% 'error' IF err.comments %]">
                            <textarea id="js_price_cfg_comments" name="comments" class="span12" placeholder="Комментарии">[% form.comments | html %]</textarea>
                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <button type="submit" name="action" value="save" class="btn">Сохранить конфиг</button>
                            </div>
                        </div>
                    </div>

                    <div class="span3">
                        <div class="control-group [% 'error' IF err.name %]">
                            <label class="control-label" for="name">Название конфига</label>
                            <div class="controls"><input type="text" id="js_price_cfg_name" name="name" value="[% form.name | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.worksheet %]">
                            <label class="control-label" for="worksheet">Номер вкладки</label>
                            <div class="controls">
                                <select id="js_price_cfg_worksheet" name="worksheet" class="span12">
                                    [% FOR i = [1..10] %]
                                        <option value="[% i %]" [% 'selected' IF i == form.worksheet %]>[% i %]</option>
                                    [% END %]
                                </select>
                            </div>
                        </div>
                        <div class="control-group [% 'error' IF err.start_row %]">
                            <label class="control-label" for="start_row">Начинать со строчки</label>
                            <div class="controls"><input type="text" id="js_price_cfg_start_row" name="start_row" value="[% (form.id ? form.start_row : 1) | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.end_row %]">
                            <label class="control-label" for="end_row">Заканчивать строчкой</label>
                            <div class="controls"><input type="text" id="js_price_cfg_end_row" name="end_row" value="[% form.end_row | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.overjump_row %]">
                            <label class="control-label" for="overjump_row">Перепрыгивать строчки</label>
                            <div class="controls"><input type="text" id="js_price_cfg_overjump_row" name="overjump_row" value="[% form.overjump_row | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.only_row %]">
                            <label class="control-label" for="only_row">Только строчки</label>
                            <div class="controls"><input type="text" id="only_row" name="only_row" value="[% form.only_row | html %]" class="span12"></div>
                        </div>
                    </div>
                    <div class="span3">
                        <div class="control-group [% 'error' IF err.categories_name %]">
                            <label class="control-label" for="categories_name">Категория (№ колонки)</label>
                            <div class="controls"><input type="text" id="js_price_cfg_categories_name" name="categories_name" value="[% (form.id ? form.categories_name : 1) | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.products_name %]">
                            <label class="control-label" for="products_name">Название товара (№ колонки)</label>
                            <div class="controls">
                                <input type="text" id="js_price_cfg_products_name" name="products_name" value="[% (form.id ? form.products_name : 1) | html %]" class="span12">
                            </div>
                        </div>
                        <div class="control-group [% 'error' IF err.products_price %]">
                            <label class="control-label" for="products_price">Цена товара (№ колонки)</label>
                            <div class="controls">
                                <input type="text" id="js_price_cfg_products_price" name="products_price" value="[% form.products_price | html %]" class="span12">
                            </div>
                        </div>
                        <div class="control-group [% 'error' IF err.products_short_descr %]">
                            <label class="control-label" for="products_short_descr">Короткое описание товара (№ колонки)</label>
                            <div class="controls">
                                <textarea id="js_price_cfg_products_short_descr" name="products_short_descr" class="span12">[% (form.id ? form.products_short_descr : "'Вес 1000 шт ' + 4 + '<br>' + 'В упаковке шт. ' + 5 + '<br>' + 'Размер ' + 3 + '<br>' + 'Цена указана за 1 шт ' + '<br>' + 'Продаем от шт. ' + 5") | html %]</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="span3">
                        <div class="control-group [% 'error' IF err.main_category %]">
                            <label class="control-label" for="main_category">Загружать в</label>
                            <div class="controls">
                                <select id="js_price_cfg_main_category" name="main_category" class="span12">
                                    [% INCLUDE admin/inc/tree.tpl tree=tree select=form.main_category %]
                                </select>
                            </div>
                        </div>
                        <div class="control-group [% 'error' IF err.uniq %]">
                            <label class="control-label" for="uniq">Уникальность</label>
                            <div class="controls"><input type="text" id="js_price_cfg_uniq" name="uniq" value="[% (form.id ? form.uniq : 'products_name') | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.change_products_price %]">
                            <label class="control-label" for="change_products_price">Изменение цен товаров</label>
                            <div class="controls"><input type="text" id="js_price_cfg_change_products_price" name="change_products_price" value="[% (form.id ? form.change_products_price : '(products_price / 1000) * 1.3') | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.price_diff_koef %]">
                            <label class="control-label" for="price_diff_koef">Коэф-нт разницы цен</label>
                            <div class="controls"><input type="text" id="js_price_cfg_price_diff_koef" name="price_diff_koef" value="[% form.price_diff_koef | html %]" class="span12"></div>
                        </div>
                        <div class="control-group [% 'error' IF err.supplier %]">
                            <label class="control-label" for="supplier">Поставщик</label>
                            <div class="controls"><input type="text" id="js_price_cfg_supplier" name="supplier" value="[% form.supplier | html %]" class="span12"></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

[% IF main_category.name; %]
<div class="row-fluid" style="padding-top: 400px">
    <div class="span12">
		<form method="post" action="/admin/price/update/" enctype="multipart/form-data">
		<input type="hidden" name="main_category_id" value="[% main_category.id %]">
			<div class="bold text-center">Категория: [% main_category.name %]</div>
			<div class="bold text-center">Производитель:
				<select name="manufacturers_id">
					<option value="">- Не выбран -</option>
					[% FOR m IN manufacturers %]
						<option value="[% m.id %]">[% m.name %]</option>
					[% END %]
				</select>
			</div>
			<table class="table table-bordered">
				<tr style="background-color: orange">
					[% IF only_categories %]
						<td>Номер строки</td>
						<td>Категория</td>
                        <td>Картинка</td>
					[% ELSE %]
                        <td>Номер строки</td>
                        <td>UPL</td>
                        <td>DEL</td>
                        <td>ID в базе</td>
                        <td>Название</td>
						<td>Цена</td>
                        <td>Цена в базе</td>
                        <td>Картинка</td>
                        <td>Краткое описание</td>
					[% END %]
				</tr>
			[%
				FOR c IN categories_name;
				SET category_index = loop.count;
			%]
				[% IF c.row %]
					<tr class="price_upload_cat" data-ind="[% category_index %]">
						<td>[% c.row %]</td>
						[% IF only_categories %]
							<td>
								<input type="checkbox" class="js_price_cat_check" name="category.[% category_index %].enabled" checked>
								<input type="hidden" name="category.[% category_index %].id" value="[% c.id %]">
								<input type="hidden" name="category.[% category_index %].name" value="[% c.name %]">
								[% c.name %]
								[%
									IF c.id;
										'<span class="blue">[' _ c.id _ ']</span>';
									ELSE;
										'<span class="red">[Новая]</span>';
									END;
								%]
							</td>
                            <td>[% IF c.image %]<img src="/resize/40/categories/[% c.image %]/" class="img-rounded">[% END %] <input type="file" name="category.[% category_index %].file"></td>
						[% ELSE %]
							<td><input type="checkbox" class="js_price_cat_check" name="category.[% category_index %].enabled" [% c.products.size ? 'checked' : 'disabled'%]></td>
                            <td>&nbsp;</td>
                            <td>
                                [% IF c.name %]
                                    <input type="hidden" name="category.[% category_index %].id" value="[% c.id %]">
                                    <input type="hidden" name="category.[% category_index %].name" value="[% c.name %]">
                                    [%
                                        IF c.id;
                                            c.id;
                                        ELSE;
                                            '<span class="red">Новая</span>';
                                        END;
                                    %]
                                [% END %]
                            </td>
							<td>[% c.name %]</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>[% IF c.image %]<img src="/resize/40/categories/[% c.image %]/" class="img-rounded">[% END %] <input type="file" name="category.[% category_index %].file"></td>
                            <td>&nbsp;</td>
						[% END %]
					</tr>
				[% END %]

				[%
					UNLESS only_categories;
					FOR p IN c.products;
					SET product_index = loop.count;
				%]
					<tr [% 'class="price_upload_odd"' IF loop.index % 2 == 1 %]>
						<td>[% p.row %]</td>
                        <td>
                            [% IF !p.id_error AND !p.from_db %]
                                [%-
                                    IF form.price_diff_koef AND p.id;
                                        USE Math;
                                        SET price_db = p.price_db ? p.price_db : 0.001;
                                        SET products_price = p.products_price ? p.products_price : 0.001;
                                        SET diff = Math.abs(products_price / price_db);
                                    END;
                                -%]
                                <input type="checkbox" class="js_price_prod_check_[% category_index %]" name="[% category_index %].product.[% product_index %].enabled"
                                    [%-
                                        IF diff;
                                            'checked' IF diff > 1 / form.price_diff_koef AND diff < form.price_diff_koef;
                                        ELSE;
                                            'checked';
                                        END;
                                    -%]
                                > [% FILTER format('%02.1f'); diff; END; %]
                            [% END %]
                        </td>
						<td>
							[% IF p.from_db %]
								<input type="checkbox" name="[% category_index %].product.[% product_index %].delete">
							[% END %]
						</td>
						<td>
                            <input type="hidden" name="[% category_index %].product.[% product_index %].id" value="[% p.id %]">
                            <input type="hidden" name="[% category_index %].product.[% product_index %].supplier" value="[% form.supplier %]">
							[% IF p.id_error %]
								<span class="red">[% p.id_error.msg %]</span>
							[% ELSE %]
								[% p.id ? p.id : '<div class="red">Новый</div>' %]

                                [% IF p.from_db %]
                                    <div class="bold">Товар из базы</div>
								[% ELSIF p.id AND p.id != p.id_in_category %]
									<div class="red">Товар не из этой категории</div>
								[% END %]
							[% END %]
						</td>
						<td>
                            [% IF p.from_db %]
                                [% p.products_name | html %]
                            [% ELSE %]
                                <input type="text" class="price_upload" size="25" name="[% category_index %].product.[% product_index %].products_name" value="[% p.products_name | html %]">
                            [% END %]
                        </td>
                        <td>
                            [% IF p.from_db %]
                                [% p.products_price %]
                            [% ELSE %]
                                <input type="text" class="price_upload" size="6" name="[% category_index %].product.[% product_index %].products_price" value="[% p.products_price %]">
                            [% END %]
                        </td>
                        <td>[% p.price_db %]</td>
						<td>[% IF p.img %]<img src="/resize/40/products/[% p.img %]/" class="img-rounded">[% END %]<input type="file" name="[% category_index %].product.[% product_index %].file"></td>
                        <td>
                            [% IF p.from_db %]
                                [% p.products_short_descr | html %]
                            [% ELSE %]
                                <textarea class="price_upload" rows="2" cols="25" name="[% category_index %].product.[% product_index %].products_short_descr">[% p.products_short_descr | html%]</textarea>
                            [% END %]
                        </td>
					</tr>
				[%
					END;
					END;
				%]
			[% END %]
			</table>
			<button type="submit" name="action" value="update" class="btn">Сохранить</button>
			[% UNLESS only_categories %]<input type="checkbox" name="update_price"> Только обновить цены[% END %]
		</form>
	</div>
</div>
[% END %]

