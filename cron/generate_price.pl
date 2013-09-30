#!/usr/bin/env perl
use Dancer ':script';
use FindBin '$RealBin';
use Dancer::Plugin::Database;
use Spreadsheet::WriteExcel;
use Encode;

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

my $row;

my $workbook = Spreadsheet::WriteExcel->new('../public/price.xls');

my $category_main_f = $workbook->add_format(bold => 1, border => 1, size => 16, align => 'center');
my $category_f = $workbook->add_format(bold => 1, border => 1, bg_color => 'cyan');
my $product_header_f = $workbook->add_format(border => 1, bold=> 1);
my $product_f = $workbook->add_format(border => 1, text_wrap => 1);

price_build();

$workbook->close();




sub price_build {
    my ($worksheet, $parent_id) = (shift, shift || 0);

    my $categories = [ database->quick_select('categories', { parent_id => $parent_id, enabled => 1 }, { order_by => 'sort' }) ];
    for my $c (@$categories) {
        unless ($c->{parent_id}) {
            $row = 0;
            $worksheet = $workbook->add_worksheet(length($c->{name}) > 30 ? substr($c->{name}, 0, 27) . '...' : $c->{name});
            $worksheet->set_column('A:B', 50);
            $worksheet->set_row($row, 20);
            $worksheet->merge_range($row, 0, $row, 2, $c->{name}, $category_main_f);
        }
        else {
            $worksheet->merge_range($row, 0, $row, 2, $c->{name}, $category_f);
        }
        $row++;

        my $products = [ database->quick_select('products', { categories_id => $c->{id}, enabled => 1 }, { order_by => 'sort' }) ];
        if (scalar @$products) {
            $worksheet->write($row, 0, Encode::decode('utf8', 'Название'), $product_header_f);
            $worksheet->write($row, 1, Encode::decode('utf8', 'Краткое описание'), $product_header_f);
            $worksheet->write($row, 2, Encode::decode('utf8', 'Цена'), $product_header_f);
            $row++;
        }

        for my $p (@$products) {
            for (qw/name short_descr/) {
                if ($p->{$_}) {
                    $p->{$_} =~ s/<.*?>//g;
                }
            }

            $worksheet->write($row, 0, $p->{name}, $product_f);
            $worksheet->write($row, 1, $p->{short_descr}, $product_f);
            $worksheet->write($row, 2, $p->{price}, $product_f);
            $row++;
        }

        price_build($worksheet, $c->{id});
    }
}

exit 0;
