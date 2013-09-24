[%-
    IF crumbs;
        INCLUDE inc/breadcrumbs.tpl crumbs = crumbs;
    END;

    IF filters AND (products.size OR filt);
        INCLUDE inc/products_filters.tpl;
    END;

    IF title;
        '<h1>' _ title _ '</h1>';
    END;
-%]

[% content %]
