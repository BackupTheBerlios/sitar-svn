#
#	si_compaq_smart.pl
#
sub si_compaq_smart() {
	my $cparray = "/proc/array";
	if ( -r $cparray ) {
		siprtt( "h1", "COMPAQ Smart Array" );
		for ( $i = 0 ; $i < 10 ; $i++ ) {
			my $cpa_mode = 1;
			if ( -r "$cparray/ida$i" ) {
				siprtt( "h2", "Controller $i" );
				siprtttt( "tabborder", "ll", "COMPAQ Smart Array Controller $i", 2 );
				open( SMART, "$cparray/ida$i" );
				while ( <SMART> ) {
					if ( m/^ida\d/ && $cpa_mode == 1 ) {
						@ff = split /:/;
						siprt( "tabrow" );
						siprtt( "cell", "Typ ($ff[0])" );
						siprtt( "cell", $ff[ 1 ] );
						siprt( "endrow" );
					} elsif ( m/:/i && !m/^Logical Drive Info:/i && $cpa_mode == 1 ) {
						@ff = split /:/;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprtt( "cell", $ff[ 1 ] );
						siprt( "endrow" );
					} elsif ( m/^ida\// && $cpa_mode == 2 ) {
						@ff = split / |=|:/;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprtt( "cell", $ff[ 3 ] );
						siprtt( "cell", $ff[ 5 ] );
						siprt( "endrow" );
					} elsif ( m/^nr_/ && $cpa_mode == 2 ) {
						@ff = split /=/;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprttt( "cellspan", $ff[ 1 ], 2 );
						siprt( "endrow" );
					} elsif ( m/^Logical Drive Info:/ ) {
						siprt( "endtab" );
						siprtt( "h2", "Logical Drive Info" );
						siprtttt( "tabborder", "lll", "COMPAQ Smart Array Logical Drive Info", 3 );
						siprt( "tabrow" );
						siprtt( "tabhead", "Drive" );
						siprtt( "tabhead", "Blocksize" );
						siprtt( "tabhead", "BlockNum" );
						siprt( "endrow" );
						$cpa_mode = 2;
					} else {
					}
				}
				close( SMART );
				siprt( "endtab" );
			}
		}
	}
}
