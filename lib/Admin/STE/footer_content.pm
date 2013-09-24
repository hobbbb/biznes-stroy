package Admin::STE::footer_content;

use Dancer ':syntax';
use func;

sub _check_item {
    my ($params, $item) = @_;
    my ($form, $err) = ({},{});

    for (qw/parent_id name descr/) {
        $form->{$_} = $params->{$_};
    }
    $form->{name} = func::trim($form->{name});

    $err->{parent_id} = 1 if $form->{parent_id} !~ /^\d+$/;
    $err->{name}      = 1 if length($form->{name}) < 3;
    $err->{descr}     = 1 unless length($form->{descr});

    return ($form, $err);
}

my $settings = {
    ENTITY      => setting('ENTITY'),
    TABLE       => setting('TABLE') || setting('ENTITY'),
    TPL         => setting('TPL') || 'admin/' . setting('ENTITY') . '.tpl',
    SCRIPT      => setting('SCRIPT') || '/admin/' . setting('ENTITY') . '/',
    UPLOAD_DIR  => setting('UPLOAD_DIR'),
    MAX_LEVEL   => setting('MAX_LEVEL') || 1,
};

any qr{/((\d+)?/)?} => sub { return SCM::STE::tree($settings, (splat)[1] || 0, \%{params()}); };
any '/edit/:id/'    => sub { return SCM::STE::edit($settings, \%{params()}); };
any '/del/:id/'     => sub { return SCM::STE::del($settings, \%{params()}); };
any '/rearrange/'   => sub { return SCM::STE::rearrange($settings, \%{params()}); };

true;
