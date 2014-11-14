use utf8;
package RA::ChinookDemo::DB::Result::Customer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("Customer");
__PACKAGE__->add_columns(
  "customerid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "firstname",
  { data_type => "nvarchar", is_nullable => 0, size => 40 },
  "lastname",
  { data_type => "nvarchar", is_nullable => 0, size => 20 },
  "company",
  { data_type => "nvarchar", is_nullable => 1, size => 80 },
  "address",
  { data_type => "nvarchar", is_nullable => 1, size => 70 },
  "city",
  { data_type => "nvarchar", is_nullable => 1, size => 40 },
  "state",
  { data_type => "nvarchar", is_nullable => 1, size => 40 },
  "country",
  { data_type => "nvarchar", is_nullable => 1, size => 40 },
  "postalcode",
  { data_type => "nvarchar", is_nullable => 1, size => 10 },
  "phone",
  { data_type => "nvarchar", is_nullable => 1, size => 24 },
  "fax",
  { data_type => "nvarchar", is_nullable => 1, size => 24 },
  "email",
  { data_type => "nvarchar", is_nullable => 0, size => 60 },
  "supportrepid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("customerid");
__PACKAGE__->has_many(
  "invoices",
  "RA::ChinookDemo::DB::Result::Invoice",
  { "foreign.customerid" => "self.customerid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "supportrepid",
  "RA::ChinookDemo::DB::Result::Employee",
  { employeeid => "supportrepid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-12 15:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3WdAq+vRAFXbRXBhHpK3TQ


# Example of a 2-level multi relationship (Invoice in-between)
__PACKAGE__->has_many(
  "invoice_lines",
  "RA::ChinookDemo::DB::Result::InvoiceLine",
  sub {
    my $args = shift;

    my $MiddleRsCol = $args->{self_resultsource}->schema->resultset('Invoice')
      ->search_rs(undef,{ 
        alias   => 'invoice_alias', 
        columns => ['invoiceid']
      })
      ->search_rs({ 
        'invoice_alias.customerid' => { -ident => "$args->{self_alias}.customerid" }
      })
      ->get_column('invoiceid');

    return (
      { "$args->{foreign_alias}.invoiceid" => { -in => $MiddleRsCol->as_query } }
    );
  }
);


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
