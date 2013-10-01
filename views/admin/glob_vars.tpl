<div class="row-fluid">
    <form class="form-horizontal" method="post" action="">
    <div class="span2">
        <div class="span2 well" data-spy="affix">
            <p><button type="submit" class="btn btn-block">Сохранить</button></p>
        </div>
    </div>

    <div class="span10">
        <ul class="nav nav-pills">
            <li [% 'class="active"' IF type == 'shop' %]><a href="/admin/glob_vars/">Магазин</a></li>
            <li [% 'class="active"' IF type == 'seller' %]><a href="/admin/glob_vars/?type=seller">Реквизиты продавца</a></li>
        </ul>

        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Название</th>
                    <th>Описание</th>
                    <th width="70%">Значение</th>
                </tr>
            </thead>
            <tbody>
            [% FOR g = glob_vars %]
                <tr>
                    <td>
                        <input type="hidden" name="id" value="[% g.id %]">
                        [% g.name %]
                    </td>
                    <td>[% g.descr %]</td>
                    <td>
                        [% IF g.type == 'input' %]
                            <input type="text" name="val_[% g.id %]" value="[% g.val | html %]" class="span12">
                        [% ELSIF g.type == 'textarea' %]
                            <textarea name="val_[% g.id %]" class="span12">[% g.val | html %]</textarea>
                        [% END %]
                    </td>
                </tr>
            [% END %]
            </tbody>
        </table>
    </div>
    </form>
</div>
