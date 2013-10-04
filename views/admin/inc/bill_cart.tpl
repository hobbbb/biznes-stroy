<div class="span5 hide js_bill_cart" data-redirect-after-close="[% redirect_after_close %]">
    <form method="post" class="form-horizontal well js_bill_cart_form" action="/admin/bill/build/">
    <input type="hidden" name="bills_id" value="">
        <h3>Счет № S-<span class="js_bill_number"></span></h3>
        <div class="control-group">
            <label class="control-label" for="buyer">Покупатель</label>
            <div class="controls">
                <div class="input-append">
                    <input type="hidden" id="buyers_id" name="buyers_id" value="">
                    <input type="text" id="buyer" name="buyer" value="" class="js_search_user">
                    <button class="btn js_user_edit hide" type="button" data-target="#modal_user_cart" data-toggle="modal">Ред.</button>
                    <button class="btn js_user_add" type="button" data-target="#modal_user_cart" data-toggle="modal">Новый</button>
                </div>
            </div>
            <div class="controls js_buyers_email"></div>
        </div>

        <div class="control-group">
            <label class="control-label" for="date">Дата</label>
            <div class="controls">
                <div class="input-append">
                    <input type="text" id="date" name="date" value="" class="span12 datepicker">
                </div>
            </div>
        </div>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Название</th>
                    <th>Кол-во</th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody class="js_bill_cart_products"></tbody>
        </table>

        <div class="control-group">
            <label class="control-label" for="delivery">Доставка</label>
            <div class="controls">
                <div class="input-append">
                    <input type="text" id="delivery" name="delivery" value="" class="span12">
                </div>
                <label class="checkbox inline">
                    <input type="checkbox" name="delivery_by_positions" id="delivery_by_positions" value="1">Размазать
                </label>
            </div>
        </div>

        <div class="js_requisites"></div>
        <div class="js_comments"></div>

        <div class="control-group">
            <div class="controls">
              <button type="button" class="btn js_close_cart">Приостановить</button>
              <button type="submit" class="btn btn-primary" formtarget="_blank">Выставить счет</button>
            </div>
        </div>
    </form>
</div>

[% INCLUDE admin/inc/modal_user_cart.tpl %]
