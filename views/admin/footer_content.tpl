<div class="row-fluid">
    <div class="span5">
        <ul class="breadcrumb">
            <li>[% breadcrumbs.size ? '<a href="' _ SCRIPT _ '">Корень</a> <span class="divider">/</span>' : 'Корень' %]</li>
            [% FOR bc = breadcrumbs %]
                [% IF loop.last %]
                    <li class="active">[% bc.name %]</li>
                [% ELSE %]
                    <li><a href="[% SCRIPT _ bc.id _ '/' %]">[% bc.name %]</a> <span class="divider">/</span></li>
                [% END %]
            [% END %]
        </ul>

        <table class="table table-hover">
            <thead>
                <tr>
                    <th class="span1"></th>
                    <th>Название</th>
                    <th class="span1"></th>
                    <th class="span1"></th>
                </tr>
            </thead>
            <tbody class="js_sortable" data-script="[% SCRIPT %]">
            [% FOR i = list %]
                <tr data-id="[% i.id %]">
                    <td class="js_drag_grip"><i class="icon-resize-vertical"></i></td>
                    <td>[% '<a href="' _ SCRIPT _ i.id _ '/">' UNLESS LEVEL_LIMIT %][% i.name %][% '</a>' UNLESS LEVEL_LIMIT %]</td>
                    <td><a href="[% SCRIPT _ 'edit/' _ i.id _ '/' %]"><i class="icon-pencil"></i></a></td>
                    <td><a href="javascript: void(0)" data-url="[% SCRIPT _ 'del/' _ i.id _ '/' %]" class="js_delete"><i class="icon-trash"></i></a></td>
                </tr>
            [% END %]
            </tbody>
        </table>
    </div>

    <div class="span7">
        <form class="form-horizontal" method="post" action="" enctype="multipart/form-data">
        [% IF parent_id %]
            <fieldset>
                <legend>[% form.id ? 'Редактировать страницу' : 'Добавить страницу' %]</legend>
                <div class="control-group [% 'error' IF err.name %]">
                    <label class="control-label" for="name">Название</label>
                    <div class="controls"><input type="text" id="name" name="name" value="[% form.name | html %]" placeholder="Название" class="span12"></div>
                </div>
                <div class="control-group [% 'error' IF err.descr %]">
                    <label class="control-label" for="descr">Текст</label>
                    <div class="controls"><textarea id="descr" name="descr" placeholder="Текст" class="js_editor">[% form.descr | html %]</textarea></div>
                </div>
                <div class="control-group">
                    <div class="controls">
                      <button type="submit" class="btn btn-primary">Сохранить</button>
                      [% IF form.id %]<a href="[% SCRIPT _ parent_id _ '/' %]" class="btn">Отмена</a>[% END %]
                    </div>
                </div>
            </fieldset>
        [% ELSE %]
            <fieldset>
                <legend>[% form.id ? 'Редактировать раздел' : 'Добавить раздел' %]</legend>
                <div class="control-group [% 'error' IF err.name %]">
                    <label class="control-label" for="name">Название</label>
                    <div class="controls"><input type="text" id="name" name="name" value="[% form.name | html %]" placeholder="Название" class="span12"></div>
                </div>
                <input type="hidden" name="descr" value="-">
                <div class="control-group">
                    <div class="controls">
                      <button type="submit" class="btn btn-primary">Сохранить</button>
                      [% IF form.id %]<a href="[% SCRIPT %]" class="btn">Отмена</a>[% END %]
                    </div>
                </div>
            </fieldset>
        [% END %]
        </form>
    </div>
</div>
