
package Class::Data::Remote::Connection;

use strict;
use warnings 'all';
use Carp 'confess';


#==============================================================================
sub new
{
  my ($class, %args) = @_;
  
  foreach( $class->constructor_args )
  {
    confess "Required param '$_' was not provided"
      unless defined( $args{ $_ } );
  }# end foreach()
  
  return bless \%args, ref($class) ? ref($class) : $class;
}# end new()


#==============================================================================
sub retrieve;
sub search;


#==============================================================================
sub constructor_args { return qw/ / }

1;# return true:

