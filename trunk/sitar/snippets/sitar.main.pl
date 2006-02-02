
#
#	MAIN
#
{
	# read configuration file
	si_parse_conf_file( $SITAR_CONFIG_FILE );
	# parse command line options
	GetOptions(
		'f|format=s'          => \$SITAR_OPT_FORMAT,
		'o|outfile=s'         => \$SITAR_OPT_OUTFILE,
		'c|check-consistency' => \$SITAR_OPT_CONSISTENCY,
		'f|find-unpacked'     => \$SITAR_OPT_FINDUNPACKED,
		'h|help'              => \$SITAR_OPT_HELP,
		'v|version'           => \$SITAR_OPT_VERSION
	);
	my @myname = split /\//, $0;
	if ( $< != 0 ) {
		print( "Please run sitar as user root.\n" );
		exit;
	}
	if ( $SITAR_OPT_FINDUNPACKED ) {
		print( "Finding unpackaged files below /etc/. This might need a long time...\n" );
		si_find_unpacked( $SITAR_CONFIG_DIR, $SITAR_UNPACKED_FN, "/etc/", 1 );
	}
	if ( $SITAR_OPT_CONSISTENCY ) {
		print( "Checking consistency of configuration files. This might need a long time...\n" );
		si_check_consistency( $SITAR_CONFIG_DIR, $SITAR_CONSIST_FN, 1 );
	}
	if ( ( ( $myname[ -1 ] eq "sitar.pl" ) || ( $myname[ -1 ] eq "sitar" ) ) && ( !$SITAR_OPT_HELP ) && ( !$SITAR_OPT_FORMAT ) && ( !$SITAR_OPT_OUTFILE ) && ( !$SITAR_OPT_VERSION ) ) {
		@SITAR_OPT_FORMATs = ( "html", "tex", "sdocbook", "yast1", "yast2" );
		( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime( time );
		$SITAR_OPT_OUTDIR = join "", "/tmp/sitar-", $HOSTNAME, "-", $year + 1900, sprintf( "%02d", $mon + 1 ), sprintf( "%02d", $mday ), sprintf( "%02d", $hour );
		mkdir $SITAR_OPT_OUTDIR;
		chdir $SITAR_OPT_OUTDIR;
		for $mm ( @SITAR_OPT_FORMATs ) {
			$SITAR_OPT_FORMAT     = $mm;
			$output_buffer_g      = "";
			$toc_buffer_g         = "";
			$toc_last_toc_level_g = 0;
			if ( $SITAR_OPT_FORMAT eq "yast1" ) {
				$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME-yast1.sel";
			} elsif ( $SITAR_OPT_FORMAT eq "yast2" ) {
			} else {
				if ( $SITAR_OPT_FORMAT eq "latex" ) {
					$SITAR_OPT_FORMAT = "tex";
					$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME.tex";
				} elsif ( $SITAR_OPT_FORMAT eq "sdocbook" ) {
					$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME.sdocbook.xml";
				} else {
					$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME.$mm";
				}
			}
			si_run_sitar();
		}
		chdir $CWD;
	} elsif ( $SITAR_OPT_FORMAT eq "yast2" ) {
		if ( ( -d $SITAR_OPT_OUTFILE ) && ( !$SITAR_OPT_HELP ) && ( !$SITAR_OPT_VERSION ) ) {
			$SITAR_OPT_OUTDIR = $SITAR_OPT_OUTFILE;
			si_run_sitar();
		} else {
			si_print_help();
		}
	} elsif ( $SITAR_OPT_FORMAT && $SITAR_OPT_OUTFILE && ( !$SITAR_OPT_HELP ) && ( !$SITAR_OPT_VERSION ) ) {
		si_run_sitar();
	} elsif ( $SITAR_OPT_VERSION ) {
		si_print_version();
	} elsif ( ( $SITAR_OPT_FORMAT && ( !$SITAR_OPT_OUTFILE ) ) || ( ( !$SITAR_OPT_FORMAT ) && $SITAR_OPT_OUTFILE ) || $SITAR_OPT_HELP ) {
		si_print_help();
	}
}
#

