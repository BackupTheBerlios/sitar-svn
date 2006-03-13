#
#	si_dac960.pl
#
sub si_dac960() {
	if ( -r "/proc/rd" ) {
		siprtt( "h1", "Mylex ('DAC 960') RAID" );
		for ( $i = 0 ; $i < 8 ; $i++ ) {
			if ( -r "/proc/rd/c$i" ) {
				siprtt( "h2", "Controller $i" );
				open( MYLEX, "/proc/rd/c$i/initial_status" );
				siprtttt( "tabborder", "lllllll", "Mylex ('DAC 960') RAID Controller $i", 7 );
				my $status;
				my %physicals = ();
				my $onephysical;
				my $first = 1;
				my $open  = 0;
				while ( <MYLEX> ) {
					# print $_;
					if ( m/^Configuring/ ) {
						$status = "config";
					} elsif ( $status eq "config" && m/^\s\sPhysical/ ) {
						siprt( "endtab" );
						$status = "physical";
						siprtttt( "tabborder", "lllllll", "physical", 7 );
						siprt( "tabrow" );
						siprtt( "tabhead", "id:lun" );
						siprtt( "tabhead", "Vendor" );
						siprtt( "tabhead", "Model" );
						siprtt( "tabhead", "Revision" );
						siprtt( "tabhead", "Serial" );
						siprtt( "tabhead", "Status" );
						siprtt( "tabhead", "Size" );
						siprt( "endrow" );
					} elsif ( $status eq "physical" && m/^\s\sLogical/ ) {
						siprt( "endrow" );
						siprt( "endtab" );
						$status = "logical";
						siprtttt( "tabborder", "lllll", "logical", 5 );
						siprt( "tabrow" );
						siprtt( "tabhead", "Device" );
						siprtt( "tabhead", "Raid-Level" );
						siprtt( "tabhead", "Status" );
						siprtt( "tabhead", "Size" );
						siprtt( "tabhead", "Options" );
						siprt( "endrow" );
					} elsif ( $status eq "config" && m/^\s\s\w/ ) {
						chomp( @fs = split /:|,/ );
						if ( $fs[ 1 ] ne "" ) {
							siprt( "tabrow" );
							siprtt( "tabhead", $fs[ 0 ] );
							siprtt( "cell",    $fs[ 1 ] );
							siprt( "endrow" );
						}
						if ( $fs[ 3 ] ne "" ) {
							siprt( "tabrow" );
							siprtt( "tabhead", $fs[ 2 ] );
							siprtt( "cell",    $fs[ 3 ] );
							siprt( "endrow" );
						}
						if ( $fs[ 5 ] ne "" ) {
							siprt( "tabrow" );
							siprtt( "tabhead", $fs[ 4 ] );
							siprtt( "cell",    $fs[ 5 ] );
							siprt( "endrow" );
						}
					} elsif ( $status eq "physical" && m/Vendor/ ) {
						chomp;
						m/^\s+(\w+):(\w+)\s+Vendor:(.*)Model:(.*)Revision:(.*)$/gs;
						if ( $first ) { $first = 0; }
						else { siprt( "endrow" ); }
						siprt( "tabrow" );
						siprtt( "cell", "$1:$2" );
						siprtt( "cell", $3 );
						siprtt( "cell", $4 );
						siprtt( "cell", $5 );
					} elsif ( $status eq "physical" && m/Serial/ ) {
						chomp( my ( $ttt, $serial ) = split /:|,/ );
						siprtt( "cell", $serial );
					} elsif ( $status eq "physical" && m/Disk/ ) {
						chomp( my ( $ttt, $state, $blocks ) = split /:|,/ );
						siprtt( "cell", $state );
						siprtt( "cell", $blocks );
					} elsif ( $status eq "logical" ) {
						chomp( my ( $dev, $raid, $state, $blocks, $opt ) = split /:|,/ );
						siprt( "tabrow" );
						siprtt( "cell", $dev );
						siprtt( "cell", $raid );
						siprtt( "cell", $state );
						siprtt( "cell", $blocks );
						siprtt( "cell", $opt );
						siprt( "endrow" );
					}
				}
				siprt( "endtab" );
				close( MYLEX );
			}
		}
	}
}
