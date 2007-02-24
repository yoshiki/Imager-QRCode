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
        kanji         => 1,
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

=item new()

The new() constructor method instantiates a new Imager::QRCode object. new() accepts the following parameters.

=over 4

=item text

Input text. If you specify Japanese characters, you must encode it to Shift_JIS.

=item size

Horizontal and vertical size of module(dot). Default is 4.

=item margin

Margin size of QR Code. Default is 3.

=item level

Error collectin level. You can specify 'M', 'L', 'H' or 'Q'. Default is 'L'.

=item version

Version of the symbol. If you specify '0', this module chooses the minimum version for the input data. Default is '0'.

=item kanji

If you specify Japanese characters to 'string' argument, You must set '1'.

=item casesensitive

If your application is case-sensitive using 8-bit characters, set to '1'. Default is '0'.

=back

=item plot(%params)

Create a new QR Code image. It returns Imager object.

=back

=head1 INSTANCE METHODS

=over 4

=item plot_qrcode($text, \%params)

This method is instance method. $text is input text for plot. %params is same paramater as new().

=back

=head1 SEE ALSO

C<Imager>, C<http://www.qrcode.com/>, C<http://megaui.net/fukuchi/works/qrencode/index.en.html>

=head1 AUTHOR

Yoshiki KURIHARA  C<< <kurihara@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Yoshiki KURIHARA C<< <kurihara@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
