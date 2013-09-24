<div class="row-fluid">
    <div class="span5">
        <h3>[% title %]</h3>

        <table class="table table-hover">
            <thead>
                <tr>
                    [% '<th class="span1"></th>' IF sortable %]
                    [%-
                        FOR f IN fields;
                            IF f.in_list;
                                '<th>' _ f.descr _ '</th>';
                            END;
                        END;
                    -%]
                    <th class="span1"></th>
                    <th class="span1"></th>
                </tr>
            </thead>
            <tbody [% 'class="js_sortable" data-script="' _ script _ '"' IF sortable %]>
            [% FOR i = list %]
                <tr [% 'data-id="' _ i.id _ '"' IF sortable %]>
                    [% '<td class="js_drag_grip"><i class="icon-resize-vertical"></i></td>' IF sortable %]
                    [%-
                        FOR f IN fields;
                            IF f.in_list;
                                IF f.type == 'file';
                                    '<td><img src="/resize/100/' _ alias _'/' _ i.${f.name} _ '/" class="img-rounded"></td>';
                                ELSE;
                                    '<td>' _ i.${f.name} _ '</td>';
                                END;
                            END;
                        END;
                    -%]
                    <td><a href="[% script %]edit/[% i.id %]/"><i class="icon-pencil"></i></a></td>
                    <td><a href="javascript: void(0)" data-url="[% script %]del/[% i.id %]/" class="js_delete"><i class="icon-trash"></i></a></td>
                </tr>
            [% END %]
            </tbody>
        </table>
    </div>

    <div class="span7">
        <form class="form-horizontal" method="post" action="" enctype="multipart/form-data">
        <fieldset>
            <legend>[% form.id ? 'Редактировать' : 'Добавить' %]</legend>
            [% FOR f IN fields %]
                [% IF f.type == 'file' %]
                    <div class="control-group [% 'error' IF err.${f.name} %]">
                        <label class="control-label" for="[% f.name %]">[% f.descr %]</label>
                        <div class="controls">
                            <input type="file" id="[% f.name %]" name="[% f.name %]">
                            [% IF form.${f.name} %]
                                <a href="/upload/[% alias %]/[% form.${f.name} %]" target="_blank">
                                    <img src="/resize/100/[% alias %]/[% form.${f.name} %]/" class="img-rounded">
                                </a>
                                <input type="checkbox" name="del_[% f.name %]"> Удалить
                            [% END %]
                        </div>
                    </div>
                [% ELSIF f.type == 'editor' %]
                    <div class="control-group [% 'error' IF err.${f.name} %]">
                        <label class="control-label" for="[% f.name %]">[% f.descr %]</label>
                        <div class="controls"><textarea id="[% f.name %]" name="[% f.name %]" placeholder="[% f.descr %]" class="js_editor">[% form.${f.name} | html %]</textarea></div>
                    </div>
                [% ELSIF f.type == 'text' %]
                    <div class="control-group [% 'error' IF err.${f.name} %]">
                        <label class="control-label" for="[% f.name %]">[% f.descr %]</label>
                        <div class="controls"><input type="text" id="[% f.name %]" name="[% f.name %]" value="[% form.${f.name} | html %]" placeholder="[% f.descr %]" class="span12" [% 'disabled' IF f.readonly %]></div>
                    </div>
                [% END %]
            [% END %]
            <div class="control-group">
                <div class="controls">
                  <button type="submit" class="btn btn-primary">Сохранить</button>
                  [% IF form.id %]<a href="[% script %]" class="btn">Отмена</a>[% END %]
                </div>
            </div>
        </fieldset>
        </form>
    </div>
</div>
