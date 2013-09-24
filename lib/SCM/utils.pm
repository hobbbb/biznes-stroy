package SCM::utils;

our @ISA = qw(Exporter);
our @EXPORT = qw(&w &trim);

use Data::Dumper;

sub w {
    my $p = shift;

    die Dumper $p;
}

sub trim {
    my $str = shift;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    return $str;
}

1;
