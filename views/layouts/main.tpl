<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=[% settings.charset %]" />
    <title>[% seo_title || 'biznes-stroy.ru' %]</title>
    <meta name="description" content="[% seo_description || 'biznes-stroy.ru' %]" />
    <meta name="keywords" content="[% seo_keywords || 'biznes-stroy.ru' %]" />

    <link rel="stylesheet" type="text/css" href="/css/base.css" />
    <link rel="stylesheet" type="text/css" href="/css/style.css?v=2013_09_20_12_00" />
    <link rel="stylesheet" type="text/css" href="/css/smoothness/jquery-ui.css?v=2013_09_13_17_50" />

    <script type="text/javascript" src="/javascripts/jquery.js?v=2013_08_30_13_20"></script>
    <script type="text/javascript" src="/javascripts/jquery.cookie.js"></script>
    <script type="text/javascript" src="/javascripts/jquery.countdown.js"></script>
    <script type="text/javascript" src="/javascripts/jquery-migrate-1.2.1.js"></script>
    <script type="text/javascript" src="/javascripts/jquery-ui.js?v=2013_05_22_23_50"></script>
    <script type="text/javascript" src="/javascripts/jinit.js?v=2013_08_30_14_00"></script>
    <script type="text/javascript" src="/javascripts/main.js?v=2013_09_28_09_00"></script>

    <!--[if lte IE 7]><link href="/css/ie7.css" rel="stylesheet" type="text/css" /><![endif]-->
    <!--[if lte IE 8]>
    <script type="text/javascript" src="/javascripts/PIE.js"></script>
    <script type="text/javascript" src="/javascripts/html5support.js"></script>
    <![endif]-->
    <script>[%- FOR k IN vars.glob_vars -%]var GLOB_[% k.key %] = '[% vars.glob_vars.${k.key} %]';[%- END -%]</script>
</head>

