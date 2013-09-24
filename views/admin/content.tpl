[% PROCESS inc/vars.tpl %]

[% IF action == 'list' %]
    <div class="row-fluid">
        <div class="span2">
            <div class="span2 well" data-spy="affix">
                <p><a href="/admin/content/add/" class="btn btn-block">Добавить</a></p>
            </div>
        </div>

        <div class="span10">
            <h3>Информационные страницы</h3>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Название</th>
                        <th>SEO url</th>
                        <th>Алиас</th>
                        <th>Кол-во товаров</th>
                        <th class="span1"></th>
                        <th class="span1"></th>
                    </tr>
                </thead>
                <tbody>
                [% FOR i = content %]
                    <tr>
                        <td>[% i.name %]</td>
                        <td>[% i.seo_url %]</td>
                        <td>[% content_alias.${i.alias} %]</td>
                        <td>[% i.products_cnt %]</td>
                        <td><a href="/admin/content/[% i.id %]/"><i class="icon-pencil"></i></a></td>
                        <td>[% UNLESS i.alias %]<a href="javascript: void(0)" data-url="/admin/content/del/[% i.id %]/" class="js_delete"><i class="icon-trash"></i></a>[% END %]</td>
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

                [% IF form.alias %]
                <div class="control-group [% 'error' IF err.alias %]">
                    <label class="control-label" for="alias">Алиас</label>
                    <div class="controls"><input type="text" id="alias" name="alias" value="[% content_alias.${form.alias} | html %]" placeholder="Алиас" class="span12" disabled></div>
                </div>
                [% END %]
                <div class="control-group [% 'error' IF err.name %]">
                    <label class="control-label" for="name">Название</label>
                    <div class="controls"><input type="text" id="name" name="name" value="[% form.name | html %]" placeholder="Название" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.descr %]">
                    <label class="control-label" for="descr">Описание</label>
                    <div class="controls"><textarea id="descr" name="descr" placeholder="Описание" class="js_editor">[% form.descr | html %]</textarea></div>
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

                [% INCLUDE submit_buttons %]

            </fieldset>
        </div>

        [% IF products.size %]
        <div class="span5">
            <fieldset>
                <legend>Товары</legend>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th></th>
                            <th>Товар</th>
                        </tr>
                    </thead>
                    <tbody>
                    [% FOR p = products %]
                        <tr [% 'class="error"' UNLESS p.enabled %]>
                            <td>[% IF link_products %]<input type="checkbox" name="products_id" value="[% p.id %]" [% 'checked' IF link.${p.id} %]>[% END %]</td>
                            <td>[% p.name | html %]</td>
                        </tr>
                    [% END %]
                    </tbody>
                </table>
            </fieldset>
        </div>
        [% END %]
    </form>
    </div>
[% END %]

[% BLOCK submit_buttons %]
    <div class="control-group">
        <div class="controls">
            <button type="submit" class="btn btn-primary">Сохранить</button>
            [% IF form.id %]
                <a href="/admin/content/" class="btn">Отмена</a>
                <a href="/admin/content/[% form.id %]/products/" class="btn btn-inverse">Привязать товары</a>
            [% END %]
        </div>
    </div>
[% END %]
