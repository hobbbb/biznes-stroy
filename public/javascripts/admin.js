$(function(){
    $.each($(".icon-trash"), function() { $(this).attr('title', 'Удалить'); });
    $.each($(".icon-pencil"), function() { $(this).attr('title', 'Редактировать'); });
    $.each($(".icon-resize-vertical"), function() { $(this).attr('title', 'Сортировка'); });

    $.each($(".datepicker"), function() {
        $(this).datepicker({ dateFormat: "yy-mm-dd" });
        if (!$(this).val()) $(this).datepicker('setDate', new Date());
    });
    $('.js_delete').click(function(){
        if (confirm('Удалить?')) {
            var $el = $(this);
            $.ajax({
                url: $el.data('url'),
                success: function(ans) {
                    $el.closest('tr').remove();
                    var linked_del = $el.closest('tr').data('linked_del');
                    if (linked_del)
                        $('.js_linked_del_' + linked_del).remove();
                }
            });
        }
    });
    $('.js_editor').each(function(){
        var name = $(this).attr('name');
        CKEDITOR.replace(name, {
            toolbar : 'MyToolbar'
        });
    });
    $('.js_sortable').sortable({
        revert: true,
        handle: '.js_drag_grip',
        cursor: 'move',
        stop: function( event, ui ) {
            var arr = [];
            $(this).find('tr').each(function(i) {
                arr.push($(this).data('id'));
            });
            $.ajax({
                type: "POST",
                url: $(this).data('script') + "rearrange/",
                data: {
                    id: arr,
                },
                success: function(ans) {
                }
            });
        },
    });

    // Check many checkbox
    function check_many_cb() {
        var many_cb = new Object();
        $('input[class^="js_checkbox_on_of_"]').each(function(){
            var matches = this.className.match(/^js_checkbox_on_of_(\w+)$/);
            if (many_cb[matches[1]] == undefined) {
                many_cb[matches[1]] = 1;
            }
            if (this.checked == false) {
                many_cb[matches[1]] = 0;
            }
        });
        for (var c in many_cb) {
            if (many_cb[c]) {
                $('.js_checkbox_for_many_' + c).prop('checked','checked');
            }
            else {
                $('.js_checkbox_for_many_' + c).prop('checked','');
            }
        }
    }
    check_many_cb();
    $('input[class^="js_checkbox_on_of_"]').click(function() {
        check_many_cb();
    });
    $('input[class^="js_checkbox_for_many_"]').click(function(){
        var matches = this.className.match(/^js_checkbox_for_many_(\w+)$/);
        var ch = this.checked;
        $('.js_checkbox_on_of_' + matches[1]).each(function(){ this.checked = ch; })
    });
});

//------------------------------ Catalog -----------------------------
$(function() {
    $('.js_move_to_category').click(function(){
        var cat = new Array();
        $('.js_move_category').each(function() {
            if ($(this).prop('checked')) {
                var id = $(this).closest('tr').data('id');
                cat.push(id);
            }
            if (cat.length)
                $('#move_to_category').find('input[name="categories"]').val(cat);
        });
        var prod = new Array();
        $('.js_move_product').each(function() {
            if ($(this).prop('checked')) {
                var id = $(this).closest('tr').data('id');
                prod.push(id);
            }
            if (prod.length)
                $('#move_to_category').find('input[name="products"]').val(prod);
        });
    });
    $('.js_stock').keyup(function(){
        var price = $('#price').val();
        if (price > 0) {
            var val = $(this).val();
            if ($(this).attr('id') == 'stock_discount') {
                var new_price = price - price * val / 100;
                $('#stock_price').val(new_price);
            }
            else {
                var discount = Math.floor((1 - val / price) * 100);
                $('#stock_discount').val(discount);
            }
        }
        else {
            $('.js_stock').val('').attr('placeholder','Заполните цену!');
        }
    });
    $('.js_price_cat_check').click(function(){
        var i = $(this).closest('tr').attr('data-ind');
        $('.js_price_prod_check_' + i).each(function(){ this.checked = !this.checked; })
    });
    $('input[class^="js_price_prod_check_"]').click(function(){
        var matches = this.className.match(/^js_price_prod_check_(\d+)$/);
        var full = 0;
        $('.js_price_prod_check_' + matches[1]).each(function(){
            if (this.checked == true) {
                full = 1;
            }
        });
        $('.js_price_cat_check').each(function(){
            var i = $(this).closest('tr').attr('data-ind');
            if (i == matches[1]) {
                if (full)
                    this.checked = true;
                else
                    this.checked = false;
            }
        });
    });
    $('#js_price_cfg').change(function(){
        $.post('/admin/price/get_cfg/' + $(this).val() + '/')
            .done(function(data) {
                for (var k in data) {
                    $('#js_price_cfg_' + k).val(data[k]);
                }
            });
    })
});

