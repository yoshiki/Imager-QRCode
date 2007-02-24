package Imager::QRCode;

use warnings;
use strict;
use base qw(Exporter);
use vars qw(@ISA $VERSION @EXPORT_OK);

@EXPORT_OK = qw(plot_qrcode);

use Carp;
use Imager 0.55;

BEGIN {
    $VERSION = '0.01';
    eval {
        require XSLoader;
        XSLoader::load('Imager::QRCode', $VERSION);
        1;
    } or do {
        require DynaLoader;
        push @ISA, 'DynaLoader';
        bootstrap Imager::QRCode $VERSION;
    };
}

sub new {
    my $class  = shift;
    my $params = ref $_[0] eq 'HASH' ? $_[0] : { @_ };
    return bless { params => $params }, $class;
}

sub plot {
    my ( $self, $text ) = @_;
    length $text or Carp::croak "You must specify text.";
    return _imager( _plot($text, $self->{params}) );
}

sub plot_qrcode {
    my ( $text, $params ) = @_;
    return _imager( _plot( $text, $params ) );
}

sub _imager {
    my $raw = shift;
    my $img = Imager->new;
    $img->{IMG} = $raw;
    return $img;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Imager::QRCode - Generate QR Code with Imager

=head1 SYNOPSIS

    use Imager::QRCode;

    my $qrcode = Imager::QRCode->new(
        size          => 2,
        margin        => 2,
        version       => 1,
        level         => 'M',
        casesensitive => 1,
        lightcolor    => Imager::Color->new(255, 255, 255),
        darkcolor     => Imager::Color->new(0, 0, 0),
    );
    my $img = $qrcode->plot("blah blah");
    $img->write(file => "qrcode.gif");

    # or instance method
    use Imager::QRCode qw(plot_qrcode);

    my $img = plot_qrcode("blah blah", \%params);
    $img->write(file => "qrcode.gif");

=head1 DESCRIPTION

This module allows you to generate QR Code with Imager. This module use libqrencode library.

=head1 METHODS

=over 4

=item new

    $qrcode = Imager::QRCode->new(%params);

The C<new()> constructor method instantiates a new Imager::QRCode object. C<new()> accepts the following parameters.

=over 4

=item *

C<size> - Horizontal and vertical size of module(dot). Default is 4.

=item *

C<margin> - Margin size of QR Code. Default is 3.

=item *

C<level> - Error collectin level. Valid values are 'M', 'L', 'Q' or 'H'. Default is 'L'.

=item *

C<version> - Version of the symbol. If specify '0', this module chooses the minimum version for the input data. Default is '0'.

=item *

C<mode> - Encoding mode. Valid values are 'numerical', 'alpha-numerical', '8-bit' or 'kanji'. Default is '8-bit'.

If not give C<casesensitive> then should be given C<mode>. If 'kanji' is given, characters will be encoded as Shif-JIS characters. If '8-bit' is given, all of non-alpha-numerical characters will be encoded as is. If you want to embed UTF-8 string, choose '8-bit'.

=item *

C<casesensitive> - If your application is case-sensitive using 8-bit characters, set to '1'. Default is '0'.

=back

=item plot($text)

    $img = $qrcode->plot("blah blah");

Create a new QR Code image. This method returns Imager object ploted QR Code with the given text.

=back

=head1 INSTANT METHODS

=over 4

=item plot_qrcode($text, \%params)

Instant method. C<$text> is input text. C<%params> is same paramater as C<new()>.

=back

=head1 SEE ALSO

C<Imager>, C<http://www.qrcode.com/>, C<http://megaui.net/fukuchi/works/qrencode/index.en.html>

=head1 AUTHOR

Yoshiki KURIHARA  C<< <kurihara@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Yoshiki KURIHARA C<< <kurihara@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
