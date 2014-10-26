# NAME

App::pathed - munge the Bash PATH environment variable

# SYNOPSIS

    # PATH=$(pathed --unique --delete rbenv)
    # PATH=$(pathed --append /home/my/bin -a /some/other/bin)
    # PATH=$(pathed --prepend /home/my/bin -p /some/other/bin)
    # for i in $(pathed --split); do ...; done
    # pathed --check
    # pathed --man

# DESCRIPTION

The Bash `PATH` environment variable contains a colon-separated list of paths.
`pathed` - "path editor" - can split the path, append, prepend or remove
elements, remove duplicates and reassemble it.

The result is then printed so you can assign it to the `PATH` variable. If
`--split` is used, each path element is printed on a separate line, so you can
iterate over them, for example.

The path elements can also be checked with `--check` to make sure that the
indicated directories exist and are readable.

The following command-line options are supported:

- \--append, -a <path>

    Appends the given path to the list of path elements. This option can be
    specified several times; the paths are appended in the given order.

- \--prepend, -p <path>

    Prepends the given path to the list of path elements. This option can be
    specified several times; the paths are prepended in the given order. For
    example:

        pathed -p first -p second -p third

    will result in `third:second:first:$PATH`.

- \--delete, -d <substr>

    Deletes those path elements which contain the given substring. This option can
    be specified several times; the path elements are deleted in the given order.

    When options are mixed, `--append` is processed first, then `--prepend`, then
    `--delete`.

- \--unique, -u

    Removes duplicate path elements.

- \--split, -s

    Prints each path element on its own line. If this option is not specified, the
    path elements are printed on one line, joined by colons, like you would
    normally specify the `PATH` variable.

- \--check, -c

    Checks whether each path element is a readable directory and prints warnings if
    necessary. Warnings are printed only once per path element, even if that
    element occurs several times in `PATH`.

    When `--check` is used, the path is not printed. `--check` and `--split` are
    mutually exclusive.

- \--help, -h

    Prints the synopsis.

- man

    Prints the whole documentation.

# WHY pathed?

The initial motivation for writing `pathed` came when I tried to install
`vim` with `homebrew` while `rbenv` was active. `vim` wanted to be compiled
with the system ruby, so I was looking for a quick way to remove `rbenv` from
the `PATH`:

    PATH=$(pathed -d rbenv) brew install vim

# AUTHORS

The following person is the authors of all the files provided in this
distribution unless explicitly noted otherwise.

Marcel Gruenauer <marcel@cpan.org>, [http://marcelgruenauer.com](http://marcelgruenauer.com)

# COPYRIGHT AND LICENSE

The following copyright notice applies to all the files provided in this
distribution, including binary files, unless explicitly noted otherwise.

This software is copyright (c) 2013 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.