//------------------------------ Orders -----------------------------
$(function() {
    $('.js_order_process').click(function(){
        if (confirm('Взять заказ в обработку?')) {
            var url = $(this).data('url');
            location.href = url;
        }
    });
    $('.js_order_new').click(function(){
        if (confirm('Отказаться от обработки?')) {
            var url = $(this).data('url');
            location.href = url;
        }
    });
    $('.js_order_done').click(function(){
        if (confirm('Переместить заказ в завершенные?')) {
            var url = $(this).data('url');
            location.href = url;
        }
    });
    $('.js_order_cancel').click(function(){
        if (confirm('Переместить заказ в отмененные?')) {
            var url = $(this).data('url');
            location.href = url;
        }
    });
    $('.js_order_bill_payment').click(function(){
        var orders_id = $(this).data('orders_id');
        $('#modal_bill_payment').find('form').attr('action', '/admin/orders/to/done/' + orders_id + '/');
    });
    $('.js_to_manager').click(function(){
        var orders_id = $(this).data('orders_id');
        var managers_id = $(this).data('managers_id');
        $('#modal_to_manager').find('select[name="managers_id"]').val(managers_id);
        $('#modal_to_manager').find('form').attr('action', '/admin/orders/to/manager/' + orders_id + '/');
    });
});

//------------------------------ Users -----------------------------
$(function() {
    if ($('.js_is_partner').prop('checked'))
        $('#js_partner_block').show();

    $('.js_is_partner').click(function(){
        if ($('.js_is_partner').prop('checked'))
            $('#js_partner_block').show();
        else
            $('#js_partner_block').hide();
    });

    if ($('.js_user_type').val() == 'ur')
        $('#js_ur_block').show();

    $('.js_user_type').change(function(){
        if ($('.js_user_type').val() == 'ur') {
            $('#js_ur_block').show();
        }
        else {
            $('#js_ur_block').hide();
        }
    });

    // Модальное окно
    var $modal_user_cart = $('#modal_user_cart');
    $modal_user_cart.on('show', function () {
        var $form = $(this).find('form');
        var id = $form.data('users-id');
        if (id) {
            $.ajax({
                url: "/admin/users/get/" + id + "/",
                success: function(ans) {
                    if (ans.type == 'ur') {
                        $('#js_ur_block', $form).show();
                    }
                    else {
                        $('#js_ur_block', $form).hide();
                    }

                    for (var f in ans) {
                        $('#' + f, $form).val(ans[f]);
                    }
                }
            });
        }
        else {
            $('#js_ur_block', $form).hide();
            // $('input, select, textarea', $form).val('');
            $('input, select, textarea', $form).each(function() {
                if ($(this).data('val'))
                    $(this).val($(this).data('val'));
                else
                    $(this).val('');
            });
        }
    });

    $('.js_user_save').click(function() {
        var $form = $(this).closest('form');

        $.ajax({
            type: $form.attr('method'),
            url: $form.attr('action'),
            data: $form.serialize(),
            success: function(ans) {
                if (ans.id) {
                    if ($('.js_bill_cart_form')) {
                        $('#buyers_id', '.js_bill_cart_form').val(ans.id);
                        $('#buyer', '.js_bill_cart_form').val(ans.form.type == 'ph' ? ans.form.fio : ans.form.firm);
                        $('.js_buyers_email', '.js_bill_cart_form').html(ans.form.email);
                    }
                    $modal_user_cart.modal('hide');
                }
                else {
                    $form.find('div.control-group').each(function() {
                        $(this).removeClass('error');
                    });
                    $form.find('.js_email_exists').hide();

                    for (var f in ans.err) {
                        $form.find('#' + f).closest('div.control-group').addClass('error');
                    }

                    if (ans.err.email_exist)
                        $form.find('.js_email_exists').show();
                }
            }
        });
        return false;
    });
});

//------------------------------ Bill cart --------------------
var bill_cart;

