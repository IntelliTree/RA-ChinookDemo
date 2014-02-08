use utf8;
package RA::ChinookDemo::DB::Result::Album;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("Album");
__PACKAGE__->add_columns(
  "albumid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "nvarchar", is_nullable => 0, size => 160 },
  "artistid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("albumid");
__PACKAGE__->belongs_to(
  "artistid",
  "RA::ChinookDemo::DB::Result::Artist",
  { artistid => "artistid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "tracks",
  "RA::ChinookDemo::DB::Result::Track",
  { "foreign.albumid" => "self.albumid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-12 15:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OJ1U992pTI/1TC7qsm8syA


# This is a crazy example relationship based on this example from the DBICTest Schema:
# https://github.com/dbsrgits/dbix-class/blob/2b58042/t/lib/DBICTest/Schema/CD.pm#L108-L138
__PACKAGE__->might_have(
  "longest_track",
  "RA::ChinookDemo::DB::Result::Track",
  sub {
    my $args = shift;
    my $Rs = $args->{self_resultsource}->schema->resultset('Track');
    return (
      {
        "$args->{foreign_alias}.trackid" => { '=' => $Rs->search(
          { 'correlated_tracks.albumid' => { -ident => "$args->{self_alias}.albumid" } },
          {
            order_by => { -desc => 'milliseconds' },
            rows => 1,
            alias => 'correlated_tracks',
            columns => ['trackid']
          },
        )->as_query }
      }
    );
  }
);


# This is an even more crazy example that includes a nested join/group_by with agg funcs:
# We define the "most populare" track as the track that has the
# most 'invoice_lines' rows (i.e. has been sold the most number of times)
__PACKAGE__->might_have(
  "most_popular_track",
  "RA::ChinookDemo::DB::Result::Track",
  sub {
    my $args = shift;
    my $source = $args->{self_resultsource};
    my $Rs = $source->schema->resultset('Track');
    return (
      {
        "$args->{foreign_alias}.trackid" => { '=' => $Rs->search(
          { 'correlated_tracks.albumid' => { -ident => "$args->{self_alias}.albumid" } },
          {
            order_by => { -desc => 'invoice_line_count' },
            rows => 1,
            alias => 'correlated_tracks',
            join => 'invoice_lines',
            group_by => 'correlated_tracks.trackid',
            select => [
              'correlated_tracks.trackid',
              { 
                '' => { count => 'invoice_lines.invoicelineid' }, 
                -as => 'invoice_line_count'
              }
            ],
            as => [
              'trackid',
              'invoice_line_count'
            ]
          },
        )->get_column('trackid')->as_query }
      }
    );
  },
); 


# This is another adaptation that totals the quantity sold instead
# of just counting the invoice_line rows:
__PACKAGE__->might_have(
  "most_popular_track_by_qty",
  "RA::ChinookDemo::DB::Result::Track",
  sub {
    my $args = shift;
    my $source = $args->{self_resultsource};
    my $Rs = $source->schema->resultset('Track');
    return (
      {
        "$args->{foreign_alias}.trackid" => { '=' => $Rs->search(
          { 'correlated_tracks.albumid' => { -ident => "$args->{self_alias}.albumid" } },
          {
            order_by => { -desc => 'quantity_sold' },
            rows => 1,
            alias => 'correlated_tracks',
            join => 'invoice_lines',
            group_by => 'correlated_tracks.trackid',
            select => [
              'correlated_tracks.trackid',
              { 
                '' => { sum => 'invoice_lines.quantity' }, 
                -as => 'quantity_sold'
              }
            ],
            as => [
              'trackid',
              'quantity_sold'
            ]
          },
        )->get_column('trackid')->as_query }
      }
    );
  },
); 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
