#!/usr/local/bin/perl

use strict;
use warnings;

use WWW::Nike::NikePlus::Public;

my $nike = WWW::Nike::NikePlus::Public->new({
    userid  => 1755202461,
    verbose => 1,
});
my $xml = $nike->retrieve();

print STDERR $xml;