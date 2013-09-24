package Admin::SPE::discount_program;

use Dancer ':syntax';

my $settings = {
    alias       => 'discount_program',
    sortable    => 1,
    title       => 'Дисконтная программа',
    fields      => [
        {
            name    => 'min_price',
            type    => 'text',
            descr   => 'Минимальная цена',
            in_list => 1,
            error   => sub { $_[0] and $_[0] !~ /^\d+$/ },
        },
        {
            name    => 'max_price',
            type    => 'text',
            descr   => 'Максимальная цена',
            in_list => 1,
            error   => sub { $_[0] and $_[0] !~ /^\d+$/ },
        },
        {
            name    => 'percent',
            type    => 'text',
            descr   => 'Процент',
            in_list => 1,
            error   => sub { $_[0] !~ /^\d+(\.\d+)?$/ },
        },
    ],
};

any '/'            => sub { return SCM::SPE::main($settings, \%{params()}); };
any '/edit/:id/'   => sub { return SCM::SPE::edit($settings, \%{params()}); };
any '/del/:id/'    => sub { return SCM::SPE::del($settings, \%{params()}); };
any '/rearrange/'  => sub { return SCM::SPE::rearrange($settings, \%{params()}); };

true;
