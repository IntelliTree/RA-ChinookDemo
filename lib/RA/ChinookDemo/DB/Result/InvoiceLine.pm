use utf8;
package RA::ChinookDemo::DB::Result::InvoiceLine;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("InvoiceLine");
__PACKAGE__->add_columns(
  "invoicelineid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "invoiceid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "trackid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "unitprice",
  { data_type => "numeric", is_nullable => 0, size => [10, 2] },
  "quantity",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("invoicelineid");
__PACKAGE__->belongs_to(
  "invoiceid",
  "RA::ChinookDemo::DB::Result::Invoice",
  { invoiceid => "invoiceid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "trackid",
  "RA::ChinookDemo::DB::Result::Track",
  { trackid => "trackid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-12 15:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/fHkaVziPDQhBw3lU+JmUA

# Example of a 2-level single relationship (Invoice in-between)
__PACKAGE__->belongs_to(
  "customerid",
  "RA::ChinookDemo::DB::Result::Customer",
  sub {
    my $args = shift;

    my $MiddleRsCol = $args->{self_resultsource}->schema->resultset('Invoice')
      ->search_rs(undef,{ 
        alias   => 'invoice_alias',
        columns => ['customerid']
      })
      ->search_rs({ 
        'invoice_alias.invoiceid' => { -ident => "$args->{self_alias}.invoiceid" }
      })
      ->get_column('customerid');

    return (
      { "$args->{foreign_alias}.customerid" => { '=' => $MiddleRsCol->as_query } }
    );
  }
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
