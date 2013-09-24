[%-
    SET discount = 0;

    FOR r IN discount_program;
        IF r.min_price AND !r.max_price;
            IF summary_buy >= r.min_price;
                SET discount = r.percent;
                LAST;
            END;
        ELSIF !r.min_price AND r.max_price;
            IF summary_buy <= r.max_price;
                SET discount = r.percent;
                LAST;
            END;
        ELSIF r.min_price AND r.max_price;
            IF summary_buy >= r.min_price AND summary_buy <= r.max_price;
                SET discount = r.percent;
                LAST;
            END;
        END;
    END;

    discount;
-%]