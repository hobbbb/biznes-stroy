#!/usr/bin/env perl
use Dancer ':script';
use FindBin '$RealBin';
use Dancer::Plugin::Database;
use XML::Simple;
use lib '../lib';
use func;

my $appdir = path($RealBin, '..');
Dancer::Config::setting('appdir',$appdir);

config->{environment} = 'production';
config->{confdir} = $appdir;
config->{envdir}  = "$appdir/environments";
config->{public}  = "$appdir/public";
config->{views}   = "$appdir/views";
Dancer::Config::load();

package MyXMLSimple;
use base 'XML::Simple';
use Data::Dumper;

sub sorted_keys {
   my ($self, $name, $hashref) = @_;

    my @ret;
    if ($name eq 'shop') {
        # return qw/name company url categories offers/;
        my @fields = qw/name company url phone platform version agency email currencies categories store pickup
            delivery deliveryIncluded local_delivery_cost adult offers/;

        for (@fields) {
            push @ret, $_ if exists $hashref->{$_};
        }
        return @ret;
=c DTD
<!ELEMENT shop (name, company, url, phone?, platform?, version?, agency?, email*, currencies, categories, store?, pickup?,
    delivery?, deliveryIncluded?, local_delivery_cost?, adult?, offers)>
=cut
    }

    if ($name eq 'offer') {
        my @fields = qw/id group_id type available bid cbid
            url buyurl price wprice currencyId xCategory categoryId market_category
            picture store pickup delivery deliveryIncluded local_delivery_cost orderingTime

            typePrefix vendor vendorCode model provider tarifplan

            aliases additional description sales_notes promo
            manufacturer_warranty country_of_origin downloadable adult
            age
            barcode
            param
            related_offer/;

        for (@fields) {
            push @ret, $_ if exists $hashref->{$_};
        }
        return @ret;

=c DTD
<!ATTLIST offer
    id CDATA #IMPLIED
    group_id CDATA #IMPLIED
    type (vendor.model | book | audiobook | artist.title | tour | ticket | event-ticket) #IMPLIED
    available (true | false) #IMPLIED
    bid CDATA #IMPLIED
    cbid CDATA #IMPLIED>

<!ELEMENT offer (url?, buyurl?, price, wprice?, currencyId, xCategory?, categoryId+, market_category?,
     picture*, store?, pickup?, delivery?, deliveryIncluded?, local_delivery_cost?, orderingTime?,
     ((typePrefix?, vendor, vendorCode?, model, (provider, tarifplan?)?) |
      (author?, name, publisher?, series?, year?, ISBN?, volume?, part?, language?, binding?, page_extent?, table_of_contents?) |
      (author?, name, publisher?, series?, year?, ISBN?, volume?, part?, language?, table_of_contents?, performed_by?, performance_type?, storage?, format?, recording_length?) |
      (artist?, title, year?, media?, starring?, director?, originalName?, country?) |
      (worldRegion?, country?, region?, days, dataTour*, name, hotel_stars?, room?, meal?, included, transport, price_min?, price_max?, options?) |
      (name, place, hall?, hall_part?, date, is_premiere?, is_kids?) |
      (name, vendor?, vendorCode?)
     ),
     aliases?, additional*, description?, sales_notes?, promo?,
     manufacturer_warranty?, country_of_origin?, downloadable?, adult?,
     age?,
     barcode*,
     param*,
     related_offer*
    )
=cut
    }

    return $self->SUPER::sorted_keys($name, $hashref);
}



package main;

my $export = config->{public} . "/YML.xml";

unlink $export if -f $export;

my @t = localtime(time);
$t[5] += 1900;
$t[4] += 1;

# Common
my $glob_vars = { map { $_->{name} => func::escape_html($_->{val}) } @{[ database->quick_select('glob_vars', {}) ]} };
$glob_vars->{'shop.url'}  = 'http://' . $glob_vars->{'shop.url'} if $glob_vars->{'shop.url'} !~ /^http/;

unless ($glob_vars->{'shop.name'} and $glob_vars->{'shop.url'} and $glob_vars->{'shop.company'}) {
    die 'YML ERROR: wrong cfg';
}

# Products
my @prod = ();
my %_cat = ();

my $products = [ database->quick_select('products', { enabled => 1, yandex_market => 1 }, { order_by => 'sort' }) ];
func::products_get_image($products);

for my $p (@$products) {
    next unless $p->{manufacturers_id};

    my $manufacturer = database->quick_select('manufacturers', { id => $p->{manufacturers_id} });
    my $_p = {
        id                      => $p->{id},
        type                    => 'vendor.model',
        available               => 'true',
        url                     => { content => $glob_vars->{'shop.url'} . ($p->{seo_url} || "/products/$p->{id}/") },
        price                   => { content => $p->{price} },
        currencyId              => { content => 'RUR' },
        categoryId              => { content => $p->{categories_id} },
        pickup                  => { content => 'true' },
        vendor                  => { content => func::escape_html($manufacturer->{name}) },
        model                   => { content => func::escape_html($p->{name}) },
        description             => { content => func::escape_html($p->{short_descr}) },
    };

    if ($p->{price} >= $glob_vars->{delivery_min_sum}) {
        $_p->{local_delivery_cost} = { content => $glob_vars->{delivery_price} };
    }
    if ($p->{image}) {
        $_p->{picture} = { content => $glob_vars->{'shop.url'} . '/upload/products/' . $p->{image} };
    }

    $_cat{$p->{categories_id}} = 1;
    push @prod, $_p;
}

unless (@prod) {
    die 'YML ERROR: no products';
}

# Categories
my @cat = ();

for my $k (keys %_cat) {
    my $c = $k;
    while ($c) {
        my $category = database->quick_select('categories', { id => $c });
        $_cat{$category->{id}} = 1;
        $c = $category->{parent_id};
    }
}

if (%_cat) {
    my $categories = [ database->quick_select('categories', { enabled => 1, id => [ keys %_cat ] }, { order_by => [qw/parent_id sort/] }) ];
    for my $c (@$categories) {
        my $_c = {
            id      => $c->{id},
            content => func::escape_html($c->{name}),
        };

        if ($c->{parent_id}) {
            $_c->{parentId} = $c->{parent_id};
        }

        push @cat, $_c;
    }
}

unless (@cat) {
    die 'YML ERROR: no categories';
}

###########
my $yml_catalog = {
    date => "$t[5]-$t[4]-$t[3] $t[2]:$t[1]",
    shop => {
        name        => { content => $glob_vars->{'shop.name'} },
        company     => { content => $glob_vars->{'shop.company'} },
        url         => { content => $glob_vars->{'shop.url'} },
        categories  => {
            category => \@cat,
        },
        offers  => {
            offer => \@prod,
        },
    },
};

open my $fh, ">:utf8", $export or die("Can't open $export for write.\n");

my $xs = MyXMLSimple->new(
    KeepRoot   => 1,
    ForceArray => 0,
    KeyAttr    => { yml_catalog => 'date' },
    XMLDecl    => '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE yml_catalog SYSTEM "shops.dtd">',
);
$xs->XMLout({ yml_catalog => $yml_catalog }, OutputFile => $fh);

print 'done';

exit 0;
