#
#	si_ips
#
sub si_ips() {
	si_debug("si_ips");
	if ( -r "/proc/scsi/ips" ) {
		siprtt( "h1", "IBM ServeRaid" );
		for ( $i = 0 ; $i < 16 ; $i++ ) {
			if ( -r "/proc/scsi/ips/$i" ) {
				siprtt( "h2", "Controller $i" );
				siprtttt( "tabborder", "ll", "IBM ServeRaid Controller $i", 2 );
				open( IPS, "/proc/scsi/ips/$i" );
				while ( <IPS> ) {
					if ( ( m/^\s+/ ) && ( !m/^$/ ) ) {
						my ( $key, $val ) = split /:/;
						siprt( "tabrow" );
						siprtt( "cell", $key );
						siprtt( "cell", $val );
						siprt( "endrow" );
					}
				}
				close( IPS );
				siprt( "endtab" );
			}
		}
	}
}
