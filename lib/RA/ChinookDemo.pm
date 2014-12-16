package RA::ChinookDemo;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use RapidApp 0.99650_01;

use Catalyst qw/
    -Debug
    ConfigLoader
    RapidApp::RapidDbic
/;

extends 'Catalyst';

our $VERSION = '0.01';


__PACKAGE__->config(

);

# Start the application
__PACKAGE__->setup();


=head1 NAME

RA::ChinookDemo - Catalyst based application

=head1 SYNOPSIS

    script/ra_chinookdemo_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<RA::ChinookDemo::Controller::Root>, L<Catalyst>

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
