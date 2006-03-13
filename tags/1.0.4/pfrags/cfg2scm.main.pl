#
# MAIN
#
{
	si_prepare_config();
	if ( $CFG2SCM_OPT_NON_ROOT eq "Yes" ) {
		si_warn_no_root();
	} else {
		my @myname = split /\//, $0;
		if ( $< != 0 ) {
			print( "Please run cfg2scm.pl as user root.\n" );
			exit;
		}
	}
	if ( $CFG2SCM_OPT_CONSISTENCY ) {
		print( "Checking consistency of configuration files. This might need a long time...\n" );
		si_check_consistency( $CFG2SCM_CONFIG_DIR, $CFG2SCM_CONSISTENCY_FILENAME, $CFG2SCM_OPT_DEBUG );
	}
	if ( $CFG2SCM_OPT_FINDUNPACKED ) {
		print( "Finding unpackaged files below /etc/. This might need a long time...\n" );
		si_find_unpacked( $CFG2SCM_CONFIG_DIR, $CFG2SCM_FINDUNPACKED_FILENAME, "/etc/", 1 );
	}
	if ( $CFG2SCM_OPT_VERSION ) {
		si_print_version();
	} elsif ( $CFG2SCM_OPT_HELP ) {
		si_print_help();
	} elsif ( ( !$CFG2SCM_OPT_STORAGE ) && ( ( ( !$CFG2SCM_OPT_BASE_URL ) && ( !$CFG2SCM_OPT_REPOS ) ) || ( !$CFG2SCM_OPT_OUTFILE ) ) ) {
		si_attention_no_config();
		si_print_help();
	} else {
		si_prepare();
		if ( !si_read_and_eval_includes() ) {
			if ( $CFG2SCM_OPT_STORAGE eq "svn" ) {
				si_commit_svn();
			} elsif ( $CFG2SCM_OPT_STORAGE eq "cvs" ) {
				si_commit_cvs();
			} elsif (  ( $CFG2SCM_OPT_STORAGE eq "tar" )
				|| ( $CFG2SCM_OPT_STORAGE eq "tar.gz" )
				|| ( $CFG2SCM_OPT_STORAGE eq "tar.bz2" ) ) {
				si_store_tar();
			}
		}
	}
}
