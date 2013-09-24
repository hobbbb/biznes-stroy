package Admin::SPE::top_menu;

use Dancer ':syntax';

my $settings = {
    alias       => 'top_menu',
    sortable    => 1,
    title       => 'Верхнее меню',
    fields      => [
        {
            name        => 'name',
            type        => 'text',
            descr       => 'Название',
            in_list     => 1,
            error       => sub { length($_[0]) < 3 },
        },
        {
            name        => 'url',
            type        => 'text',
            descr       => 'Ссылка',
            in_list     => 1,
            error       => sub { $_[0] !~ m!^/! },
        },
        {
            name        => 'alias',
            type        => 'text',
            descr       => 'Алиас',
            in_list     => 1,
            readonly    => 1,
        },
    ],
};

any '/'            => sub { return SCM::SPE::main($settings, \%{params()}); };
any '/edit/:id/'   => sub { return SCM::SPE::edit($settings, \%{params()}); };
any '/del/:id/'    => sub { return SCM::SPE::del($settings, \%{params()}); };
any '/rearrange/'  => sub { return SCM::SPE::rearrange($settings, \%{params()}); };

true;
