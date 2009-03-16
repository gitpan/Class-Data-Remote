
package Class::Data::Remote;

use strict;
use warnings 'all';
use Carp 'confess';
use Class::Data::Remote::RootMeta;
use Class::Data::Remote::EntityMeta;
use Class::Data::Remote::Iterator;

$SIG{__DIE__} = \&Carp::confess;

use overload 
  '""'      => sub { eval { $_[0]->id } },
  bool      => sub { eval { $_[0]->id } },
  fallback  => 1;

BEGIN {
  use vars qw(
    $Weaken_Is_Available
    %Live_Objects
    $Connection
    $VERSION
    $meta
  );

  $VERSION = '0.003';
  
  $Weaken_Is_Available = 1;
  eval {
	  require Scalar::Util;
	  import Scalar::Util qw(weaken);
  };
  $Weaken_Is_Available = 0 if $@;
}# end BEGIN:


#==============================================================================
# Abstract methods:
sub has_a;
sub has_many;
sub after_set_up_entity { }


#==============================================================================
sub set_up_entity
{
  my ($class, $entity) = @_;
  
  # Get our columns:
  $class->_init_meta( $entity );
  $class->after_set_up_entity;
  1;
}# end set_up_entity()


#==============================================================================
# Properties:
sub schema { $_[0]->root_meta->schema }
sub dsn    { $_[0]->root_meta->dsn }
sub entity { $_[0]->meta->entity }


#==============================================================================
sub connection
{
  my $class = shift;
  
  if( $Connection && ! @_ )
  {
    return $Connection;
  }# end if()
  
  $Connection = $_[0];
  
  # Set up the root meta:
  no strict 'refs';
  ${ $class->root . '::root_meta' } = Class::Data::Remote::RootMeta->new( @_ );
  
  # Connect:
  undef(%Live_Objects);
  
  if( my $entity = eval { $class->meta->entity } )
  {
    $class->_init_meta( $entity );
  }# end if()
}# end connection()


#==============================================================================
sub id
{
  $_[0]->{__id};
}# end id()


#==============================================================================
sub primary_column
{
  my $s = shift;
  ( $s->columns('Primary') )[0];
}# end primary_column()


#==============================================================================
sub construct
{
  my ($s, $data) = @_;
  
  my $class = ref($s) ? ref($s) : $s;
  
  my $PK = $class->primary_column;
  my $key = join ':', grep { defined($_) } ( $s->root_meta->schema, $class, $data->{ $PK } );
  return $Live_Objects{$key} if $Live_Objects{$key};
  
  my $obj = bless {
    %$data,
    __id => $data->{ $PK },
  }, $class;
  $Live_Objects{$key} = $obj;
  weaken( $Live_Objects{$key} = $obj )
    if $Weaken_Is_Available;
  return $obj;
}# end construct()


#==============================================================================
sub columns
{
  my ($s) = shift;
  
  if( my $type = shift(@_) )
  {
    confess "Unknown column group '$type'" unless $type =~ m/^(All|Primary)$/;
    if( my @cols = @_ )
    {
      $s->meta->columns->{$type} = \@cols;
    }
    else
    {
      # Get: my ($PK) = $class->columns('Primary');
      return @{ $s->meta->columns->{$type} };
    }# end if()
  }
  else
  {
    
    return @{ $s->meta->{columns}->{All} };
  }# end if()
}# end columns()


#==============================================================================
sub meta
{
  my $class = shift;
  $class = ref($class) || $class;
  no strict 'refs';
  
  ${"$class\::meta"};
}# end _meta()


#==============================================================================
sub _init_meta
{
  my ($class, $entity) = @_;
  
  no strict 'refs';
  no warnings 'once';
  my $schema = $class->connection . "";
  ${"$class\::meta"} = Class::Data::Remote::EntityMeta->new( $class, $schema, $entity );
}# end _init_meta()


#==============================================================================
sub root
{
  __PACKAGE__;
}# end root()


#==============================================================================
sub root_meta
{
  my $s = shift;
  
  no strict 'refs';
  my $root = $s->root;

  ${"$root\::root_meta"};
}# end root_meta()


#==============================================================================
sub clear_object_index
{
  my $s = shift;
  
  my $class = ref($s) || $s;
  my $key_starter = $s->root_meta->schema . ":" . $class;
  map { delete($Live_Objects{$_}) } grep { m/^$key_starter\:\d+/ } keys(%Live_Objects);
}# end clear_object_index()


#==============================================================================
sub import
{
  my $class = shift;
  
  no strict 'refs';
  return unless my $parent = ( @{$class.'::ISA'} )[0];
  $class->_load_class( $parent );
  if( my $entity = eval { $parent->entity } )
  {
    $class->set_up_entity( $entity );
  }# end if()
}# end import()


#==============================================================================
sub _load_class
{
  my (undef, $class) = @_;
  
  (my $file = "$class.pm") =~ s/::/\//g;
  unless( $INC{$file} )
  {
    require $file;
    $class->import;
  }# end unless();
}# end _load_class()


#==============================================================================
sub AUTOLOAD
{
  my $s = shift;
  our $AUTOLOAD;
  my ($key) = $AUTOLOAD =~ m/([^:]+)$/;
  
warn "AUTOLOAD '$AUTOLOAD'";

  # Universal setter/getter:
  @_ ? $s->{$key} = shift : $s->{$key};
}# end AUTOLOAD()


#==============================================================================
sub DESTROY
{
  my $s = shift;
  
  undef(%$s);
}# end DESTROY()


1;# return true:

=pod

=head1 NAME

Class::Data::Remote - Object-oriented interface to remote data sources.

=head1 SYNOPSIS

  # TBD:

=head1 DESCRIPTION

Class::Data::Remote will provide an interface to access remote data sources.

=head1 AUTHOR

John Drago <jdrago_999@yahoo.com>

=head1 COPYRIGHT

Copyright 2009 John Drago <jdrago_999@yahoo.com> all rights reserved.

=head1 LICENSE

This software is free software and may be used and redistributed under the same
terms as Perl itself.

=cut

