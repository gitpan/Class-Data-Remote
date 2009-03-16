use strict;
use warnings;
use inc::Module::Install;
use 5.008005;

name 'Class-Data-Remote';
perl_version '5.008001';
license 'perl';
all_from 'lib/Class/Data/Remote.pm';

requires  'LWP::UserAgent';

test_requires 'Test::More'  => '0.77';

tests_recursive();
WriteAll();

