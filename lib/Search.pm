package Search;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Sphinx::Search;
use func;

sub products {
    my ($search_word, $where, $opts) = @_;
    $where = {} unless ref $where eq 'HASH';
    $opts = {} unless ref $opts eq 'HASH';

    my $sph = Sphinx::Search->new();

    my $timeout = 5;
    $sph->SetConnectTimeout( $timeout );
    $sph->SetMaxQueryTime( $timeout * 1000 ); # in miliseconds
    $sph->SetMatchMode( SPH_MATCH_EXTENDED2 );
    $sph->SetFieldWeights( { name => 1500, short_descr => 1000, descr => 500 } );
    $sph->SetRankingMode( SPH_RANK_SPH04 );
    $sph->SetSortMode( SPH_SORT_EXTENDED, q{@weight desc} );
    $sph->SetLimits(0, 1000, 1000);

    my $query = $sph->EscapeString( $search_word );
    my $search_result = $sph->Query( "\@(name,short_descr,descr) $query*", 'bstroy_products' );

    if ( !$search_result->{error} ) {
        my @ids = ();
        for (@{$search_result->{'matches'}}) {
            push @ids, $_->{doc};
        }

        if (scalar @ids) {
            $where->{enabled} = 1;
            $where->{id} = \@ids;
            return [ database->quick_select('products', $where, $opts) ];
        }
    }
    else {
        warning "Query ERROR: |$query| '$search_result->{error}'";
    }

    return [];
}

true;
