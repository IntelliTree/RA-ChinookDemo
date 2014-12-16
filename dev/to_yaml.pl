#!/usr/bin/perl
#
use strict;
use warnings;

use YAML qw(Dump Bless);

my %cfg = ();

$cfg{on_plugin} = {
   name => 'RA::ChinookDemo',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,


    'Model::DB' => {
      schema_class => 'RA::ChinookDemo::DB',
    
      connect_info => {
        dsn => 'dbi:SQLite:chinook.db',
        user => '',
        password => '',
        sqlite_unicode => q{1},
        on_connect_call => q{use_foreign_keys},
        quote_names => q{1},
      }     

    },


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
               Genre => {
                  # Leave persist_immediately on without the add form
                  # (inserts blank/default rows immediately):
                  use_add_form => 0,
                  # No delete confirmations:
                  confirm_on_destroy => 0
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
               MediaType => {
                  # Use the grid itself to set new row values:
                  use_add_form => 0, #<-- also disables autoload_added_record
                  persist_immediately => {
                     create  => 0,
                     update  => 1,
                     destroy => 1
                  },
                  # No delete confirmations:
                  confirm_on_destroy => 0
               },
               Track => {
                  include_colspec => ['*','albumid.artistid.*'],
                  # Don't persist anything immediately:
                  persist_immediately => {
                     # 'create => 0' changes these defaults:
                     #   use_add_form => '0' (normally 'tab')
                     #   autoload_added_record => 0 (normally '1')
                     create  => 0,
                     update  => 0,
                     destroy => 0
                  },
                  # Use the add form in a window:
                  use_add_form => 'window'
               },
            }, # (grid_params)
            TableSpecs => {
               Album => {
                  display_column => 'title'
               },
               Artist => {
                  display_column => 'name'
               },
               Employee => {
                  # Use virtual column 'full_name' as the display column:
                  display_column => 'full_name'
               },
               Genre => {
                  display_column => 'name',
                  auto_editor_type => 'combo'
               },
               MediaType => {
                  display_column => 'name',
                  auto_editor_type => 'combo'
               },
               Track => {
                  columns => {
                     bytes => {
                        renderer => 'Ext.util.Format.fileSize'
                     },
                     unitprice => {
                        renderer => 'Ext.util.Format.usMoney',
                        header   => 'Price',
                        width    => 50
                     },
                     name => {
                        header => 'Name', width => 140
                     },
                     albumid => {
                        header => 'Album', width => 130
                     },
                     mediatypeid => {
                        header => 'Media Type', width => 165
                     },
                     genreid => {
                        header => 'Genre', width => 110
                     },
                     playlist_tracks => {
                        sortable  => 0
                     },
                     milliseconds => {
                        hidden   => 1
                     },
                     composer => {
                        hidden   => 1,
                        no_quick_search => 1,
                        no_multifilter  => 1
                     },
                     trackid => {
                        #allow_add  => 1,
                        #allow_edit => 1
                        no_column   => 1,
                        no_quick_search => 1,
                        no_multifilter  => 1
                     },
                  },
               },
            }, # (TableSpecs)
            #virtual_columns => {
            #   Employee => {
            #      full_name => {
            #         data_type => "varchar",
            #         is_nullable => 0,
            #         size => 255,
            #         sql => 'SELECT self.firstname || " " || self.lastname',
            #         set_function => sub {
            #            my ($row, $value) = @_;
            #            my ($fn, $ln) = split(/\s+/,$value,2);
            #            $row->update({ firstname=>$fn, lastname=>$ln });
            #         },
            #      },
            #   },
            #}, # (virtual_columns)
         }, # (DB)
      }, # (configs)
    }, # ('Plugin::RapidApp::RapidDbic')

};


$cfg{on_model} = {
   name => 'RA::ChinookDemo',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,


    'Model::DB' => {
      schema_class => 'RA::ChinookDemo::DB',
    
      connect_info => {
        dsn => 'dbi:SQLite:chinook.db',
        user => '',
        password => '',
        sqlite_unicode => q{1},
        on_connect_call => q{use_foreign_keys},
        quote_names => q{1},
      },

      RapidDbic => {
        grid_params => {
           '*defaults' => { # Defaults for all Sources
              updatable_colspec => ['*'],
              creatable_colspec => ['*'],
              destroyable_relspec => ['*']
           }, # ('*defaults')
           Album => {
              include_colspec => ['*','artistid.name'] 
           },
           Genre => {
              # Leave persist_immediately on without the add form
              # (inserts blank/default rows immediately):
              use_add_form => 0,
              # No delete confirmations:
              confirm_on_destroy => 0
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
           MediaType => {
              # Use the grid itself to set new row values:
              use_add_form => 0, #<-- also disables autoload_added_record
              persist_immediately => {
                 create  => 0,
                 update  => 1,
                 destroy => 1
              },
              # No delete confirmations:
              confirm_on_destroy => 0
           },
           Track => {
              include_colspec => ['*','albumid.artistid.*'],
              # Don't persist anything immediately:
              persist_immediately => {
                 # 'create => 0' changes these defaults:
                 #   use_add_form => '0' (normally 'tab')
                 #   autoload_added_record => 0 (normally '1')
                 create  => 0,
                 update  => 0,
                 destroy => 0
              },
              # Use the add form in a window:
              use_add_form => 'window'
           },
        }, # (grid_params)
        TableSpecs => {
           Album => {
              display_column => 'title'
           },
           Artist => {
              display_column => 'name'
           },
           Employee => {
              # Use virtual column 'full_name' as the display column:
              display_column => 'full_name'
           },
           Genre => {
              display_column => 'name',
              auto_editor_type => 'combo'
           },
           MediaType => {
              display_column => 'name',
              auto_editor_type => 'combo'
           },
           Track => {
              columns => {
                 bytes => {
                    renderer => 'Ext.util.Format.fileSize'
                 },
                 unitprice => {
                    renderer => 'Ext.util.Format.usMoney',
                    header   => 'Price',
                    width    => 50
                 },
                 name => {
                    header => 'Name', width => 140
                 },
                 albumid => {
                    header => 'Album', width => 130
                 },
                 mediatypeid => {
                    header => 'Media Type', width => 165
                 },
                 genreid => {
                    header => 'Genre', width => 110
                 },
                 playlist_tracks => {
                    sortable  => 0
                 },
                 milliseconds => {
                    hidden   => 1
                 },
                 composer => {
                    hidden   => 1,
                    no_quick_search => 1,
                    no_multifilter  => 1
                 },
                 trackid => {
                    #allow_add  => 1,
                    #allow_edit => 1
                    no_column   => 1,
                    no_quick_search => 1,
                    no_multifilter  => 1
                 },
              },
           },
        }, # (TableSpecs)
        #virtual_columns => {
        #   Employee => {
        #      full_name => {
        #         data_type => "varchar",
        #         is_nullable => 0,
        #         size => 255,
        #         sql => 'SELECT self.firstname || " " || self.lastname',
        #         set_function => sub {
        #            my ($row, $value) = @_;
        #            my ($fn, $ln) = split(/\s+/,$value,2);
        #            $row->update({ firstname=>$fn, lastname=>$ln });
        #         },
        #      },
        #   },
        #}, # (virtual_columns)
     }, # (DB)

  }
};



print Dump $cfg{$ARGV[0] || ''};
