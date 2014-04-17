package ModuleOrPrefix::Path;

use 5.010001;
use strict;
use warnings;
use File::Basename 'dirname';

# VERSION
# DATE

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(module_or_prefix_path);

my $SEPARATOR;

BEGIN {
    if ($^O =~ /^(dos|os2)/i) {
        $SEPARATOR = '\\';
    } elsif ($^O =~ /^MacOS/i) {
        $SEPARATOR = ':';
    } else {
        $SEPARATOR = '/';
    }
}

sub module_or_prefix_path {
    my $module = shift;
    my $relpath;
    my $fullpath;

    ($relpath = $module) =~ s/::/$SEPARATOR/g;
    $relpath .= '.pm' unless $relpath =~ m!\.pm$!;

    my $relpathp = $relpath;
    $relpathp =~ s/\.pm$//;

    for my $which ('f', 'd') {
        foreach my $dir (@INC) {
            next if ref($dir);

            if ($which eq 'f') {
                $fullpath = $dir . $SEPARATOR . $relpath;
                return $fullpath if -f $fullpath;
            } else {
                $fullpath = $dir . $SEPARATOR . $relpathp;
                return $fullpath . $SEPARATOR if -d $fullpath;
            }
        }
    }

    return undef;
}

1;
# ABSTRACT: Get the full path to a locally installed module or prefix

=head1 SYNOPSIS

 use ModuleOrPrefix::Path qw(module_or_prefix_path);

 say module_or_prefix_path('Test::More');  # "/path/to/Test/More.pm"
 say module_or_prefix_path('Test');        # "/path/to/Test.pm"
 say module_or_prefix_path('File::Slurp'); # "/path/to/File/Slurp.pm"
 say module_or_prefix_path('File');        # "/path/to/File/"
 say module_or_prefix_path('Foo');         # undef


=head1 DESCRIPTION

The code is based on Neil Bower's L<Module::Path>.


=head1 FUNCTIONS

=head2 module_or_prefix_path($mod) => STR


=head1 SEE ALSO

L<Module::Path>

=cut
