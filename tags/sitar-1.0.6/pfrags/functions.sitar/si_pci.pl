#
#	si_pci.pl
#
sub si_pci() {
	si_debug("si_pci");
	if ( -e "/proc/pci" ) {
		open( IN, "/proc/pci" );
		siprtt( "h2", "PCI Devices" );
		siprtttt( "tabborder", "lllll", "PCI Devices", 5 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Type" );
		siprtt( "tabhead", "Vendor/Name" );
		siprtt( "tabhead", "Bus" );
		siprtt( "tabhead", "Device" );
		siprtt( "tabhead", "Function" );
		siprt( "endrow" );
		my @attr;
		while ( <IN> ) {
			if ( m/:$/g ) {
				# s/^\s+Bus\s+(\d+),\s+device\s+(\d+),\s+function\s+(\d+):$/$1:$2:$3/gx;
				m/^\s+Bus\s+(\d+),\s+device\s+(\d+),\s+function\s+(\d+)/;
				@attr = ( $1, $2, $3 );
			} elsif ( m/:/g ) {
				m/^(.*):(.*)/;
				siprt( "tabrow" );
				siprtt( "cell", $1 );
				siprtt( "cell", $2 );
				siprtt( "cell", $attr[ 0 ] );
				siprtt( "cell", $attr[ 1 ] );
				siprtt( "cell", $attr[ 2 ] );
				siprt( "endrow" );
			}
		}
		siprt( "endtab" );
		close( IN );
	} elsif ( -x "$CMD_LSPCI" ) {
		siprtt( "h2", "PCI Devices" );
		siprtttt( "tabborder", "lp{0.15\\textwidth}p{0.15\\textwidth}p{0.15\\textwidth}p{0.15\\textwidth}p{0.15\\textwidth}l", "PCI Devices", 7 );
		siprt( "tabrow" );
		for $TT qw ( PCI Device Class Vendor SVendor SDevice Rev ) {
			siprtt( "tabhead", $TT );
		}
		siprt( "endrow" );
		my %lspcidevices_h = {};
		my $MyDevice       = "";
		my $takenew        = 1;
		open( LSPCI, "$CMD_LSPCI -vm | " );
		while ( <LSPCI> ) {
			if ( $_ eq "\n" ) {
				$takenew = 1;
			} else {
				( $KK, $VV ) = split /:/, $_, 2;
				chomp $KK;
				chomp $VV;
				if ( ( $KK eq "Device" ) && ( $takenew == 1 ) ) {
					# begin new record
					$MyDevice                               = $VV;
					$lspcidevices_h{ "$MyDevice" }          = ();
					$lspcidevices_h{ "$MyDevice" }{ "PCI" } = $VV;
					$takenew                                = 0;
				} else {
					# add to record
					$lspcidevices_h{ "$MyDevice" }{ "$KK" } = $VV;
				}
			}
		}
		close LSPCI;
		foreach $NN ( sort keys %lspcidevices_h ) {
			siprt( "tabrow" );
			for $TT qw ( PCI Device Class Vendor SVendor SDevice Rev ) {
				$tt = $lspcidevices_h{ "$NN" }{ "$TT" };
				chomp $tt;
				if ( $tt eq "" ) {
					siprtt( "cell", "" );
				} else {
					my $ttt = $lspcidevices_h{ "$NN" }{ "$TT" };
					chomp $ttt;
					siprtt( "cell", $ttt );
				}
			}
			siprt( "endrow" );
		}
		siprt( "endtab" );
	} elsif ( -x "$CMD_LSHAL" ) {
		push @lines, $_;
		siprtt( "h2", "Hardware Abstraction Layer (HAL)" );
		siprt( "pre" );
		open( CONFIG, "$CMD_LSHAL --long |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
	}
}
