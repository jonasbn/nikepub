# $Id$

use strict;
use warnings;
use WWW::Nike::NikePlus::Public;
use Data::Dumper;
use Test::More tests => 4;
use Env qw($TEST_INTEGRATION);
use Test::MockObject::Extends;
use File::Slurp qw(slurp);
use Carp qw(croak);
use Test::Exception;

my $mech = Test::MockObject::Extends->new('WWW::Mechanize');

$mech->mock(
    'content',
    sub {
        my ( $mb, %params ) = @_;

        my $content = slurp('data/data.xml')
            || croak "Unable to read file - $!";

        return $content;
    }
);
$mech->set_true('get');

my $data;
my $nike;

$nike = WWW::Nike::NikePlus::Public->new({ mech => $mech, userid => 1755202461 });

ok($data = $nike->retrieve());

$nike = WWW::Nike::NikePlus::Public->new({ mech => $mech, verbose => 1 });

ok($data = $nike->retrieve({ userid => 1755202461 }));

$nike = WWW::Nike::NikePlus::Public->new({ mech => $mech, userid => 1755202461 });

ok($data = $nike->retrieve());

$mech->set_false('get');

dies_ok { $data = $nike->retrieve(); } 