<body>
    <div class="wrapper">
        <div class="cart-aside" id="js_basket">
            <div class="toggle"></div>
            <div class="in">
                <div class="dnone" id="js_basket_full">
                    <p>В вашей корзине <strong id="js_basket_qnt"></strong> товар(ов)<br />на сумму <strong id="js_basket_sum"></strong> руб.</p>
                    <a class="btn-orange grey" href="/shopping_cart/">Оформить заказ</a>
                </div>
                <div id="js_basket_empty">Нет заказов</div>
            </div>
            <!-- end .in-->
        </div>
        <!-- end .cart-aside-->

        <div class="head-block">
            <div class="menu1">
                <table>
                    <tr>
                        [% FOR m IN top_menu %]
                            <td class="sep">&nbsp;</td><td><a href="[% m.url %]" id="[% m.alias %]">[% m.name %]</a></td>
                        [% END %]
                        <td class="sep">&nbsp;</td>
                        <td style="text-align: center;">
                            [% IF vars.loged.id %]
                                Здравствуйте, [% vars.loged.fio %]<br>
                                <a class="auth-link" href="/auth/lk/"><span>Мои данные</span></a> |
                                <a href="/auth/logout/"><span>Выход</span></a>
                                [% IF vars.loged.acs.keys %]
                                    | <a href="/admin/"><span>Админка</span></a>
                                [% END %]
                            [% ELSE %]
                                <a class="auth-link" href="/auth/"><span>Вход в личный кабинет</span></a>
                            [% END %]
                        </td>
                    </tr>
                </table>
            </div>
            <!-- end .menu1-->

            <div class="head-bg">
                <div class="logo2"><a href="/"><img src="/images/logo.png" width="208" height="161" alt="Бизнес-Строй" /></a></div>
                <!-- end .logo2-->
                <div class="phone2">
                    <span class="js_phone"></span>
                    <div class="workhours"> Прием звонков: <p>9:00 - 18:00<br />9:00 - 17:00</p></div>
                    <!-- end .workhours-->
                </div>
                <!-- end .phone2-->
            </div>
            <!-- end .head-bg-->

            <div class="main-menu">
                <form class="search2" action="/search/" method="get">
                    <fieldset>
                        <input type="text" id="js_search" name="search_word" value="Поиск инструмента" onfocus="this.value==this.defaultValue?this.value='':''" onblur="this.value==''?this.value=this.defaultValue:''" />
                        <input value="" type="submit" />
                    </fieldset>
                </form>
                <!-- end .search2-->

                [% INCLUDE tree tree = categories_tree first = 1 %]

                <div class="wrap">
                    <div class="holder">
                        <a class="link bg-orange" href="/categories/sale/"><span class="c"><span class="cell">
                            <!--[if lte IE 7]><span><span><![endif]-->РАСПРОДАЖА<!--[if lte IE 7]></span></span><![endif]-->
                        </span></span></a>
                    </div>
                </div>
                <span class="corner2 tl"></span> <span class="corner2 tr"></span> <span class="corner2 bl"></span> <span class="corner2 br"></span>
            </div>
            <!-- end .main-menu-->

            [% IF request.path == '/' AND banners_list.size %]
                <div class="offer">
                    <h3>[% product_of_day.stock_till ? 'Акция' : 'Товар дня' %]</h3>
                    <div class="bg">
                        <div class="photo"><a href="[% INCLUDE inc/link.tpl alias='products' item=product_of_day %]">
                            [% IF product_of_day.image %]
                                <span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                                    <img src="/resize/180/products/[% product_of_day.image %]/" alt=" " />
                                <!--[if lte IE 7]></span></span><![endif]--></span>
                            [% END %]
                            <span class="text">
                                [% IF product_of_day.stock_till %]
                                    <span class="discount"><strong>-[% product_of_day.stock_discount %]</strong>%</span>
                                [% END %]
                            </span>
                            <!-- end .text-->
                        </a></div>
                        <!-- end .photo-->
                        <div>
                            [% IF product_of_day.stock_till %]
                                <del><span>[% product_of_day.price %] руб.</span></del>
                            [% END %]
                            <strong class="price1">[% product_of_day.stock_till ? product_of_day.stock_price : product_of_day.price %] руб.</strong>
                        </div>
                        [% IF product_of_day.stock_till %]
                            <span class="timer" id="js_product_of_day_timer"></span>
                            <script>
                                [% SET matches = product_of_day.stock_till.match('^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2})') %]
                                var d = new Date([% matches.0 %],[% matches.1 - 1 %],[% matches.2 %],[% matches.3 %],[% matches.4 %],[% matches.5 %]);
                                $("#js_product_of_day_timer").countdown(d, {prefix:'', finish: 'Закончилось!'});
                            </script>
                        [% END %]
                    </div>
                    <span class="corner tl"></span> <span class="corner tr"></span> <span class="corner bl"></span> <span class="corner br"></span>
                </div>
                <!-- end .offer-->

                <div class="img-rotation">
                    [% FOR b IN banners_list %]
                        <div class="inner">
                            <img src="/upload/banners/[% b.image %]/" width="911" height="329" alt="" />
                            <div class="text">
                                [% b.descr %]
                                [% IF b.url %]
                                    <a class="more-link" href="[% b.url %]">Подробнее</a>
                                [% END %]
                            </div>
                            <!-- end .text-->
                        </div>
                        <!-- end .inner-->
                    [% END %]
                    <div class="nav">
                        <div class="pause"></div>
                        <ul>
                        [% FOR b IN banners_list %]
                            <li>&nbsp;</li>
                        [% END %]
                        </ul>
                    </div>
                  <!-- end .nav-->
                  <span class="corner tl"></span> <span class="corner tr"></span> <span class="corner bl"></span> <span class="corner br"></span>
                </div>
                <!-- end .img-rotation-->
            [% END %]
        </div>
        <!-- end .head-block-->

        <div class="content-block">

            [% content %]

            [% '<div class="hr"></div>' IF request.path != '/' %]

            <div class="clearfix">
                <div class="third-block2">
                    <div class="nav-links">
                    [% FOR i = footer_content_list %]
                        <div class="fl">
                            <h3>[% i.name %]</h3>
                            <ul>
                            [% FOR c = i.childs %]
                                <li><a href="/footer_content/[% c.id %]/">[% c.name %]</a></li>
                            [% END %]
                            </ul>
                        </div>
                    [% END %]
                    </div>
                    <!-- end .nav-links-->
                </div>
                <!-- end .third-block2-->
                <div class="third-block">
                    <h3>Контакты</h3>
                    <div class="phone2 js_phone"></div>
                    <!-- end .phone2-->
                    <a class="consultant-link" href="#"><span>Online - консультант</span></a>
                </div>
                <!-- end .third-block-->
            </div>
        </div>
        <!-- end .content-block-->
        <div class="footer-place"></div>
    </div>

    <!-- end .wrapper-->
    <div class="wrapper footer-block">
        <div class="content-block">
            <div class="logo-place"><a href="#"><img src="/images/logo-bot.png" width="200" height="60" alt="Бизнес-Строй" /></a></div>
            <!-- end .logo-place-->
            2008-2013 Бизнес-строй. Все права защищены.
        </div>
        <!-- end .content-block-->
    </div>
    <!-- end .footer-block-->
