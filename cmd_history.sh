 # -- RapidApp "Chinook" Video Demo Series --
 # 
 #     (www.rapidapp.info/demos/chinook)
 #
 # Part 1. Intro and Setup
 #
 # * In this demo we will:
 #    * Build a new webapp from scratch, using RapidApp
 #    * Around the "Chinook" sample database
 #       (http://chinookdatabase.codeplex.com/)
 #    * Focus on database features using the "RapidDbic" plugin
 #       (grids, CRUD, query builder, custom views, etc)
 #    * Record all commands & changes real-time in Git
 #       (https://github.com/IntelliTree/RA-ChinookDemo) 
 #    * All steps performed live/real-world within this shell
 #       (SSH session on an ordinary Linux box)
 #
 # -->
###################################################################
#   +++ COMMAND LOG/HISTORY FOR THIS SHELL (to follow along) +++
#
# github.com/IntelliTree/RA-ChinookDemo/blob/master/cmd_history.sh
#
###################################################################
 # --
 #
 # Agenda/Outline:
 #
 # Part 1 ($self)
 #   * Intro, agenda, prerequisite knowledge, etc
 #   * RapidApp installation
 #   * Create a new skeleton Catalyst app
 #   * Setup Git and Commit shortcuts
 #   * Download the chinook database from the web
 #   * Setup Catalyst DBIC Model for the database
 #   git tag: 01_prepared_app
 #
 # Part 2 (RapidDbic Basics)
 #   * Enable RapidDbic Plugin
 #   * Demo main out-of-the-box features
 #     * Schema-based interfaces, grids, searching, reports, etc
 #   * Relationships
 #   * Editing (CRUD)
 #   * Interface options
 #   * Virtual Columns
 #   git tag: 02_rapiddbic_basics
 #
 # Part 3 (User Authentication and Saved Views)
 #   * AuthCore Plugin
 #     * Instant user db, sessions, authentication
 #   * User management
 #   * NavCore Plugin
 #     * Saved Views (per-user and public)
 #     * Manageable navigation tree (drag/drop)
 #   git tag: 03_auth_and_saved_views
 #
 # Part 4 and Beyond
 #   * Extension and Customization
 #   * Templates
 #   * Integrating normal Catalyst Controllers/Views
 #   * Asset management (CSS, JavaScript, Images)
 #   * Etc...
 #
 # "Living" Demo
 #   * New sections added on an ongoing basis
 #   * Future topics and examples in branches
 #
 # ----
 #
 #
 # Prerequisite Knowledge:
 #
 # * You should already know about:
 #    *  Perl
 #    *  Catalyst
 #    *  DBIx::Class (aka "DBIC")
 #    *  Relational database concepts
 #    *  Git
 #
 # ----
clear
 # Install the latest RapidApp (and its dependencies):
cpanm RapidApp 
 #
 # --> (Side note: if you don't have "cpanm")
 #
 #   cpan App::cpanminus # <-- install cpanminus
 #   (see also http://metacpan.org/module/App::cpanminus)
 #
 # --
 #
clear
 # Create new Catalyst app "RA::ChinookDemo":
catalyst.pl RA::ChinookDemo 
cd RA-ChinookDemo/  # <-- Enter the new app directory
 #
 # Initialize git repo and setup remote (on Github)
git init 
git remote add origin \
   git@github.com:IntelliTree/RA-ChinookDemo.git
 #
 # Setup 'Commit' alias/shortcut:
alias Commit='\
    history -a cmd_history.sh && \
    RestoreHistNewlines cmd_history.sh && \
    git add --all && \
    git commit -m'
 #
 # Setup 'RestoreHistNewlines' alias (used in 'Commit' above):
alias RestoreHistNewlines='\
  sed -i -e \
   '"'"'/\\$/,/[^\\]$/{p;d;};/^[a-z]/s/ \( \) *\([^#]\)/ \\\n \1 \2/g'"'"''
 #
 # ^^ 'sed' command puts newlines back for multi-line commands 
 #    that use backslash (\) to escape newlines. They get stripped
 #    by the shell when recorded in the history file, and this
 #    puts them back... 
 #    This is just for readability in cmd_history.sh
 #
 #
 # Now we can record progress & history in a simple one-liner:
