#!/usr/bin/env perl
use Dancer ':script';
use FindBin '$RealBin';
use Dancer::Plugin::Database;
use File::Copy qw(move);

use lib '../lib';
use func;

my $appdir = path($RealBin, '..');
Dancer::Config::setting('appdir',$appdir);

config->{environment} = 'production';
config->{envdir} = "$appdir/environments";
config->{confdir} = $appdir;
Dancer::Config::load();

my $export  = "/mnt/sphinx/bstroy_products.xml";
my $tmp     = "/tmp/bstroy_products.xml";

my $xml_schema = <<CFG;
<sphinx:schema>

<sphinx:field name="name"/>
<sphinx:field name="short_descr"/>
<sphinx:field name="descr"/>

</sphinx:schema>
CFG

my $limit = 10000;
my $page = 1;
my $max_id = database->selectrow_array('SELECT max(id) FROM products');

open my $file, ">:utf8", $tmp or die("Can't open $tmp for write.\n");
print $file qq{<?xml version="1.0" encoding="utf-8"?>\n<sphinx:docset>\n};
print $file $xml_schema; # Scheme removed from sphinx config

while (1) {
    my $products = [ database->quick_select('products', "id BETWEEN ($page - 1) * $limit + 1 AND $page * $limit") ];

    my $last = 0;
    for my $i (@$products) {
        for ('name', 'short_descr', 'descr') {
            if ($i->{$_}) {
                $i->{$_} =~ s/^\s+//g;
                $i->{$_} =~ s/\s+$//g;
                $i->{$_} =~ s/\x1e//g;  # sphinx can't parse thisx character in CDATA.
            }
        }

        my $out  = "\n<sphinx:document id=\"" . $i->{id} . "\">\n";
        $out .= "  <name><![CDATA[ " . $i->{name} . " ]]></name>\n";
        $out .= "  <short_descr><![CDATA[ " . ($i->{short_descr} ? $i->{short_descr} : '') . " ]]></short_descr>\n";
        $out .= "  <descr><![CDATA[ " . ($i->{descr} ? $i->{descr} : '') . " ]]></descr>\n";
        $out .= "</sphinx:document>\n";

        print $file $out;
        $last = 1 if $i->{id} >= $max_id;
    }

    last if $last;
    $page++;
}

print $file qq{\n</sphinx:docset>\n};
close $file;

move($tmp, $export) or die "Can't move export file from $tmp to $export...\n";

exit 0;
