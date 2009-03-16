
package Class::Data::Remote::Entity;

use strict;
use warnings 'all';
use base 'Class::Data::Remote';


#==============================================================================
sub set_up_entity
{
  my ($class, $entity) = @_;
  
  # Get our columns:
  $class->_init_meta( $entity );
  $class->after_set_up_table;
  1;
}# end set_up_entity()


#==============================================================================
sub get_meta_columns
{
  my ($s, $schema, $entity) = @_;
  
  return {
    Primary   => [ $s->primary_field_name ],
    All       => [  ],
  };
  1;
}# end get_meta_columns()

1;# return true:

=pod

=head1 NAME

Class::Data::Remote::CPAN - Object-oriented interface to remote data sources.

=head1 DESCRIPTION

Class::Data::Remote::CPAN is a basic implementation of the Class::Data::Remote API.

This package provides a simple interface to query search.cpan.org using an
object-oriented interface.

=head1 AUTHOR

John Drago <jdrago_999@yahoo.com>

=head1 COPYRIGHT

Copyright 2009 John Drago <jdrago_999@yahoo.com> all rights reserved.

=head1 LICENSE

This software is free software and may be used and redistributed under the same
terms as Perl itself.

=cut

