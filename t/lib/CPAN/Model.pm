
package CPAN::Model;

use strict;
use warnings 'all';
use base 'Class::Data::Remote';
use CPAN::Connection;
use LWP::UserAgent;


__PACKAGE__->connection(
  CPAN::Connection->new()
);


__PACKAGE__->root_meta->{ua} = LWP::UserAgent->new();

1;# return true:

