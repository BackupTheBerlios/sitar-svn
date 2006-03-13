#
#	si_ifconfig.pl
#
sub si_ifconfig() {
	my %rule    = ();
	my $isbegin = 1;
	open( IFCONFIG, "$CMD_IFCONF -v |" );
	siprtt( "h1", "Networking Interfaces" );
	siprt( "pre" );
	siprtt( "verb", "skipping IPv6 Options" );
	siprt( "endpre" );
	siprtttt( "tabborder", "lllllllll", "Networking Interfaces", 9 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Device" );
	siprtt( "tabhead", "Link Encap" );
	siprtt( "tabhead", "HW-Address" );
	siprtt( "tabhead", "IP" );
	siprtt( "tabhead", "Broadcast" );
	siprtt( "tabhead", "Mask" );
	siprtt( "tabhead", "Options" );
	siprtt( "tabhead", "MTU" );
	siprtt( "tabhead", "Metric" );
	siprt( "endrow" );
	while ( <IFCONFIG> ) {
		if ( m/^\S/g ) {
			siprt( "tabrow" );
			s/^([\w:]+)\s+Link\sencap:(\w+)\s+((HWaddr\s(.*))|(Loopback))\s*$/$1::$2::$5$6/ix;
			my ( $t1, $t2, $t3 ) = split /::/;
			siprtt( "cell", $t1 );
			siprtt( "cell", $t2 );
			siprtt( "cell", $t3 );
		} elsif ( m/.*inet6.*/g ) {
		} elsif ( m/.*inet.*/g )  {
			s/\s*inet\saddr:([\w|.]+)\s+((Bcast:([\w|.]+)\s+)|(\s+))Mask:([\w|.]+)\s*/$1::$4::$6/ix;
			my ( $t1, $t2, $t3 ) = split /::/;
			siprtt( "cell", $t1 );
			siprtt( "cell", $t2 );
			siprtt( "cell", $t3 );
		} elsif ( m/.*Metric.*/g ) {
			s/\s*([\w+\s]*)\s+MTU:([\w|.]+)\s+Metric:([\w|.]+)\s*/$1::$2::$3/ix;
			my ( $t1, $t2, $t3 ) = split /::/;
			siprtt( "cell", $t1 );
			siprtt( "cell", $t2 );
			siprtt( "cell", $t3 );
			siprt( "endrow" );
		} else {
		}
	}
	siprt( "endtab" );
	close( IFCONFIG );
}
