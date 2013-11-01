<div class="row-fluid">
    <ul class="breadcrumb">
        <li>[% breadcrumbs.size ? '<a href="/admin/catalog/">Каталог</a> <span class="divider">/</span>' : 'Каталог' %]</li>
        [% FOR bc = breadcrumbs %]
            [% IF loop.last %]
                <li class="active">[% bc.name %]</li>
            [% ELSE %]
                <li><a href="/admin/catalog/[% bc.id %]/">[% bc.name %]</a> <span class="divider">/</span></li>
            [% END %]
        [% END %]
    </ul>
</div>

<div class="row-fluid">
    <div class="span2">
        <div class="span2 well" data-spy="affix">
            <p><a href="/admin/categories/add/?parent_id=[% parent_id %]" class="btn btn-block">Добавить категорию</a></p>
            <p><a href="/admin/products/add/?categories_id=[% parent_id %]" class="btn btn-block">Добавить товар</a></p>
            <p><a href="#move_to_category" role="button" data-toggle="modal" class="btn btn-block js_move_to_category">Переместить ...</a></p>
        </div>
    </div>

    <div class="span10">
        <select class="span12" onChange="location.href='/admin/catalog/'+this.value+'/'">
            [% INCLUDE admin/inc/tree.tpl tree=tree select=parent_id %]
        </select>

        [% IF categories.size %]
        <table class="table table-hover">
            <thead>
                <tr>
                    <th class="span1"></th>
                    <th class="span1"><i class="icon-random" title="Переместить в категорию"></i></th>
                    <th>Категория</th>
                    <th>Кол-во категорий</th>
                    <th>Кол-во товаров</th>
                    <th class="span1"></th>
                    [% IF vars.loged.acs.admin %]
                        <th class="span1"></th>
                    [% END %]
                </tr>
            </thead>
            <tbody class="js_sortable" data-script="/admin/categories/">
            [% FOR c = categories %]
                <tr [% 'class="error"' UNLESS c.enabled %] data-id="[% c.id %]">
                    <td class="js_drag_grip"><i class="icon-resize-vertical"></i></td>
                    <td><input type="checkbox" class="js_move_category"></td>
                    <td><a href="/admin/catalog/[% c.id %]/">[% c.name %]</a></td>
                    <td>[% c.categories_cnt %]</td>
                    <td>[% c.products_cnt %]</td>
                    <td><a href="/admin/categories/edit/[% c.id %]/"><i class="icon-pencil"></i></a></td>
                    [% IF vars.loged.acs.admin %]
                        <td><a href="javascript: void(0)" data-url="/admin/categories/del/[% c.id %]/" class="js_delete"><i class="icon-trash"></i></a></td>
                    [% END %]
                </tr>
            [% END %]
            </tbody>
        </table>
        [% END %]

        [% IF products.size %]
        <table class="table table-hover">
            <thead>
                <tr>
                    <th class="span1"></th>
                    <th class="span1"><i class="icon-random" title="Переместить в категорию"></i></th>
                    <th>Товар</th>
                    <th>Цена</th>
                    <th>Артикул</th>
                    <th class="span1"></th>
                    [% IF vars.loged.acs.admin %]
                        <th class="span1"></th>
                    [% END %]
                </tr>
            </thead>
            <tbody class="js_sortable" data-script="/admin/products/">
            [% FOR p = products %]
                <tr [% 'class="error"' UNLESS p.enabled %] data-id="[% p.id %]">
                    <td class="js_drag_grip"><i class="icon-resize-vertical"></i></td>
                    <td><input type="checkbox" class="js_move_product"></td>
                    <td>[% p.name %]</td>
                    <td>[% p.price %]</td>
                    <td>[% p.article %]</td>
                    <td><a href="/admin/products/edit/[% p.id %]/"><i class="icon-pencil"></i></a></td>
                    [% IF vars.loged.acs.admin %]
                        <td><a href="javascript: void(0)" data-url="/admin/products/del/[% p.id %]/" class="js_delete"><i class="icon-trash"></i></a></td>
                    [% END %]
                </tr>
            [% END %]
            </tbody>
        </table>
        [% END %]
    </div>
</div>


<div id="move_to_category" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <form class="form-horizontal" method="post" action="/admin/catalog/move_to_category/">
    <input type="hidden" name="categories">
    <input type="hidden" name="products">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Перенести в категорию</h3>
        </div>
        <div class="modal-body">
            <select class="span6" name="category">
                [% INCLUDE admin/inc/tree.tpl tree=tree select=parent_id %]
            </select>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary">Перенести</button>
        </div>
    </form>
</div>
