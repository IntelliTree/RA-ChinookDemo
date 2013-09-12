use utf8;
package RA::ChinookDemo::DB::Result::Invoice;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("Invoice");
__PACKAGE__->add_columns(
  "invoiceid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "customerid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "invoicedate",
  { data_type => "datetime", is_nullable => 0 },
  "billingaddress",
  { data_type => "nvarchar", is_nullable => 1, size => 70 },
  "billingcity",
  { data_type => "nvarchar", is_nullable => 1, size => 40 },
  "billingstate",
  { data_type => "nvarchar", is_nullable => 1, size => 40 },
  "billingcountry",
  { data_type => "nvarchar", is_nullable => 1, size => 40 },
  "billingpostalcode",
  { data_type => "nvarchar", is_nullable => 1, size => 10 },
  "total",
  { data_type => "numeric", is_nullable => 0, size => [10, 2] },
);
__PACKAGE__->set_primary_key("invoiceid");
__PACKAGE__->belongs_to(
  "customerid",
  "RA::ChinookDemo::DB::Result::Customer",
  { customerid => "customerid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "invoice_lines",
  "RA::ChinookDemo::DB::Result::InvoiceLine",
  { "foreign.invoiceid" => "self.invoiceid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-12 15:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J8wpjsKmVyoFQnEzPmQDtw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
