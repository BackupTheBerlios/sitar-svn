#
# Display Areca RAID Controller configuration
# $Id: $
#
sub si_areca() {
	si_debug( "si_areca" );
	if ( !-x "$CMD_ARECACLI" ) {
		$CMD_ARECACLI =~ s/64/32/g;
	}
	if ( -x "$CMD_ARECACLI" ) {
		open( ARC, "$CMD_ARECACLI sys info |" );
		siprtt( "h1", "Areca RAID Controller Configuration" );
		siprtt( "h2", "Controller Hardware Information" );
		siprt( "pre" );
		while ( <ARC> ) {
			chomp;
			siprtt( "verb", "$_\n" );
		}
		close( ARC );
		siprt( "endpre" );
		open( ARC, "$CMD_ARECACLI rsf info |" );
		siprtt( "h2", "Raid Set Information" );
		siprt( "pre" );
		while ( <ARC> ) {
			chomp;
			siprtt( "verb", "$_\n" );
		}
		close( ARC );
		siprt( "endpre" );
		open( ARC, "$CMD_ARECACLI vsf info |" );
		siprtt( "h2", "Volume Set Information" );
		siprt( "pre" );
		while ( <ARC> ) {
			chomp;
			siprtt( "verb", "$_\n" );
		}
		close( ARC );
		siprt( "endpre" );
		open( ARC, "$CMD_ARECACLI disk info |" );
		siprtt( "h2", "Disk Information" );
		siprt( "pre" );
		while ( <ARC> ) {
			chomp;
			siprtt( "verb", "$_\n" );
		}
		close( ARC );
		siprt( "endpre" );
	}
}
