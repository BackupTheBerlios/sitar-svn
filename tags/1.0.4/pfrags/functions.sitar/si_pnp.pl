#
#	si_pnp.pl
#
sub si_pnp() {
	if ( ( -x "$CMD_LSPNP" ) && ( -r "/proc/bus/pnp" ) ) {
		open( IN, "$CMD_LSPNP | " );
		siprtt( "h2", "PNP Devices" );
		siprtttt( "tabborder", "lll", "PNP Devices", 3 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Node Number" );
		siprtt( "tabhead", "Product Ident." );
		siprtt( "tabhead", "Description" );
		siprt( "endrow" );
		my @attr;
		while ( <IN> ) {
			@attr = split /\s+/, $_, 3;
			siprt( "tabrow" );
			siprtt( "cell", $attr[ 0 ] );
			siprtt( "cell", $attr[ 1 ] );
			siprtt( "cell", $attr[ 2 ] );
			siprt( "endrow" );
		}
		siprt( "endtab" );
		close( IN );
	}
}
