
#
#	help
#
sub si_print_version () {
	print "SITAR -\tSystem InformaTion At Runtime - Release ", $SITAR_RELEASE, "-", $SITAR_SVNVERSION, "\nCopyright (C) ", $SITAR_COPYRIGHT, "\n";
}

sub si_print_help () {
	print "Options available:
\t--format=<format>\tFormats: html, tex, sdocbook, yast1, yast2
\t--outfile=<file|dir>\toutput filename (without: stdout)
\t\t\t\tfor format 'yast2' outfile must be a directory
\t--check-consistency
\t--find-unpacked
\t--help\t\t\tthis page
\t--version\t\tprintout SITAR version";
}

