#
#	si_proc_modules.pl
#
sub si_proc_modules () {
	si_debug("si_proc_modules");
	if ( -r "/proc/modules" ) {
		siprtt( "h2", "Kernel Modules" );
		siprtttt( "tabborder", "llll", "Kernel Modules", 4 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Module" );
		siprtt( "tabhead", "Use Count" );
		siprtt( "tabhead", "Referring Modules" );
		siprtt( "tabhead", "Needs/Uses" );
		siprt( "endrow" );
		my @attr;
		open( IN, "/proc/modules" );
		while ( <IN> ) {
			@attr = split /\s+/, $_, 4;
			siprt( "tabrow" );
			siprtt( "cell", $attr[ 0 ] );
			siprtt( "cell", $attr[ 1 ] );
			siprtt( "cell", $attr[ 2 ] );
			siprtt( "cell", $attr[ 3 ] );
			siprt( "endrow" );
		}
		close( IN );
		siprt( "endtab" );
	}
}
