use Test::More tests => 4;
use Imager::QRCode;
use Encode;

my @Tests = ( {
    params => {},
    result => qr/^$/,
}, {
    params => {
        size          => 2,
        margin        => 2,
        version       => 1,
        level         => 'M',
        casesensitive => 1,
        lightcolor    => Imager::Color->new(255, 255, 255),
        darkcolor     => Imager::Color->new(0, 0, 0),
    },
    result => qr/^$/,
}, {
    params => {
        size          => 2,
        margin        => 2,
        version       => 1,
        level         => 'M',
        casesensitive => 1,
        mode          => '8-bit',
        lightcolor    => Imager::Color->new(255, 255, 255),
        darkcolor     => Imager::Color->new(0, 0, 0),
    },
    result => qr/^$/,
}, {
    params => {
        size          => 2,
        margin        => 2,
        version       => 1,
        level         => 'M',
        casesensitive => 1,
        mode          => 'invalid',
        lightcolor    => Imager::Color->new(255, 255, 255),
        darkcolor     => Imager::Color->new(0, 0, 0),
    },
    result => qr/^Invalid mode: XS error/,
} );

for my $dat ( @Tests ) {
    my $params = $dat->{ params };
    my $qrcode = Imager::QRCode->new(%$params);
    my $text = "0";

    eval { $qrcode->plot($text) };
    like $@, $dat->{ result }, 'plot successful';
}