$(function() {
    var $bill_cart_form = $('.js_bill_cart_form');
    if ($bill_cart_form.length) {
        $.ajax({
            url: "/admin/bill/cart/",
            success: function(ans) {
                bill_cart = ans;
                bill_cart_draw();
            }
        });

        $('.js_to_bill_cart').click(function(){
            var b_id = $bill_cart_form.find('input[name="bills_id"]').val();
            var p_id = $(this).data('product');
            $.ajax({
                url: "/admin/bill/add_product/",
                data: {
                    bills_id: b_id,
                    products_id: p_id,
                },
                success: function(ans) {
                    bill_cart = ans;
                    bill_cart_draw();
                }
            });
        });

        $('.js_close_cart', $bill_cart_form).click(function(){
            var redirect = $('.js_bill_cart').data('redirect-after-close');
            save_bill_cart('status=closed', redirect);
        });

        $('.js_search_user', $bill_cart_form).autocomplete({
            source: function(request, response){
                // организуем кроссдоменный запрос
                $.ajax({
                    url: "/admin/search/user/",
                    dataType: "json",
                    // параметры запроса, передаваемые на сервер (последний - подстрока для поиска):
                    data:{
                        featureClass: "P",
                        style: "full",
                        limit: 20,
                        search_word: request.term
                    },
                    // обработка успешного выполнения запроса
                    success: function(data){
                        // приведем полученные данные к необходимому формату и передадим в предоставленную функцию response
                        response(
                            $.map(data, function(item){
                                return{
                                    label: (item.type == 'ph' ? item.fio : item.firm) + ' | ИНН ' + item.inn,
                                    value: (item.type == 'ph' ? item.fio : item.firm),
                                    id: item.id,
                                    email: item.email
                                }
                            })
                        );
                    }
                });
            },
            minLength: 1,
            select: function( event, ui ) {
                $('input[name="buyers_id"]', $bill_cart_form).val(ui.item.id);
                $('.js_buyers_email', $bill_cart_form).html(ui.item.email);
                bill_cart['buyers_id'] = ui.item.id;
            },
        });

        // id покупателя, если он есть
        $('.js_user_add', $bill_cart_form).click(function () {
            var $form = $('#modal_user_cart').find('form');
            $form.data('users-id', '');
            $form.attr('action','/admin/users/add/');
        });
        $('.js_user_edit', $bill_cart_form).click(function () {
            var $form = $('#modal_user_cart').find('form');
            $form.data('users-id', bill_cart['buyers_id']);
            $form.attr('action','/admin/users/edit/' + bill_cart['buyers_id'] + '/');
        });
    }
});

function save_bill_cart(addon, redirect) {
    $.ajax({
        url: "/admin/bill/save/",
        data: $('.js_bill_cart_form').serialize() + (addon ? '&' + addon : ''),
        success: function(ans) {
            if (redirect) {
                document.location = redirect;
                return;
            }
            bill_cart = ans;
            bill_cart_draw();
        },
    });
}

function bill_cart_draw() {
    $('.js_bill_cart').hide();

    if (!bill_cart['id']) return;
    if (bill_cart['status'] == 'closed') return;

    var $bill_cart_form = $('.js_bill_cart_form');

    $('.js_bill_number', $bill_cart_form).html(bill_cart['id']);
    $('input[name="bills_id"]', $bill_cart_form).val(bill_cart['id']);

    if (bill_cart['order'] && bill_cart['order']['file'])
        $('.js_requisites', $bill_cart_form).html('Реквизиты: <a href="/upload/orders/' + bill_cart['order']['file'] + '" target="_blank">' + bill_cart['order']['file'] + '</a>');
    $('.js_comments', $bill_cart_form).html(bill_cart['comments']);

    // Проставляем продукты
    if (bill_cart['products']) {
        var html = '';
        for (var i = 0; i < bill_cart['products'].length; i++) {
            html   += '<tr>'
                    + '<td><input type="hidden" name="products_id" value="' + bill_cart['products'][i]['products_id'] + '">' + bill_cart['products'][i]['name'] + '</td>'
                    + '<td><input type="text" name="qnt_' + bill_cart['products'][i]['products_id'] + '" value="' + bill_cart['products'][i]['quantity'] + '"></td>'
                    + '<td><a href="javascript: void(0)" onClick="$(this).closest(\'tr\').remove(); save_bill_cart();"><i class="icon-remove"></i></a></td>'
                    + '</tr>';
        }
        $('.js_bill_cart_products').html(html);
    }

    // Проставляем покупателя
    if (bill_cart['buyers_id'] > 0) {
        $('input[name="buyers_id"]', $bill_cart_form).val(bill_cart['buyer']['id']);
        $('input[name="buyer"]', $bill_cart_form).val(bill_cart['buyer']['type'] == 'ph' ? bill_cart['buyer']['fio'] : bill_cart['buyer']['firm']);
        $('.js_buyers_email', $bill_cart_form).html(bill_cart['buyer']['email']);
    }

    // Варианты экшенов для покупателя
    if ($('input[name="buyers_id"]', $bill_cart_form).val()) {
        $('.js_user_edit', $bill_cart_form).show();
    }
    $('input[name="buyers_id"]', $bill_cart_form).change(function () {
        if ($(this).val())
            $('.js_user_edit', $bill_cart_form).show();
        else
            $('.js_user_edit', $bill_cart_form).hide();
    });

    // Фиксируем карту, если она высокая
    if (bill_cart['products'].length * 45 + 400 < $(window).height()) {
        $bill_cart_form.addClass('affix');
    }
    else {
        $bill_cart_form.removeClass('affix');
    }

    for (var el in bill_cart) {
        $('.js_bill_cart').show();
        return;
    }
}
