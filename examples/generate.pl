#!/usr/local/bin/perl

use strict;
use Encode;
use Imager::QRCode qw(plot_qrcode);

my %params = (
    size          => 2,
    margin        => 2,
    version       => 1,
    level         => 'M',
    kanji         => 1,
    casesensitive => 1,
    lightcolor    => Imager::Color->new(255, 255, 255),
    darkcolor     => Imager::Color->new(0, 0, 0),
);
my $qrcode = Imager::QRCode->new(%params);
my $text = encode('cp932', decode('utf8', "QRコードは(株)デンソーウェーブの登録商標です。"));
my $img1 = $qrcode->plot($text);
$img1->write(file => "qrcode1.gif");

my $img2 = plot_qrcode($text, \%params);
$img2->write(file => "qrcode2.gif");

