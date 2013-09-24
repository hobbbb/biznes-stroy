<div class="row-fluid">
    [% IF db.username == 'bstroy' %]
        <form class="form-horizontal" method="post" action="">
        <input type="hidden" name="action" value="backup">
            <div class="span2">
                <div class="span1 well" data-spy="affix">
                    <p><button type="submit" class="btn btn-block">Backup</button></p>
                </div>
            </div>
        </form>
    [% END %]

    <div class="span4">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Файл</th>
                    <th class="span2"></th>
                    <th class="span1"></th>
                </tr>
            </thead>
            <tbody>
            [% FOR d = dumps.reverse %]
            <form class="form-horizontal" method="post" action="">
                <tr>
                    <td>
                        <input type="hidden" name="dump" value="[% d.file %]">
                        [% d.file %]
                    </td>
                    <td><button type="submit" name="action" value="restore" class="btn btn-block">Restore</button></td>
                    <td>[% '<button type="submit" name="action" value="delete" class="btn btn-block"><i class="icon-trash"></i></button>' IF d.uid %]</td>
                </tr>
            </form>
            [% END %]
            </tbody>
        </table>
    </div>
</div>
