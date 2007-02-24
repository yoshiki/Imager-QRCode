use strict;
use warnings;
use ExtUtils::MakeMaker;
use Imager::ExtUtils;

my $result = do 'tools/probe_libqrencode.pl';
die if $@;

link('lib/Imager/QRCode.xs', 'QRCode.xs');
WriteMakefile(
    NAME                => 'Imager::QRCode',
    AUTHOR              => 'Yoshiki KURIHARA <kurihara@cpan.org>',
    VERSION_FROM        => 'lib/Imager/QRCode.pm',
    ABSTRACT_FROM       => 'lib/Imager/QRCode.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Imager'     => 0.55,
        'Encode'     => 0,
    },
    INC                 => Imager::ExtUtils->includes . ' -I/usr/local/include -I.',
    LIBS                => [ '-lqrencode' ],
    TYPEMAPS            => [ Imager::ExtUtils->typemap ],
    OBJECT              => 'QRCode.o',
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Imager-QRCode-* QRCode.xs test_libqrencode* *.gif' },
);
