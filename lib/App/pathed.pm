package App::pathed;
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Pod::Find qw(pod_where);
our $VERSION = '0.01';

sub usage {
    pod2usage(-input => pod_where({ -inc => 1 }, __PACKAGE__), @_);
}

sub run {
    GetOptions(
        'delete|d=s@'  => \(my $deletes),
        'append|a=s@'  => \(my $appends),
        'prepend|p=s@' => \(my $prepends),
        'unique|u'     => \(my $unique),
        'split|s'      => \(my $split),
        'check|c'      => \(my $check),
        'help|h'       => \(my $help),
        'man'          => \(my $man),
    ) or usage(-exitval => 2);
    usage(-exitval => 1) if $help;
    usage(-exitval => 0, -verbose => 2) if $man;
    usage(-exitval => 2, -msg => '--split and --check are mutually exclusive')
      if $split && $check;
    my @parts = split /:/ => $ENV{PATH};
    if ($appends) {
        push @parts, @$appends;
    }
    if ($prepends) {
        unshift @parts, reverse @$prepends;
    }
    if ($deletes) {
        for my $delete (@$deletes) {
            @parts = grep { index($_, $delete) == -1 } @parts;
        }
    }
    if ($unique) {
        my %seen;
        @parts = grep { !$seen{$_}++ } @parts;
    }
    if ($check) {
        my %seen;
        for my $part (@parts) {
            next if $seen{$part}++;
            unless (-d $part) {
                warn "$part is not a directory\n";
                next;
            }
            unless (-r $part) {
                warn "$part is not readable\n";
                next;
            }
        }
    } elsif ($split) {
        print "$_\n" for @parts;
    } else {
        print join ':' => @parts;
        print "\n";
    }
}
1;

=pod

=head1 NAME

App::pathed - munge the Bash PATH environment variable

=head1 SYNOPSIS

    # PATH=$(pathed --unique --delete rbenv)
    # PATH=$(pathed --append /home/my/bin -a /some/other/bin)
    # PATH=$(pathed --prepend /home/my/bin -p /some/other/bin)
    # for i in $(pathed --split); do ...; done
    # pathed --check
    # pathed --man

=head1 DESCRIPTION

The Bash C<PATH> environment variable contains a colon-separated list of paths.
C<pathed> - "path editor" - can split the path, append, prepend or remove
elements, remove duplicates and reassemble it.

The result is then printed so you can assign it to the C<PATH> variable. If
C<--split> is used, each path element is printed on a separate line, so you can
iterate over them, for example.

The path elements can also be checked with C<--check> to make sure that the
indicated directories exist and are readable.

The following command-line options are supported:

=over 4

=item --append, -a <path>

Appends the given path to the list of path elements. This option can be
specified several times; the paths are appended in the given order.

=item --prepend, -p <path>

Prepends the given path to the list of path elements. This option can be
specified several times; the paths are prepended in the given order. For
example:

    pathed -p first -p second -p third

will result in C<third:second:first:$PATH>.

=item --delete, -d <substr>

Deletes those path elements which contain the given substring. This option can
be specified several times; the path elements are deleted in the given order.

When options are mixed, C<--append> is processed first, then C<--prepend>, then
C<--delete>.

=item --unique, -u

Removes duplicate path elements.

=item --split, -s

Prints each path element on its own line. If this option is not specified, the
path elements are printed on one line, joined by colons, like you would
normally specify the C<PATH> variable.

=item --check, -c

Checks whether each path element is a readable directory and prints warnings if
necessary. Warnings are printed only once per path element, even if that
element occurs several times in C<PATH>.

When C<--check> is used, the path is not printed. C<--check> and C<--split> are
mutually exclusive.

=item --help, -h

Prints the synopsis.

=item man

Prints the whole documentation.

=back

=head1 WHY pathed?

The initial motivation for writing C<pathed> came when I tried to install
C<vim> with C<homebrew> while C<rbenv> was active. C<vim> wanted to be compiled
with the system ruby, so I was looking for a quick way to remove C<rbenv> from
the C<PATH>:

    PATH=$(pathed -d rbenv) brew install vim

=head1 AUTHORS

The following person is the authors of all the files provided in this
distribution unless explicitly noted otherwise.

Marcel Gruenauer <marcel@cpan.org>, L<http://marcelgruenauer.com>

=head1 COPYRIGHT AND LICENSE

The following copyright notice applies to all the files provided in this
distribution, including binary files, unless explicitly noted otherwise.

This software is copyright (c) 2013 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.
