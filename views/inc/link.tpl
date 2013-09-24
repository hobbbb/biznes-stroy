[%-
    IF alias == 'products';
        SET url = 'products/' _ item.id _ '/';
    ELSIF alias == 'categories';
        SET url = 'categories/' _ item.id _ '/';
    ELSIF alias == 'manufacturers';
        SET url = 'manufacturers/' _ item.id _ '/';
    END;
    '/' _ (item.seo_url || url);
-%]