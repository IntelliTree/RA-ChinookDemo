package RA::ChinookDemo;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use RapidApp;

use Catalyst qw/
    -Debug
    RapidApp::RapidDbic
/;

extends 'Catalyst';

our $VERSION = '0.01';


__PACKAGE__->config(
    name => 'RA::ChinookDemo',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,

    'Plugin::RapidApp::RapidDbic' => {
      # Only required option:
      dbic_models => ['DB'],
      configs => { # Model Configs
         DB => { # Configs for the model 'DB'
            grid_params => {
               '*defaults' => { # Defaults for all Sources
                  updatable_colspec => ['*'],
                  creatable_colspec => ['*'],
                  destroyable_relspec => ['*']
               }, # ('*defaults')
               Album => {
                  include_colspec => ['*','artistid.name'] 
               },
               Invoice => {
                  # Delete invoice_lines with invoice (cascade):
                  destroyable_relspec => ['*','invoice_lines']
               },
               InvoiceLine => {
                  # join all columns of all relationships (first-level):
                  include_colspec => ['*','*.*'],
                  updatable_colspec => [
                     'invoiceid','unitprice',
                     'invoiceid.billing*'
                  ],
               },
               Track => {
                  include_colspec => ['*','albumid.artistid.*'] 
               },
            }, # (grid_params)
            TableSpecs => {
               Album => {
                  display_column => 'title'
               },
               Artist => {
                  display_column => 'name'
               },
               Genre => {
                  display_column => 'name'
               },
               MediaType => {
                  display_column => 'name'
               },
            }, # (TableSpecs)
         }, # (DB)
      }, # (configs)
    }, # ('Plugin::RapidApp::RapidDbic')
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
