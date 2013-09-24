[%-
    SET params = '?' _ (uri_params ? uri_params _ '&' : '');
    IF filt;
        SET params = params _ 'filt=' _ filt _ '&';
    END;
    IF sort;
        SET params = params _ 'sort=' _ sort _ '&';
        SET params = params _ 'direction=' _ direction.$sort;
    END;
    params;
-%]
