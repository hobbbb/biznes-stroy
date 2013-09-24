package Admin::SPE::manufacturers;

use Dancer ':syntax';

my $settings = {
    alias   => 'manufacturers',
    upload  => 1,
    title   => 'Производители',
    fields  => [
        {
            name    => 'name',
            type    => 'text',
            descr   => 'Название',
            in_list => 1,
            error   => sub { length($_[0]) < 3 },
        },
        {
            name    => 'image',
            type    => 'file',
            descr   => 'Картинка',
            error   => sub { $_[0] and lc($_[0]) !~ /(jpg|jpeg|png)$/ },
        },
    ],
};

any '/'            => sub { return SCM::SPE::main($settings, \%{params()}); };
any '/edit/:id/'   => sub { return SCM::SPE::edit($settings, \%{params()}); };
any '/del/:id/'    => sub { return SCM::SPE::del($settings, \%{params()}); };
any '/rearrange/'  => sub { return SCM::SPE::rearrange($settings, \%{params()}); };

true;
