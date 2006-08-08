#
#	MAIN
#
{
	si_prepare_config();
	my @myname = split /\//, $0;
	if ( $< != 0 ) {
		print( STDERR "Please run sitar as user root.\n" );
		exit;
	}
	if ( $SITAR_OPT_FINDUNPACKED || $SITAR_OPT_ALL ) {
		print( STDERR "Finding unpackaged files below /etc/...\n" );
		si_find_unpacked( $SITAR_CONFIG_DIR, $SITAR_UNPACKED_FN, "/etc/", 1 );
	}
	if ( $SITAR_OPT_CONSISTENCY || $SITAR_OPT_ALL ) {
		print( STDERR "Checking consistency of configuration files...\n" );
		si_check_consistency( $SITAR_CONFIG_DIR, $SITAR_CONSIST_FN, 1 );
	}
	( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime( time );
	$SITAR_OPT_OUTDIR = join "", "/tmp/sitar-", $HOSTNAME, "-", $year + 1900, sprintf( "%02d", $mon + 1 ), sprintf( "%02d", $mday ), sprintf( "%02d", $hour );
	mkdir $SITAR_OPT_OUTDIR;
	chdir $SITAR_OPT_OUTDIR;
	if ( ( ( $myname[ -1 ] eq "sitar.pl" ) || ( $myname[ -1 ] eq "sitar" ) ) 
	     && ( !$SITAR_OPT_HELP ) 
	     && ( !$SITAR_OPT_FORMAT ) 
	     && ( !$SITAR_OPT_OUTFILE ) 
	     && ( !$SITAR_OPT_VERSION ) ) {
		$SITAR_OPT_FORMAT="all";
		si_run_structured( );
		for $ff ( @SITAR_SELFILES ) {
			if ( $ff eq "yast1" ) {
				$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME-yast1.sel";
			}
			si_run_selfiles( $ff );
		}
	} elsif ( $SITAR_OPT_FORMAT eq "yast2" ) {
		if ( ( -d $SITAR_OPT_OUTFILE ) && ( !$SITAR_OPT_HELP ) && ( !$SITAR_OPT_VERSION ) ) {
			$SITAR_OPT_OUTDIR = $SITAR_OPT_OUTFILE;
			si_run_selfiles( $SITAR_OPT_FORMAT );
		} else {
			si_print_help();
		}
	} elsif ( $SITAR_OPT_FORMAT && $SITAR_OPT_OUTFILE && ( !$SITAR_OPT_HELP ) && ( !$SITAR_OPT_VERSION ) ) {
		for $ff ( @SITAR_STRUCTURED ) {
			if( $SITAR_OPT_FORMAT eq $ff ){
				si_run_structured( );
			}
		}
		for $ff ( @SITAR_SELFILES ) {
			if( $SITAR_OPT_FORMAT eq $ff ){
				si_run_selfiles( $ff);
			}
		}
	} elsif ( $SITAR_OPT_VERSION ) {
		si_print_version();
	} elsif ( ( $SITAR_OPT_FORMAT && ( !$SITAR_OPT_OUTFILE ) ) || ( ( !$SITAR_OPT_FORMAT ) && $SITAR_OPT_OUTFILE ) || $SITAR_OPT_HELP ) {
		si_print_help();
	} else {
	}
}
#
