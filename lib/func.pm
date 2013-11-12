package func;

our @ISA = qw(Exporter);
our @EXPORT = qw(&w);

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Lingua::Translit;
use Lingua::RU::Number qw(rur_in_words);
use MIME::Lite;
use MIME::Base64;
use Encode qw/encode/;
use Time::Local;
use LWP::UserAgent;
use SCM::utils;

sub products_get_image {
    my $products = shift;

    for (@$products) {
        my $i = database->quick_select('products_images', { products_id => $_->{id} }, { columns => [qw/image/], order_by => 'image', limit => '1' });
        $_->{image} = $i->{image};
    }
}

sub product_price {
    my ($product, $category, $qnt) = @_;

    if ($product->{sale_price}) {
        return $product->{sale_price};
    }
    elsif (($category->{middle_percent} || $category->{retail_percent}) and $qnt) {
        my $retail_price = $product->{price} * (100 + $category->{retail_percent}) / 100;
        my $middle_price = $product->{price} * (100 + $category->{middle_percent}) / 100;

        my $rsum = $retail_price * $qnt;
        if ($rsum >= $category->{retail_sum} and $rsum < $category->{middle_sum}) {
            return $middle_price;
        }
        elsif ($rsum >= $category->{middle_sum}) {
            return $product->{price};
        }
        else {
            return $retail_price;
        }
    }
    else {
        return $product->{price};
    }
}

sub generate {
    my $length = $_[0] || 50;
    my @table = ('A'..'Z','1'..'9','a'..'z','!','@','#','$','%','^','&','*','(',')');
    my $str = '';
    for(my $i=0; $i<$length; $i++) {
        $str .= $table[int(rand(scalar(@table)))]
    }
    return $str;
}

sub generate_light {
    my $length = 10;
    my @table = ('A'..'Z','1'..'9','a'..'z');
    my $str = '';
    for(my $i=0; $i<$length; $i++) {
        $str .= $table[int(rand(scalar(@table)))]
    }
    return $str;
}

sub make_alias {
    my $name = shift;

    my $tr = new Lingua::Translit("GOST 7.79 RUS");
    my $alias = $tr->translit(lc $name);
    $alias =~ s!\s+!-!g;
    $alias =~ s![^a-z\-\d]!!g;
    $alias .= '.html' if $alias;

    return $alias;
}

sub email {
    my %params = @_;

    $params{to} = 'p.vasilyev@corp.mail.ru, vvd@programmex.ru' if config->{environment} ne 'production';

    utf8::encode($params{body});
    $params{$_} = encode('MIME-Header', $params{$_}) for qw(to from subject);

    my $msg = MIME::Lite->new(
        From    => $params{from} || 'info',
        To      => $params{to},
        Subject => $params{subject},
        Type    => 'multipart/mixed',
    );
    $msg->attach(
        Type    => 'text/html; charset=UTF-8',
        Data    => $params{body},
    );

    for (@{$params{attachment}}) {
        utf8::encode($_->{Filename});
        $msg->attach(%{$_});
    }

    $msg->send;

    if ($params{attachment_delete}) {
        for (@{$params{attachment}}) {
            unlink $_->{Path} if -f $_->{Path};
        }
    }
}

sub send_sms {
    my %params = @_;
    return unless ($params{phone} and $params{message});

    $params{phone} = '9035082656' if config->{environment} ne 'production';

    my $url = 'http://www.smstraffic.ru/multi.php';

    my $ua = LWP::UserAgent->new(max_redirect => 0);
    $ua->timeout(5);

    my $p = {
        login        => 'biznesstroy',
        password     => 'qiwebola',
        phones       => $params{phone},
        message      => $params{message},
        rus          => 5,
        originator   => 'BiznesStroy',
        flash        => 0,
        autotrancate => 1,
    };

    my $rsp = $ua->post($url, $p);
    unless ($rsp->is_success) {
        $url = 'http://www2.smstraffic.ru/multi.php';
        $rsp = $ua->post($url, $p);
    }

    return $rsp->content;
}

sub now {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    $year += 1900;
    $mon += 1;

    return "$year-$mon-$mday $hour:$min:$sec";
}

sub date_in_sec {
    my $date = shift;
    return unless $date;

    $date =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)/;
    return timelocal($6, $5, $4, $3, $2 - 1, $1);
}

sub date_diff {
    my $date1 = shift;
    my $date2 = shift || now();
    return unless $date1;

    my $sec = date_in_sec($date2) - date_in_sec($date1);
    return $sec;
}

sub price_in_words {
    my $price = shift;

    my $price_in_words = rur_in_words($price);
    Encode::from_to($price_in_words, 'cp1251', 'utf8');
    Encode::_utf8_on($price_in_words);

    return $price_in_words;
}

1;
