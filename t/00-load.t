#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::Nike::NikePlus::Public' );
}

diag( "Testing WWW::Nike::NikePlus::Public $WWW::Nike::NikePlus::Public::VERSION, Perl $], $^X" );
