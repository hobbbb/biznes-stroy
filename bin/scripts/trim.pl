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

my $products = [ database->quick_select('products', {}) ];
for my $p (@$products) {
    database->quick_update('products', { id => $p->{id} }, { name => func::trim($p->{name}) });
}
