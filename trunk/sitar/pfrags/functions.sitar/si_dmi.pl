#
# Dump DMI with dmidecode
# $Id: $
#
sub si_dmi() {
	si_debug( "si_dmi" );
	if ( -x "$CMD_DMIDECODE" ) {
		open( DMI, "$CMD_DMIDECODE |" );
		siprtt( "h1", "Desktop Management Information (DMI)" );
		siprt( "pre" );
		while ( <DMI> ) {
			chomp;
			siprtt( "verb", "$_\n" );
		}
		close( DMI );
		siprt( "endpre" );
	}
}
