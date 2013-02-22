use strict;
use warnings;
use ExtUtils::MakeMaker 6.58;
my $from = 'lib/App/pathed.pm';
WriteMakefile(
    ABSTRACT_FROM      => $from,
    "AUTHOR"           => 'Marcel Gruenauer <marcel@cpan.org>',
    "BUILD_REQUIRES"   => { 'Test::More' => '0' },
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => '6.58' },
    LICENSE            => 'perl',
    NAME               => 'App-pathed',
    EXE_FILES          => [qw(bin/pathed)],
    PREREQ_PM          => {
        'Getopt::Long' => 0,
        'Pod::Find'    => 0,
        'Pod::Usage'   => 0,
    },
    VERSION_FROM => $from,
    test         => { TESTS => 't/*.t' }
);
