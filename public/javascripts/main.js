var liveTex = true,
    liveTexID = 44682,
    liveTex_object = true;
(function() {
    var lt = document.createElement('script');
    lt.type ='text/javascript';
    lt.async = true;
    lt.src = 'http://cs15.livetex.ru/js/client.js';
    var sc = document.getElementsByTagName('script')[0];
    if ( sc ) sc.parentNode.insertBefore(lt, sc);
    else  document.documentElement.firstChild.appendChild(lt);
})();

$(document).ready(function(){
    if ($.cookie('_openstat')) {
        $('.js_phone').html('(499) 653-79-81');
        $('#js_contacts').attr('href', '/kontakty.html');
    }
    else {
        $('.js_phone').html('(495) 215-03-07');
    }
});

var browser = {};
$(document).ready(function() {
    // Browser detection patch
    browser = {};
    browser.mozilla = /mozilla/.test(navigator.userAgent.toLowerCase()) && !/webkit/.test(navigator.userAgent.toLowerCase());
    browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
    browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
    browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
    if (browser.msie) {
        regexp = /msie\s*(.*?);/;
        var m = regexp.exec(navigator.userAgent.toLowerCase());
        browser.version = m[1];
    }
});

$(document).ready(function() {
    // Placeholder for IE
    if(browser.msie && browser.version < 10) {
        $("form").find("input[type='text']").each(function() {
            if ($(this).attr("placeholder") && !$(this).val()) $(this).val($(this).attr("placeholder")).css('color','#ccc');
        }).focusin(function() {
            if ($(this).val() == $(this).attr('placeholder')) $(this).val('').css('color','#303030');
        }).focusout(function() {
            if ($(this).val() == "") $(this).val($(this).attr('placeholder')).css('color','#ccc');
        });

        $("form").find("textarea").each(function() {
            if ($(this).attr("placeholder") && !$(this).text()) $(this).text($(this).attr("placeholder")).css('color','#ccc');
        }).focusin(function() {
            if ($(this).text() == $(this).attr('placeholder')) $(this).text('').css('color','#303030');
        }).focusout(function() {
            if ($(this).text() == "") $(this).text($(this).attr('placeholder')).css('color','#ccc');
        });

        // Protected send form
        $("form").submit(function() {
            $(this).find("input[type='text']").each(function() {
                if ($(this).val() == $(this).attr('placeholder')) $(this).val('');
            });
            $(this).find("textarea").each(function() {
                if ($(this).text() == $(this).attr('placeholder')) $(this).text('');
            });
        });
    }
});

$(document).ready(function(){
    var basket_state = 0;

    $('#js_basket').find('.toggle').click(function(){
        basket_state = basket_toggle(basket_state);
    });

    $('.js_buy_button').click(function(){
        var id = $(this).data('product');
        $.ajax({
            type: "POST",
            url: "/shopping_cart/add/" + id + "/",
            success: function(ans) {
                basket_state = basket_toggle(0);
            }
        });
    });

    // --------- search ----------
    $("#js_search").autocomplete({
        position: {
            my: "right top",
            at: "right bottom",
        },
        source: function(request, response){
            // организуем кроссдоменный запрос
            $.ajax({
                url: "/search/",
                dataType: "json",
                // параметры запроса, передаваемые на сервер (последний - подстрока для поиска):
                data:{
                    featureClass: "P",
                    style: "full",
                    maxRows: 20,
                    name_startsWith: request.term
                },
                // обработка успешного выполнения запроса
                success: function(data){
                    // приведем полученные данные к необходимому формату и передадим в предоставленную функцию response
                    response(
                        $.map(data, function(item){
                            return{
                                label: item.name,
                                value: item.name,
                                id: item.id,
                            }
                        })
                    );
                }
            });
        },
        minLength: 3,
        select: function( event, ui ) {
            document.location.href = '/products/' + ui.item.id + '/';
        },
    });

    // --------- shopping_cart --------
    if ($('#js_shopping_cart')) {
        $('.js_minus').on('click', function(){
            var el = $(this).data('minus');
            var val = parseInt($('#' + el).val()) - 1;
            $('#' + el).val(val > 0 ? val : 1);
            cart_refresh();
        });
        $('.js_plus').on('click', function(){
            var el = $(this).data('plus');
            var val = parseInt($('#' + el).val()) + 1;
            $('#' + el).val(val);
            cart_refresh();
        });
        $('.js_qnt').on('change', function(){
            cart_refresh();
        });
        $('.js_del').on('click', function(){
            $(this).closest('tr').remove();
            cart_refresh();
        });

        delivery_refresh();
        $('.js_shipping, #js_mkad_length').on('click keyup', function(){ delivery_refresh(); });

        payment_refresh();
        $('.js_payment').on('click', function(){ payment_refresh(); });
    }
});

function delivery_refresh() {
    if (!$('#js_shopping_cart')) return;

    $('.js_delivery_mkad').hide();
    $('#js_delivery_mkad_price').hide();

    $('.js_shipping').each(function() {
        if ($(this).is(':checked')) {
            var delivery_price = $(this).data('delivery_price') * 1;
            var delivery_mkad_price = $(this).data('delivery_mkad_price') * 1;

            if (delivery_price) {
                if (delivery_mkad_price) {
                    var km = $('#js_mkad_length').val();
                    delivery_price = km ? delivery_price + delivery_mkad_price * km : delivery_price;
                    $('.js_delivery_mkad').show();
                    $('#js_delivery_mkad_price').show();
                    $('#js_delivery_mkad_price').text(', ' + delivery_price + ' руб.');
                }

                var total = $('#js_shopping_cart_total').html() * 1;
                var $total_with_delivery_div = $('#js_total_with_delivery');
                $total_with_delivery_div.hide();
                if (total) {
                    if (total < GLOB_delivery_min_sum) {
                        $('.js_shipping_with_delivery').hide();
                        return;
                    }
                    else {
                        $('.js_shipping_with_delivery').show();
                    }

                    var price = total + delivery_price;
                    $total_with_delivery_div.find('strong').text(price + ' руб.');
                    $total_with_delivery_div.show();
                }
            }
        }
    });
}

function payment_refresh() {
    if (!$('#js_shopping_cart')) return;

    var $file = $('#js_shopping_cart_cashless_file');

    $file.hide();
    $('.js_payment').each(function() {
        if ($(this).val() == 'cashless' && $(this).is(':checked')) {
            $file.show();
        }
    });
}

function cart_refresh() {
    var $form = $('#js_shopping_cart');
    if (!$form) return;

    $.ajax({
        url: '/shopping_cart/recalc/',
        data: $form.serialize(),
        success: function(ans) {
            if (ans.length) {
                var sum = 0;
                for (var i = 0; i < ans.length; i++) {
                    sum += ans[i]['qnt'] * ans[i]['price'];
                }
                $('#js_shopping_cart_total').html(sum);

                delivery_refresh();
            }
            else {
                $('#js_shopping_cart_empty').show();
                $form.hide();
            }
        }
    });
    return false;
}

function basket_toggle(state) {
    if (state) {
        state = 0;
        $('#js_basket').removeClass('open');
    }
    else {
        var cart = $.parseJSON($.cookie('cart'));
        if (cart) {
            var qnt = 0;
            var sum = 0;
            for (var i = 0; i < cart.length; i++) {
                qnt += parseInt(cart[i]['qnt']);
                sum += cart[i]['qnt'] * cart[i]['price'];
            }
            if (qnt) {
                $('#js_basket_qnt').text(qnt);
                $('#js_basket_sum').text(sum);
                $('#js_basket_empty').hide();
                $('#js_basket_full').show();
            }
        }

        state = 1;
        $('#js_basket').addClass('open');
    }

    return state;
}
