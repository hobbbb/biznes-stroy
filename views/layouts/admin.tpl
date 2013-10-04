<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Админка</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link rel="stylesheet" href="/css/bootstrap.css">
    <link rel="stylesheet" href="/css/smoothness/jquery-ui.css?v=2013_05_22_23_50" />
    <link rel="stylesheet" href="/css/admin.css?v=2013_09_17_10_00">

    <script type="text/javascript" src="/javascripts/jquery.js?v=2013_08_30_13_20"></script>
    <script type="text/javascript" src="/javascripts/jquery-migrate-1.2.1.js"></script>
    <script type="text/javascript" src="/javascripts/jquery-ui.js?v=2013_05_22_23_50"></script>
    <script type="text/javascript" src="/javascripts/bootstrap.js"></script>
    <script type="text/javascript" src="/javascripts/admin.js?v=2013_10_04_11_00"></script>
    <script type="text/javascript" src="/ckeditor/ckeditor.js"></script>

    <link rel="shortcut icon" href="[% request.uri_base %]/favicon.ico">
</head>

<body>
    <div class="navbar navbar-inverse navbar-fixed-top">
        <div class="navbar-inner">
        <div class="container-fluid">
            <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="brand" href="/">Магазин</a>
            <div class="nav-collapse collapse">
                <ul class="nav">
                    [% IF vars.loged.acs.manager %]
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Заказы <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="/admin/orders/new/">Поступившие</a></li>
                                <li><a href="/admin/orders/process/">В обработке</a></li>
                                <li><a href="/admin/orders/done/">Завершенные</a></li>
                                <li><a href="/admin/orders/cancel/">Отмененные</a></li>
                                [% IF vars.loged.acs.admin %]
                                    <li><a href="/admin/orders/month/">За последний месяц</a></li>
                                    <li><a href="/admin/orders/">Все</a></li>
                                [% END %]
                            </ul>
                        </li>
                    [% END %]
                    [% IF vars.loged.acs.content %]
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Каталог <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="/admin/catalog/">Категории / Товары</a></li>
                                [% IF vars.loged.acs.admin %]
                                    <li><a href="/admin/manufacturers/">Производители</a></li>
                                    <li><a href="/admin/products/all/">Все товары</a></li>
                                    <li><a href="/admin/price/">Загрузка прайса</a></li>
                                [% END %]
                            </ul>
                        </li>
                    [% END %]
                    [% IF vars.loged.acs.admin %]
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Разное <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="/admin/content/">Информационные страницы</a></li>
                                <li><a href="/admin/footer_content/">Информационные страницы для футера</a></li>
                                <li><a href="/admin/biznes_stroy/">Бизнес-строй это</a></li>
                                <li><a href="/admin/users/">Пользователи</a></li>
                                <li><a href="/admin/backup/">Backup / Restore</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Управление <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="/admin/glob_vars/">Настройки</a></li>
                                <!--li><a href="/admin/glob_vars/?type=seller">Реквизиты продавца</a></li-->
                                <li><a href="/admin/top_menu/">Верхнее меню</a></li>
                                <li><a href="/admin/banners/">Баннеры</a></li>
                                <li><a href="/admin/discount_program/">Дисконтная программа</a></li>
                            </ul>
                        </li>
                    [% END %]
                    [% IF vars.loged.acs.manager %]
                        <li>
                            <a href="/admin/bills/">Счета <b class="caret"></b></a>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Помощь <b class="caret"></b></a>
                            <ul class="dropdown-menu">
                                <li><a href="/admin/help/help_for_manager/">Менеджеру <b class="caret"></b></a></li>
                                [% IF vars.loged.acs.admin %]
                                    <li><a href="/admin/help/help_for_admin/">Админу <b class="caret"></b></a></li>
                                [% END %]
                            </ul>
                        </li>
                    [% END %]
                </ul>
                <form class="navbar-search pull-right" action="/admin/search/">
                    <input type="text" class="input-medium search-query" name="search_word" value="[% search_word | html %]" placeholder="Товар">
                    <button type="submit" class="btn-inverse">Поиск</button>
                </form>
            </div><!--/.nav-collapse -->
        </div>
        </div>
    </div>

    <div class="container-fluid">
        [% content %]
    </div>

</body>
</html>