</body>

    <!--LiveInternet counter--><script type="text/javascript"><!--
    new Image().src = "//counter.yadro.ru/hit?r"+
    escape(document.referrer)+((typeof(screen)=="undefined")?"":
    ";s"+screen.width+"*"+screen.height+"*"+(screen.colorDepth?
    screen.colorDepth:screen.pixelDepth))+";u"+escape(document.URL)+
    ";"+Math.random();//--></script><!--/LiveInternet-->

    <!-- Yandex.Metrika counter -->
    <script type="text/javascript">
    (function (d, w, c) {
        (w[c] = w[c] || []).push(function() {
            try {
                w.yaCounter12609058 = new Ya.Metrika({id:12609058,
                        webvisor:true,
                        clickmap:true,
                        trackLinks:true,
                        accurateTrackBounce:true});
            } catch(e) { }
        });

        var n = d.getElementsByTagName("script")[0],
            s = d.createElement("script"),
            f = function () { n.parentNode.insertBefore(s, n); };
        s.type = "text/javascript";
        s.async = true;
        s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js";

        if (w.opera == "[object Opera]") {
            d.addEventListener("DOMContentLoaded", f, false);
        } else { f(); }
    })(document, window, "yandex_metrika_callbacks");
    </script>
    <noscript><div><img src="//mc.yandex.ru/watch/12609058" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
    <!-- /Yandex.Metrika counter -->
</html>


[%
    BLOCK tree;
    FOR c = tree;
    NEXT IF loop.count > 9 AND !c.parent_id;
%]
    [% UNLESS c.parent_id %]
        <div class="wrap [% 'first' IF first == 1 AND loop.first %]">
        <div class="holder">
            <a class="link" href="[% INCLUDE inc/link.tpl alias='categories' item=c %]">
                <span class="c"><span class="cell"><!--[if lte IE 7]><span><span><![endif]-->
                    [% c.name.replace('\s+', '<br>') %]
                <!--[if lte IE 7]></span></span><![endif]--></span></span>
            </a>
    [% END %]

    [% IF c.parent_id %]
        [% '<ul>' IF loop.first %]
            <li><a [% 'class="with-sub"' IF c.childs.size %] href="[% INCLUDE inc/link.tpl alias='categories' item=c %]">[% c.name %]</a>
    [% END %]

    [% IF c.childs.size(); INCLUDE tree tree=c.childs first = 0; END; %]

    [% IF c.parent_id %]
            </li>
        [% '</ul>' IF loop.last %]
    [% END %]

    [% UNLESS c.parent_id %]
        </div>
        </div>
    [% END %]
[%
    END;
    END;
%]
