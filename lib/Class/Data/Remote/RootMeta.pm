
package Class::Data::Remote::RootMeta;

use strict;
use warnings 'all';

our %instances = ( );


#==============================================================================
sub new
{
  my ($s, $connection) = @_;
  
  if( my $inst = $instances{"$connection"} )
  {
    return $inst;
  }
  else
  {
    return $instances{"$connection"} = bless {
      dsn           => "$connection",      # Global
      schema        => "$connection", # Global
    }, ref($s) || $s;
  }# end if()
}# end new()


#==============================================================================
sub AUTOLOAD
{
  my $s = shift;
  our $AUTOLOAD;
  my ($key) = $AUTOLOAD =~ m/([^:]+)$/;
  
  # Universal setter/getter:
  @_ ? $s->{$key} = shift : $s->{$key};
}# end AUTOLOAD()

1;# return true:

