# Build.PL for WWW::Nike::NikePlus::Public

# $Id$

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@cpan.org>',
    module_name          => 'WWW::Nike::NikePlus::Public',
    license              => 'perl',
    recursive_test_files => 1,
    create_makefile_pl => 'traditional',
    create_readme        => 1,
    configure_requires   => {},
    requires => {
        'Test::More'                => '0',
        'File::Slurp'               => '0',
        'Test::Exception'           => '0',
        'Test::MockObject::Extends' => '0',
        'Env'                       => '0',
        'Module::Build'             => '0.30',
        'WWW::Mechanize'            => '0',
        'Carp'                      => '0',
        'Class::Accessor'           => '0',
        'Params::Validate'          => '0',
        'English'                   => '0',
    },
    recommends => {
        'Test::Perl::Critic'        => '0',
        'Test::Prereq::Build'       => '0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://logiclab.jira.com/wiki/display/NIKEPUB/Home',
            bugtracker =>
                'http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Nike-NikePlus-Public',
            repository => 'http://logicLAB.jira.com/svn/NIKEPUB',
            ProjectChangelog =>
                'http://logiclab.jira.com/browse/NIKEPUB#selectedTab=com.atlassian.jira.plugin.system.project%3Achangelog-panel',
            ProjectSite => 'http://logicLAB.jira.com/browse/NIKEPUB',
            ProjectWiki => 'http://logiclab.jira.com/wiki/display/NIKEPUB/Home',
        }
    },

);

$build->create_build_script();
