package SCM::utils;

our @ISA = qw(Exporter);
our @EXPORT = qw(w trim escape_html);

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

sub escape_html {
    my $str = shift;

    $str =~ s/"/&quot;/;
    $str =~ s/'/&apos;/;
    $str =~ s/>/&gt;/;
    $str =~ s/</&lt;/;
    $str =~ s/&/&amp;/;

    return $str;
}

1;
