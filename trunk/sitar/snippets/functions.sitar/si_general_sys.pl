#
#	si_general_sys
#
sub si_general_sys() {
	siprtt( "h1", "General Information" );
	siprtttt( "tabborder", "ll", "General Information", 2 );
	siprt( "tabrow" );
	siprtt( "cell", "Hostname" );
	siprtt( "cell", $HOSTNAME );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "Operating System" );
	siprtt( "cell", $DIST_RELEASE );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "UName" );
	siprtt( "cell", $UNAME );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "Date" );
	siprtt( "cell", $now_string_g );
	siprt( "endrow" );
	open( IN, "/proc/meminfo" );
	while ( <IN> ) {
		if ( m/MemTotal/g ) {
			m/(\d+)/gs;
			siprt( "tabrow" );
			siprtt( "cell", "Main Memory" );
			siprtt( "cell", "$1 KByte" );
			siprt( "endrow" );
		}
	}
	close( IN );
	open( IN, "/proc/cmdline" );
	while ( <IN> ) {
		chomp $_;
		siprt( "tabrow" );
		siprtt( "cell", "Cmdline" );
		siprtt( "cell", "$_" );
		siprt( "endrow" );
	}
	close( IN );
	open( IN, "/proc/loadavg" );
	while ( <IN> ) {
		chomp $_;
		siprt( "tabrow" );
		siprtt( "cell", "Load" );
		siprtt( "cell", "$_" );
		siprt( "endrow" );
	}
	close( IN );
	open( IN, "/proc/uptime" );
	while ( <IN> ) {
		( $uptime,  $idletime ) = split / /,  $_,        2;
		( $upmin,   $rest )     = split /\./, $uptime,   2;
		( $idlemin, $rest )     = split /\./, $idletime, 2;
		siprt( "tabrow" );
		siprtt( "cell", "Uptime (minutes hours days)" );
		siprtt( "cell", int( $upmin / 60 ) . " " . int( $upmin / 3600 ) . " " . int( $upmin / 87400 ) );
		siprt( "endrow" );
		siprt( "tabrow" );
		siprtt( "cell", "Idletime (minutes hours days)" );
		siprtt( "cell", int( $idlemin / 60 ) . " " . int( $idlemin / 3600 ) . " " . int( $idlemin / 87400 ) );
		siprt( "endrow" );
	}
	close( IN );
	siprt( "endtab" );
}

