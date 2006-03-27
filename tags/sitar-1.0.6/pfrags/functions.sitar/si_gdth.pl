#
#
#
sub si_gdth() {
	si_debug("si_gdth");
	if ( -r "/proc/scsi/gdth" ) {
		siprtt( "h1", "ICP Vortex RAID" );
		for ( $i = 0 ; $i < 16 ; $i++ ) {
			if ( -r "/proc/scsi/gdth/$i" ) {
				siprtt( "h2", "Controller $i" );
				siprtttt( "tabborder", "llll", "ICP Vortex RAID Controller $i", 4 );
				open( GDTH, "/proc/scsi/gdth/$i" );
				while ( <GDTH> ) {
					if ( !m/^\s+/ ) {
						siprt( "tabrow" );
						siprttt( "headcol", $_, 4 );
						siprt( "endrow" );
					} else {
						@ff = split /\t/, $_, 4;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprtt( "cell", $ff[ 1 ] );
						siprtt( "cell", $ff[ 2 ] );
						siprtt( "cell", $ff[ 3 ] );
						siprt( "endrow" );
					}
				}
				close( GDTH );
				siprt( "endtab" );
			}
		}
	}
}
