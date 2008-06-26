use strict;
use warnings;
use ExtUtils::MakeMaker;
use Imager::ExtUtils;

my $compile_cmd     = 'cc -I/usr/local/include -I/usr/include -lqrencode';
my $libqrencode_url = 'http://megaui.net/fukuchi/works/qrencode/index.en.html';
my $version;
my $fh;

open $fh, '>', 'test_libqrencode.c';
print $fh <<'EOT';
#include <stdio.h>
#include "qrencode.h"

int main(int argc, char **argv)
{
    QRcode *code;
    return 0;
}
EOT
    ;
close $fh;

system("$compile_cmd -o test_libqrencode test_libqrencode.c >/dev/null 2>&1") == 0
    or die "*** You must install libqrencode. ***\nSee $libqrencode_url";

open $fh, '>', 'test_libqrencode1.0.2.c';
print $fh <<'EOT';
#include <stdio.h>
#include "qrencode.h"

int main(int argc, char **argv)
{
    QRcode *code;
    code = (QRcode *)QRcode_encodeStringCase("foo", 1, QR_ECLEVEL_L);
    return 0;
}
EOT
    ;
system("$compile_cmd -o test_libqrencode1.0.2 test_libqrencode1.0.2.c >/dev/null 2>&1") == 0
    and $version = "1.0.2";

open $fh, '>', 'test_libqrencode2.0.0.c';
print $fh <<'EOT';
#include <stdio.h>
#include "qrencode.h"

int main(int argc, char **argv)
{
    QRcode *code;
    code = (QRcode *)QRcode_encodeString8bit("foo", 1, QR_ECLEVEL_L);
    return 0;
}
EOT
    ;
system("$compile_cmd -o test_libqrencode2.0.0 test_libqrencode2.0.0.c >/dev/null 2>&1") == 0
    and $version = "2.0.0";

my %define_of = (
    '1.0.2' => '-DUNDER_LIBQRENCODE_1_0_2',
    '2.0.0' => '-DOVER_LIBQRENCODE_2_0_0',
);

link('lib/Imager/QRCode.xs', 'QRCode.xs');
WriteMakefile(
    NAME                => 'Imager::QRCode',
    AUTHOR              => 'Yoshiki KURIHARA <kurihara at cpan.org>',
    VERSION_FROM        => 'lib/Imager/QRCode.pm',
    ABSTRACT_FROM       => 'lib/Imager/QRCode.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'       => 0,
        'Imager'           => 0.55,
        'Imager::ExtUtils' => 0,
        'Encode'           => 0,
    },
    INC                 => Imager::ExtUtils->includes . ' -I/usr/local/include -I.',
    LIBS                => [ '-lqrencode' ],
    TYPEMAPS            => [ Imager::ExtUtils->typemap ],
    CCFLAGS             => $define_of{ $version },
    OBJECT              => 'QRCode.o',
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Imager-QRCode-* QRCode.xs test_libqrencode* *.gif' },
);
