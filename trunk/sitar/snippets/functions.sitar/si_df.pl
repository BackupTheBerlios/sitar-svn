#
#
#
sub si_df() {
	my %rule    = ();
	my $isbegin = 1;
	open( DF, "$CMD_DF |" );
	siprtt( "h1", "Filesystem Disk Space Usage" );
	siprtttt( "tabborder", "llllllll", "Filesystem Disk Space Usage", 8 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Filesystem" );
	siprtt( "tabhead", "1k-blocks" );
	siprtt( "tabhead", "Used" );
	siprtt( "tabhead", "Available" );
	siprtt( "tabhead", "Use%" );
	siprtt( "tabhead", "Mounted on" );
	siprt( "endrow" );
	while ( <DF> ) {
		#if(m/^\d/){
		if ( m/^\/dev/ ) {
			my ( $filesys, $blocks, $used, $avail, $useperc, $mounted ) = split /\s+/;
			siprt( "tabrow" );
			siprtt( "cell", $filesys );
			siprtt( "cell", $blocks );
			siprtt( "cell", $used );
			siprtt( "cell", $avail );
			siprtt( "cell", $useperc );
			siprtt( "cell", $mounted );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
	close( DF );
}

