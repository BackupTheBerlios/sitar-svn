#
#	si_cpuinfo
#
sub si_cpuinfo() {
	si_debug("si_cpuinfo");
	siprtt( "h1", "CPU" );
	siprtttt( "tabborder", "ll", "CPU", 2 );
	open( IN, "/proc/cpuinfo" );
	if ( $UNAMEM eq "alpha" ) {
		while ( <IN> ) {
			my ( $proc, $value ) = split /:/;
			chop( $proc );
			chop( $value );
			if ( $proc eq "cpus detected" ) {
				siprt( "tabrow" );
				siprttt( "headcolor", "cpus detected", "\#CCCCCC" );
				siprttt( "cellcolor", $value, "\#CCCCCC" );
				siprt( "endrow" );
			} else {
				siprt( "tabrow" );
				siprtt( "tabhead", $proc );
				siprtt( "cell",    $value );
				siprt( "endrow" );
			}
		}
	} else {
		while ( <IN> ) {
			if ( m/^(processor)/gi ) {
				# m/(\d+)/gs;
				my ( $proc, $value ) = split /:/;
				siprt( "tabrow" );
				siprttt( "headcolor", "Processor", "\#CCCCCC" );
				siprttt( "cellcolor", $value, "\#CCCCCC" );
				siprt( "endrow" );
			}
			if ( m/^(cpu MHz)|^(model name)|^(vendor_id)|^(cache size)|^(stepping)|^(cpu family)|^(model)/i ) {
				m/^(.*):(.*)$/gsi;
				my $tt1 = $1;
				chop( my $tt2 = $2 );
				siprt( "tabrow" );
				siprtt( "tabhead", $tt1 );
				siprtt( "cell",    $tt2 );
				siprt( "endrow" );
			}
		}
	}
	close( IN );
	siprt( "endtab" );
}
