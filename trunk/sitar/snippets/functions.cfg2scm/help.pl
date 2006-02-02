#
# help
#

sub si_print_version () {
	print "cfg2scm.pl -\tCheck configuration changes into SCM - Release ", $CFG2SCM_RELEASE, "-", $CFG2SCM_SVNVERSION, "\nCopyright (C) ", $CFG2SCM_COPYRIGHT, "\n";
}

sub si_print_help () {
	print "Options:
\t--base-url=<url>\tmain path to subversion repositories (mandatory)\n\t\t\t\tdefault: $CFG2SCM_OPT_BASE_URL
\t--repository=<name>\tname of the one repository to be used (mandatory)\n\t\t\t\tdefault: $CFG2SCM_OPT_REPOS
\t--debug
\t--check-consistency
\t--find-unpacked
\t--limit=<max filesize; 0=no limit>
\t--username=<username>
\t--password=<password>
\t--message=<commit msg>
\t--outfile=<file>
\t--storage=<svn|cvs|tar|tar.gz|tar.bz2>
\t--help\t\t\tthis page
\t--version\t\tprintout CFG2SCM version";
}

sub si_warn_no_root() {
	print "Attention:
\tyou have choosen to run the program as non-root-user;
\tthis is for testing purposes only.\n"
}

sub si_attention_no_config() {
	print "Attention:
\tyou have to set at least the 'storage' type,
\teither on the commandline or in the configuration-file
\t\t$CFG2SCM_CONFIG_FILE
\tFor storage types 'cvs' or 'svn', please also provide
\t'base-url' and 'repository'.\n";
}

