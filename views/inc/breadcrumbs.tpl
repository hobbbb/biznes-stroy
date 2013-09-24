<div class="path">
    <a href="/">Главная</a>
    [%- FOR c IN crumbs;
        link = INCLUDE inc/link.tpl alias = alias item = c.item;
        SET url = c.url OR link;

        ' / ';
        '<a href="' _ url _ '">' IF url AND !loop.last;
            c.name;
        '</a>' IF url AND !loop.last;
    END; -%]
</div>
<!-- end .path-->
