<option value="0" [% 'selected' IF select == 0 %]>Корень</option>
[%-
    INCLUDE tree tree=tree select=select;
    BLOCK tree;
        SET tab = tab _ '&nbsp;&nbsp;&nbsp;';
        FOR c = tree;
-%]
<option value="[% c.id %]" [% 'selected' IF select == c.id %]>[% tab _ c.name %]</option>
[%-
        INCLUDE tree tree=c.childs select=select tab=tab;
        END;
    END;
-%]