#
#	si_chkconfig.pl
#
sub si_chkconfig () {
	if ( -x "$CMD_CHKCONF" ) {
		push @lines, $_;
		siprtt( "h1", "Automatic Startup (chkconfig -l)" );
		siprt( "pre" );
		open( CONFIG, "$CMD_CHKCONF --list |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
	}
}

