
package CPAN::Author;

use strict;
use warnings 'all';
use base 'CPAN::Model';
use HTTP::Request::Common;

__PACKAGE__->set_up_entity('authors');

__PACKAGE__->columns( Primary => 'authorid' );
__PACKAGE__->columns( All => qw/
  authorid
  name
  email
  url
  homepage
/);


#==============================================================================
sub retrieve
{
  my ($class, $id) = @_;
  
  my $url = "http://search.cpan.org/~$id";
  my $res = $class->root_meta->ua->request(
    GET $url
  );
  
  return unless $res->is_success;
  return if $res->content =~ m{
    Cannot find PAUSE ID '<b>$id</b>', maybe you meant one of these<br>
    \s+
    No matches
  }xim;
  
  my $struct = {
    authorid  => $id,
    name      => undef,
    email     => undef,
    url       => $url,
    homepage  => undef,
  };
  
  ($struct->{name}) = $res->content =~ m/<title>([\w\s]+)\s+\-\s+search\.cpan\.org\s*<\/title>/;
  ($struct->{email}) = $res->content =~ m/mailto\:(.*?)"/;
  ($struct->{homepage}) = $res->content =~ m{
   <td\s+class\=label>Homepage</td>
   \s+
   <td\s+class\=cell><a\s+href="(http://.*?)"\s+rel="me">.*?</a></td>
  }xim;
  
  return bless $struct, ref($class) || $class;
}# end retrieve()

1;# return true:

