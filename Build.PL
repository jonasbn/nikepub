# Build.PL for Spilpriser

# $Id$

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@cpan.org>',
    module_name          => 'WWW::Nike::NikePlus::Public',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
    configure_requires   => {},
    build_requires       => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
    },
    requires => {
        'Test::More'                => '0', 
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
        'Env'                       => '0',
        'Module::Build'             => '0.30',
        'Data::Dumper'           => '0',    #Debugging
        'WWW::Mechanize'         => '0',
        'Carp'                   => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://logicLAB.jira.com/browse/NIKEPUB',
            repository => 'http://logicLAB.jira.com/svn/NIKEPUB',
        }
    },

);

$build->create_build_script();

1;