Commit 'first commit - freshly created Catalyst app'
clear
 # Download the Chinook sample database:
 # (http://chinookdatabase.codeplex.com/)
mkdir sql
cp ../Chinook1.4_Sqlite/Chinook_Sqlite_AutoIncrementPKs.sql sql/
ls -lh sql/Chinook_Sqlite_AutoIncrementPKs.sql
 #
 # Create new SQLite database (takes ~ 10 minutes)
time sqlite3 chinook.db < sql/Chinook_Sqlite_AutoIncrementPKs.sql
 #
Commit 'setup chinook SQLite database'
 #
 # Create DBIC schema/model (using the Catalyst Helper)
 # -See: metacpan.org/module/Catalyst::Helper::Model::DBIC::Schema
script/ra_chinookdemo_create.pl \
   model DB \
   DBIC::Schema \
   RA::ChinookDemo::DB \
   create=static generate_pod=0 \
   dbi:SQLite:chinook.db \
   sqlite_unicode=1 \
   on_connect_call='use_foreign_keys' \
   quote_names=1  #<-- required for RapidApp 
 #
Commit 'Created DBIC schema/model "DB"'
 #
Commit '01_prepared_app'
git tag 01_prepared_app
# Push to Github (First push, with tags):
git push -u --tags origin master 
 #
 # --- END PART 1 ---
clear
 # -- RapidApp "Chinook" Video Demo Series --
 # 
 #     (www.rapidapp.info/demos/chinook)
 #
 #  Part 2. RapidDbic Basics
 #
 # * Progress so far, from Part 1:
 #   * Created 'RA::ChinookDemo' with catalyst.pl
 #   * Setup SQLite database 'chinook.db'
 #      (http://chinookdatabase.codeplex.com/)
 #   * Created Catalyst model 'DB' (DBIC::Schema)
 #   * Setup git (https://github.com/IntelliTree/RA-ChinookDemo)
 #   * 'Commit' shell alias - records cmd history with changes
 #      (cmd_history.sh)
 #
 # ----
 #
git --no-pager log --oneline --reverse
git tag
 #
 # To jump straight to this point from scratch:
 #
 #   git clone https://github.com/IntelliTree/RA-ChinookDemo
 #   cd RA-ChinookDemo
 #   git checkout 01_prepared_app
 #
 #
 # Configure bare-bones RapidDbic:
vim lib/RA/ChinookDemo.pm
 #
 # Remove the auto-generated Root Controller:
 # - Needed because local app controllers always take precidence
rm -f lib/RA/ChinookDemo/Controller/Root.pm
Commit '(1) - Bare-bones working app (RapidDbic)'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Configure joined columns
vim lib/RA/ChinookDemo.pm
Commit '(2) - example joined columns (grid configs)'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Set 'display_column' for Sources
vim lib/RA/ChinookDemo.pm
Commit '(3) - configured display_columns (TableSpecs)'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Enable grid editing
vim lib/RA/ChinookDemo.pm
Commit '(4) - turned on grid editing for all Sources'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Configure editing across relationships
vim lib/RA/ChinookDemo.pm
Commit '(5) - Example editing across relationships'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Set certain Sources to be dropdowns 
vim lib/RA/ChinookDemo.pm
Commit '(6) - set auto_editor_type (combo) + column TableSpecs'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Set custom CRUD options
vim lib/RA/ChinookDemo.pm
Commit '(7) - configured various CRUD options'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Setup a virtual column
vim lib/RA/ChinookDemo.pm
Commit '(8) - created "full_name" virtual column'
 # Start the test server:
script/ra_chinookdemo_server.pl
 #
 # Make virtual column writable
vim lib/RA/ChinookDemo.pm
Commit '(9) - full_name virtual column writable + display_column'
 # Start the test server:
script/ra_chinookdemo_server.pl
clear
Commit '02_rapiddbic_basics'
