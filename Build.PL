use strict;
use warnings;
use Module::Build;
use Imager::ExtUtils;

link('lib/Imager/QRCode.xs', 'QRCode.xs');
my $builder = Module::Build->new(
    module_name          => 'Imager::QRCode',
    license              => 'perl',
    dist_author          => 'Yoshiki KURIHARA <kurihara@cpan.org>',
    dist_version_from    => 'lib/Imager/QRCode.pm',
    requires => {
        'Test::More' => 0,
        'Imager'     => 0.55,
        'Encode'     => 0,
    },
    xs_files => {
        'QRCode.xs' => 'QRCode.xs',
    },
    extra_compiler_flags => Imager::ExtUtils->includes . ' -I/usr/local/include -I.',
    extra_linker_flags   => '-lqrencode',
    add_to_cleanup       => [ 'Imager-QRCode-*', 'QRCode.xs', 'test_libqrencode*', '*.gif' ],
);

$builder->create_build_script();
