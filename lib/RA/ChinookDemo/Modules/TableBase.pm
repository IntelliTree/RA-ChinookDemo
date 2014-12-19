package RA::ChinookDemo::Modules::TableBase;

use strict;
use warnings;
use feature 'switch';

use Moose;
extends 'Catalyst::Plugin::RapidApp::RapidDbic::TableBase';

use RapidApp::Include qw(sugar perlutil);

sub BUILD {
  my $self = shift;
  
  # Stuff we change during BUILD becomes the new base config....
  $self->apply_extconfig(
    pageSize => 30
  
  );
  
  
  # When this class is used for multiple sources, we can target specific ones like:
  given( $self->ResultSource->source_name ) {
  
    when('Album') {
      # Change column order...
      # First argument is the index, this will move title and tracks from
      # whatever postion they were at to be the first and second columns,
      # leaving the rest of the order unchanged
      $self->set_columns_order(0,'title','tracks');
    }
  
    when('Invoice') {
    
      # Simple change of a single column:
      $self->apply_columns( billingaddress => { 
        header => 'Billing Address',
        width => 200
      });
      
      # Apply to multiple names:
      $self->apply_columns_list([qw/billingstate billingcity/] => {
        hidden => 1
      });
    
    }
    
    when('Playlist') {
      # It can be a good idea to turn off sorting for multi-rels and other virtualized
      # columns which produce sub-queries:
      $self->apply_columns( playlist_tracks => { 
        sortable => 0
      });
    
    }
    
    when('InvoiceLine') {
      # 'columns' within the context of a grid class are not the same as in TableSpecs. The
      # default config of columns come from the TableSpecs, but the columns here are the 
      # columns of the interface. Joined columns are named according to relationship path:
      $self->apply_columns( trackid__name => { 
        hidden => 0, #<-- joined columns are hidden by default, but we can unhide
        header => 'Track',
        width => 150
      });
      
      # Make it the *second* column w/o needing to know what the first column is
      $self->set_columns_order(1,'trackid__name');
      
      
      # the 'profiles' params that can be set at the TableSpec layer are *not* understood
      # here. profiles are just macros that set multiple configs at once
      # But, we can still set some of the settings that profiles set, like 'money'
      $self->apply_columns( unitprice => {
        renderer => 'Ext.util.Format.usMoney'
      
      });
    
    }
    
    when('Track') {
      # convenience to make bulk changes, like unhide all columns when there are joins
      $self->apply_to_all_columns( hidden => \0 );
    }
  
  }
  
  # We can also add a listener to change things during each request
  $self->add_ONREQUEST_calls_early('change_stuff');
  # ONREQUEST_calls_early is the earliest hook available, ONREQUEST_calls and 
  # ONREQUEST_calls_late are also available. These are useful when folding in
  # multiple layers of logic in the correct order
}


sub change_stuff {
  my $self = shift;
  
  # During the request we can change stuff according to the current request, like the user 
  # roles. Just for a easy/testible example, here we'll do it based on a query string

  # Columns changes can be made in ONREQUEST_calls_early listeners. Changes here
  # only apply to teh current request
  if (my $col = $self->c->req->params->{exclude_this_column}) {

    $self->apply_columns( $col => {
      # no_column is different from hidden in that the column is not able to be unhidden
      # However, if we choose to hide the primary key which is used for for REST nav,
      # RapidApp is smart enough to still use/fetch it under the hood
      #
      #   http://localhost:3000/#!/main/db/db_genre?exclude_this_column=genreid
      #
      # Otherwise, only active columns are fetched in teh query/request
      no_column => 1,
      # These are needed to remove the column from being searchable
      no_multifilter => 1,
      no_quick_search => 1
    });
  }
  
  # TimToady
  if ($self->c->req->params->{make_me_read_only}) {
    $self->apply_extconfig( 
      store_exclude_api => [qw(create update destroy)]
    );
  }

}


# The content() method returns the ExtJS panel config as a HashRef. It is then serialized
# to JSON and returned to the client. This is the latest stage in the request cycle, after
# the ONREQUEST hooks...
before 'content' => sub {
  my $self = shift;
  
  # We can also change configs at request time here. Any configs changed during a request
  # will still only apply to the life of that request. the content() method is the last thing that
  # happens during teh request cycle, but its not too late to change extconfigs, but
  # is too late to call stuff like apply_columns()
  if (my $custom_title = $self->c->req->params->{custom_title}) {
    #
    # http://localhost:3000/#!/main/db/db_playlist?custom_title=No_Name&exclude_this_column=name
    #
    $self->apply_extconfig(
      tabTitle => $custom_title
    );
  }
  
};

around 'content' => sub {
  my ($orig, $self, @args) = @_;
  
  my $cnf = $self->$orig(@args);
  
  # you can also just mess with the data structure returned directly:
  $cnf->{pageSize} = 100 if ($self->ResultSource->source_name eq 'Track');
  
  # This is also a good place to dump the config for debug:
  #scream($cnf);
  #
  # ^^ scream function comes from: use RapidApp::Include qw(sugar perlutil);
  
  return $cnf;
};



1;
