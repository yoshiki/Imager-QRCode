use strict;
use warnings;
use inc::Module::Install;
use File::Copy;

name                'Imager-QRCode';
author              'Yoshiki KURIHARA <kurihara at cpan.org>';
all_from            'lib/Imager/QRCode.pm';

cc_inc_paths '.';
can_cc or die "This module requires a C compiler";

build_requires      'Test::More'       => 0;
build_requires      'Imager'           => '0.55';
requires            'Encode'           => 0;

auto_install;
WriteAll;

sub MY::post_constants {
    my $define = eval { test_libqrencode() };
    if ( $@ ) {
        warn $@;
        exit 0; # tell cpan testers that this is not a failure
    }
    eval { require Imager::ExtUtils };
    if ( $@ ) {
        warn "*** You must install Imager.";
        exit 0; # tell cpan testers that this is not a failure
    }
    my $typemap  = Imager::ExtUtils->typemap;
    my $includes = Imager::ExtUtils->includes;
    return <<"POST_CONST";
XSUBPPARGS += -typemap $typemap
INC += $includes
CCFLAGS += $define
LDDLFLAGS += -lqrencode
LDFLAGS += -lqrencode
POST_CONST
}

sub test_libqrencode {
    my $compile_cmd
        = 'cc -I/usr/local/include -I/usr/include -L/usr/lib -L/usr/local/lib -lqrencode';
    my $libqrencode_url
        = 'http://megaui.net/fukuchi/works/qrencode/index.en.html';
    my $version;
    my $fh;
    my %define_of = (
        '1.0.2' => '-DUNDER_LIBQRENCODE_1_0_2',
        '2.0.0' => '-DOVER_LIBQRENCODE_2_0_0',
    );

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
        or do {
            unlink for qw( test_libqrencode test_libqrencode.c );
            die "*** You must install libqrencode.\n*** See $libqrencode_url";
        };

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

    unlink for qw( test_libqrencode test_libqrencode.c
                   test_libqrencode1.0.2 test_libqrencode1.0.2.c
                   test_libqrencode2.0.0 test_libqrencode2.0.0.c );

    die "*** Unknown error occured in libqrencode version check process." unless $version;
    return $define_of{ $version };
}
