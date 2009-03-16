
package Class::DBI::Lite::Iterator;

use strict;
use warnings 'all';

#==============================================================================
sub new
{
  my ($class, $data) = @_;
  
  return bless {
    data => $data,
    count => scalar(@$data),
    idx   => 0
  }, $class;
}# end new()


#==============================================================================
sub first
{
  $_[0]->{data}->[0];
}# end first()


#==============================================================================
# TODO: Set up an event system that will trigger when we reach the end of the 
#       current resultset vs when we actually run out of results:
sub next
{
  my $s = shift;
  return unless $s->{idx} < $s->{count};
  $s->{data}->[ $s->{idx}++ ];
}# end next()


#==============================================================================
sub count
{
  $_[0]->{count};
}# end count()


#==============================================================================
sub reset
{
  $_[0]->{idx} = 0;
}# end reset()

1;# return true:

__END__

=pod

=head1 NAME

Class::Data::Remote::Iterator - Simple iterator for Class::Data::Remote

=head1 SYNOPSIS

  # TBD

=head1 DESCRIPTION

Provides a simple iterator-based approach to Class::Data::Remote resultsets.

=head1 PUBLIC PROPERTIES

=head2 count

Returns the number of records in the Iterator.

=head1 PUBLIC METHODS

=head2 next

Returns the next object in the series, or undef.

Moves the internal cursor to the next object if one exists.

=head2 reset

Resets the internal cursor to the first object if one exists.

=head1 SEE ALSO

L<Class::Data::Remote>

=head1 AUTHOR

John Drago <jdrago_999@yahoo.com>.

=head1 LICENSE AND COPYRIGHT

Copyright 2008 John Drago <jdrago_999@yahoo.com>.  All rights reserved.

This software is Free software and may be used and distributed under the same 
terms as perl itself.

=cut

