#
#	AppArmor
#
sub si_immunix_apparmor () {
	if ( -d "$apparmor_kernel_path" ) {
		siprtt( "h1", $apparmor_verbose_name );
		siprtt( "h2", "Current Configuration" );
		siprtttt( "tabborder", "lll", "Configuration", 3 );
		open( SAVEERR, ">&STDERR" );
		open( STDERR,  ">/dev/null" );
		for $NN ( sort `$CMD_FIND $apparmor_kernel_path/ -type f` ) {
			chomp $NN;
			$value = `$CMD_CAT $NN`;
			if ( $value ne "" ) {
				my $MM = $NN;
				$MM =~ s/$apparmor_kernel_path\///;
				$OO = $MM;
				$OO =~ s/(\w+\/)*(\w+)$/$+/;
				chomp $OO;
				if ( $OO eq "profiles" ) {
					siprt( "tabrow" );
					siprtt( "cell", $OO );
					siprt( "emptycell" );
					siprt( "emptycell" );
					siprt( "endrow" );
					for $TT ( split( /\)/, $value ) ) {
						my ( $tname, $tenforce ) = split( /\(/, $TT );
						siprt( "tabrow" );
						siprt( "emptycell" );
						siprtt( "cell", $tname );
						siprtt( "cell", $tenforce );
						siprt( "endrow" );
					}
				} else {
					siprt( "tabrow" );
					siprtt( "cell", $OO );
					siprtt( "cell", $value );
					siprt( "emptycell" );
					siprt( "endrow" );
				}
			}
		}
		open( STDERR, ">&SAVEERR" );
		siprt( "endtab" );
		if ( -f "$apparmor_config_log" ) {
			si_conf( $apparmor_config_log, $apparmor_config_log, "\#" );
		}
		for $ppp ( @apparmor_config_path ) { 
			if ( -d "$ppp" ) {
				for $NN ( `$CMD_FIND $ppp -type f` ) {
					chomp $NN;
					si_conf( $NN, $NN, "\#" );
				}
			}
		}
		$SITAR_OPT_ALLSUBDOMAIN =~ tr/A-Z/a-z/;
		if ( ( $SITAR_OPT_ALLSUBDOMAIN eq "on" ) || ( ( $SITAR_OPT_ALLSUBDOMAIN eq "auto" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_CONSIST_FN" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_UNPACKED_FN" ) ) ) {
			siprtt( "h2", "Profiles" );
			for $ppp ( @apparmor_profiles_path ) {
				if ( -d "$ppp" ) {
					for $NN ( `$CMD_FIND $ppp -type f` ) {
						chomp $NN;
						si_conf( $NN, $NN, "" );
					}
				}
			}
		}
	}
}
