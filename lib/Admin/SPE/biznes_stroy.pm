package Admin::SPE::biznes_stroy;

use Dancer ':syntax';

my $settings = {
    alias   => 'biznes_stroy',
    upload  => 1,
    title   => 'Бизнес-строй это',
    fields  => [
        {
            name    => 'image',
            type    => 'file',
            descr   => 'Картинка',
            in_list => 1,
            error   => sub {
                my ($val, $http_params, $item) = @_;
                return 1 if ($val and lc($val) !~ /(jpg|jpeg|png)$/) or (!$val and (!$item or $http_params->{del_image}));
            },
        },
        {
            name    => 'descr',
            type    => 'editor',
            descr   => 'Описание',
            error   => sub { !length($_[0]) },
        },
    ],
};

any '/'            => sub { return SCM::SPE::main($settings, \%{params()}); };
any '/edit/:id/'   => sub { return SCM::SPE::edit($settings, \%{params()}); };
any '/del/:id/'    => sub { return SCM::SPE::del($settings, \%{params()}); };
any '/rearrange/'  => sub { return SCM::SPE::rearrange($settings, \%{params()}); };

true;
