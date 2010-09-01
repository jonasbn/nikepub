# $Id$

use strict;
use warnings;
use WWW::Nike::NikePlus::Public;
use Data::Dumper;
use Test::More tests => 9;
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
my $userid = '1755202461';

ok($nike = WWW::Nike::NikePlus::Public->new({ mech => $mech, userid => $userid }), 'calling constructor');

ok($data = $nike->retrieve(), 'calling retrieve');

ok($nike = WWW::Nike::NikePlus::Public->new({ mech => $mech, verbose => 1 }), 'calling contructor without specifying userid');

ok($data = $nike->retrieve({ userid => $userid }), 'calling retrieve with userid');

ok($nike = WWW::Nike::NikePlus::Public->new({ mech => $mech, userid => $userid }));

ok($data = $nike->retrieve());

$mech->set_false('get');

dies_ok { $data = $nike->retrieve(); } 'We die when unable to retrieve';

SKIP: {
    skip 'Please set TEST_INTEGRATION', 2 unless $TEST_INTEGRATION;

    ok($nike = WWW::Nike::NikePlus::Public->new({ userid => $userid }), 'calling constructor');
    ok($data = $nike->retrieve(), 'calling retrieve with proper access');
};