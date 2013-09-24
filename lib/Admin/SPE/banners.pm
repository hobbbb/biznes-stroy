package Admin::SPE::banners;

use Dancer ':syntax';

my $settings = {
    alias       => 'banners',
    upload      => 1,
    sortable    => 1,
    title       => 'Баннеры',
    fields      => [
        {
            name    => 'image',
            type    => 'file',
            descr   => 'Картинка',
            error   => sub {
                my ($val, $http_params, $item) = @_;
                return 1 if ($val and lc($val) !~ /(jpg|jpeg|png)$/) or (!$val and (!$item or $http_params->{del_image}));
            },
        },
        {
            name    => 'descr',
            type    => 'editor',
            descr   => 'Описание',
        },
        {
            name    => 'url',
            type    => 'text',
            descr   => 'Ссылка',
            in_list => 1,
            error   => sub { $_[0] and $_[0] !~ m!^/! },
        },
    ],
};

any '/'            => sub { return SCM::SPE::main($settings, \%{params()}); };
any '/edit/:id/'   => sub { return SCM::SPE::edit($settings, \%{params()}); };
any '/del/:id/'    => sub { return SCM::SPE::del($settings, \%{params()}); };
any '/rearrange/'  => sub { return SCM::SPE::rearrange($settings, \%{params()}); };

true;
