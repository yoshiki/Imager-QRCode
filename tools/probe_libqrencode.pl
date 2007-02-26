#!/usr/local/bin/perl

use strict;

open my $fh, '>', 'test_libqrencode.c';
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

system("cc -o test_libqrencode test_libqrencode.c") == 0 or
    die "===> You must install libqrencode(http://megaui.net/fukuchi/works/qrencode/index.en.html) <===";
