#
#	si_route.pl
#
sub si_route() {
	my %rule    = ();
	my $isbegin = 1;
	open( ROUTE, "$CMD_ROUTE -n |" );
	siprtt( "h1", "Routing" );
	siprtttt( "tabborder", "llllllll", "Routing", 8 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Destination" );
	siprtt( "tabhead", "Gateway" );
	siprtt( "tabhead", "Genmask" );
	siprtt( "tabhead", "Flags" );
	siprtt( "tabhead", "Metric" );
	siprtt( "tabhead", "Ref" );
	siprtt( "tabhead", "Use" );
	siprtt( "tabhead", "IFace" );
	siprt( "endrow" );
	while ( <ROUTE> ) {
		if ( m/^\d/ ) {
			my ( $dest, $gate, $genmask, $flags, $metric, $ref, $use, $iface ) = split /\s+/;
			siprt( "tabrow" );
			siprtt( "cell", $dest );
			siprtt( "cell", $gate );
			siprtt( "cell", $genmask );
			siprtt( "cell", $flags );
			siprtt( "cell", $metric );
			siprtt( "cell", $ref );
			siprtt( "cell", $use );
			siprtt( "cell", $iface );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
	close( ROUTE );
}
