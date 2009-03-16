#!/usr/bin/perl -w

use strict;
use warnings 'all';
use lib qw( t/lib ../t/lib );
use Test::More 'no_plan';

use_ok('CPAN::Author');

is_deeply [ CPAN::Author->columns ] => [qw/
  authorid
  name
  email
  url
  homepage
/];

my $auth = CPAN::Author->retrieve( 'johnd' );
is_deeply { %$auth }, {
 'homepage' => 'http://www.devstack.com',
 'email' => 'jdrago_999@yahoo.com',
 'url' => 'http://search.cpan.org/~johnd',
 'name' => 'John Drago',
 'authorid' => 'johnd'
};

