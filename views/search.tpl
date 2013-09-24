[%-
WRAPPER inc/wrap.tpl
    title = 'Поиск: ' _ search_word
    crumbs = [ { 'name' => 'Поиск: ' _ search_word } ]
    filters = 1 uri_params='search_word=' _ search_word;
        IF products.size;
            INCLUDE inc/products_list.tpl list=products uri_params='search_word=' _ search_word;
        ELSE;
            'Ничего не найдено';
        END;
END;
-%]
