use strict;
use warnings;

use RA::ChinookDemo;

my $app = RA::ChinookDemo->apply_default_middlewares(RA::ChinookDemo->psgi_app);
$app;

