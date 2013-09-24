<div class="row-fluid">
    <form class="form-horizontal" method="post" action="" enctype="multipart/form-data">
    <div class="span7">
        <fieldset>
            <legend>[% form.id ? 'Редактировать' : 'Добавить' %] категорию</legend>

            [% INCLUDE submit_buttons %]

            <div class="control-group [% 'error' IF err.enabled %]">
                <label class="control-label" for="enabled">Отображать</label>
                <div class="controls"><input type="checkbox" id="enabled" name="enabled" [% 'checked' IF form.enabled %]></div>
            </div>
            <div class="control-group [% 'error' IF err.parent_id %]">
                <label class="control-label" for="parent_id">В категорию</label>
                <div class="controls">
                    <select name="parent_id" id="parent_id" class="span12">
                        [% INCLUDE admin/inc/tree.tpl tree=tree select=form.parent_id || parent_id %]
                    </select>
                </div>
            </div>
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

    <div class="span5">
        <fieldset>
            <legend>Картинки</legend>
            <div class="control-group [% 'error' IF err.image %]">
                <label class="control-label" for="image">Картинка</label>
                <div class="controls">
                    <input type="file" id="image" name="image">
                    [% IF form.image %]
                        <a href="[% request.uri_base %]/upload/categories/[% form.image %]" target="_blank">
                            <img src="/resize/100/categories/[% form.image %]/" class="img-rounded">
                        </a>
                        <input type="checkbox" name="del_image"> Удалить
                    [% END %]
                </div>
            </div>
        </fieldset>
    </div>
    </form>
</div>

[% BLOCK submit_buttons %]
    <div class="control-group">
        <div class="controls">
          <button type="submit" class="btn btn-primary">Сохранить</button>
          <a href="/admin/catalog/[% form.parent_id %]/" class="btn">Отмена</a>
        </div>
    </div>
[% END %]