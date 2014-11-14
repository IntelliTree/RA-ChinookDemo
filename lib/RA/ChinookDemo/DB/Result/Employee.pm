use utf8;
package RA::ChinookDemo::DB::Result::Employee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("Employee");
__PACKAGE__->add_columns(
  "employeeid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "lastname",
  { data_type => "nvarchar", is_nullable => 0, size => 20 },
  "firstname",
  { data_type => "nvarchar", is_nullable => 0, size => 20 },
  "title",
  { data_type => "nvarchar", is_nullable => 1, size => 30 },
  "reportsto",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "birthdate",
  { data_type => "datetime", is_nullable => 1 },
  "hiredate",
  { data_type => "datetime", is_nullable => 1 },
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
  { data_type => "nvarchar", is_nullable => 1, size => 60 },
);
__PACKAGE__->set_primary_key("employeeid");
__PACKAGE__->has_many(
  "customers",
  "RA::ChinookDemo::DB::Result::Customer",
  { "foreign.supportrepid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "employees",
  "RA::ChinookDemo::DB::Result::Employee",
  { "foreign.reportsto" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "reportsto",
  "RA::ChinookDemo::DB::Result::Employee",
  { employeeid => "reportsto" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-12 15:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wHFFXU19HU2txd7Slmw1vg

# Example of a multi-level join rel (Customer in-between)
__PACKAGE__->has_many(
  "invoices",
  "RA::ChinookDemo::DB::Result::Invoice",
  sub {
    my $args = shift;
    
    my $MiddleRsCol = $args->{self_resultsource}->schema->resultset('Customer')
      ->search_rs(undef,{ alias => 'cust_alias' })
      ->search_rs({ 
        'cust_alias.supportrepid' => { -ident => "$args->{self_alias}.employeeid" }
      })
      ->get_column('customerid');
      
    return (
      { "$args->{foreign_alias}.customerid" => { -in => $MiddleRsCol->as_query } }
    );
  }
);


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
