#
#	si_ide.pl
#
sub si_ide() {
	my $exists_ide = 0;
	for $abc ( "a" .. "i" ) {
		if ( -r "/proc/ide/hd$abc" ) { $exists_ide = 1; }
	}
	if ( $exists_ide ) {
		if ( $UNAMER lt "2.1.0" ) {
			siprtt( "h1", "IDE-Analysis: Kernel-Release $UNAMER not supported, sorry :-(\n" );
		} else {
			siprtt( "h1", "IDE" );
			siprtttt( "tabborder", "lllllllll", "IDE", 9 );
			siprt( "tabrow" );
			siprtt( "tabhead", "Device" );
			siprtt( "tabhead", "Type" );
			siprtt( "tabhead", "Model" );
			siprtt( "tabhead", "Driver" );
			siprtt( "tabhead", "Geo., phys." );
			siprtt( "tabhead", "Geo., log." );
			siprtt( "tabhead", "Size(blks)" );
			siprtt( "tabhead", "Firmware" );
			siprtt( "tabhead", "Serial" );
			siprt( "endrow" );
			for $abc ( "a" .. "d" ) {
				if ( -r "/proc/ide/hd$abc" ) {
					$hddev = "/dev/hd$abc";
					chomp( $media  = si_readfile( "/proc/ide/hd${abc}/media" ) );
					chomp( $driver = si_readfile( "/proc/ide/hd${abc}/driver" ) );
					chomp( $model  = si_readfile( "/proc/ide/hd${abc}/model" ) );
					siprt( "tabrow" );
					siprtt( "cell", "/dev/hd$abc" );
					siprtt( "cell", $media );
					siprtt( "cell", $model );
					siprtt( "cell", $driver );
					if ( $media eq "disk" ) {
						# $capa   = si_readfile( "/proc/ide/hd${abc}/capacity" );
						# $cache  = si_readfile( "/proc/ide/hd${abc}/cache" );
						open( GEO, "/proc/ide/hd${abc}/geometry " );
						while ( <GEO> ) {
							if ( m/^logical/g ) {
								s/^logical\s+(.*)$/$1/gs;
								$geol = $_;
							}
							if ( m/^physical/g ) {
								s/^physical\s+(.*)$/$1/gs;
								$geop = $_;
							}
						}
						close( GEO );
						siprtt( "cell", $geop );
						siprtt( "cell", $geol );
						siprtt( "cell", $capa );
						# siprtt("cell",$fw_rev);
						# siprtt("cell",$serial)
						siprtt( "cell", "-" );
						siprtt( "cell", "-" );
					} else {
						siprttt( "headcol", "", "5" );
					}
					siprt( "endrow" );
				}
			}
			siprt( "endtab" );
		}
	}
}
