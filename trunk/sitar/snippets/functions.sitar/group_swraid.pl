#
#	group-sw-raid
#
sub si_software_raid() {
	my $MDSTAT  = "/proc/mdstat";
	my $RAIDTAB = "/etc/raidtab";
	chomp( $UNAMER );
	if (       ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.4.*/ )
		|| ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.6.*/ ) ) {
		siprtt( "h1", "Software RAID" );
		siprtt( "h2", "Configuration" );
		si_conf( $MDSTAT, $MDSTAT, "" );
		if ( -r $RAIDTAB ) {
			si_conf( $RAIDTAB, $RAIDTAB, "" );
		}
	}
}

sub si_software_raid_details() {
	my $MDSTAT  = "/proc/mdstat";
	my $RAIDTAB = "/etc/raidtab";
	if ( -r $MDSTAT ) {
		siprtt( "h2", "Details" );
		siprtttt( "tabborder", "llllll", "Software RAID", 6 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Raid-Device" );
		siprtt( "tabhead", "Raid-Level" );
		siprtt( "tabhead", "Raid-Partitions" );
		siprtt( "tabhead", "Blocks" );
		siprtt( "tabhead", "Chunks" );
		siprtt( "tabhead", "Algorithm" );
		siprt( "endrow" );
		open( IN1, "</proc/mdstat" ) || return ();
		chomp( $UNAMER );
		my ( $counter1, $counter2 ) = 0;
		if (       ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.4.*/ )
			|| ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.6.*/ ) ) {
			#CODE for kernel-2.4 software-raid
			while ( <IN1> ) {
				$counter1++;
				$counter2 = 0;
				if ( m/^(md\d+)\s:\sactive\s(raid\d)\s(.*)$/g ) {
					my $raiddev    = $1;
					my $level      = $2;
					my %md         = ();
					my @partitions = split( ' ', $3 );
					$md{ level }      = $level;
					$md{ partitions } = "@partitions";
					open( IN2, "</tmp/mdstat" ) || last;
					while ( <IN2> ) {
						$counter2++;
						my $counter1plus1 = 0;
						$counter1plus1 = ( $counter1 + 1 );
						if ( $counter2 == $counter1plus1 ) {
							my @md_options = split( ' ', $_ );
							if ( $level eq 'raid0' ) {
								$md{ blocks }    = $md_options[ 0 ];
								$md{ chunks }    = $md_options[ 2 ];
								$md{ algorithm } = " ";
							}
							if ( $level eq 'raid1' ) {
								$md{ blocks }    = $md_options[ 0 ];
								$md{ chunks }    = " ";
								$md{ algorithm } = " ";
							}
							if ( $level eq 'raid5' ) {
								$md{ blocks }    = $md_options[ 0 ];
								$md{ chunks }    = $md_options[ 4 ];
								$md{ algorithm } = $md_options[ 7 ];
							}
						}
					}
					close( IN2 );
					#hier der code zur html-ausgabe
					siprt( "tabrow" );
					siprtt( "cell", $raiddev );
					siprtt( "cell", $md{ level } );
					siprtt( "cell", @md{ partitions } );
					siprtt( "cell", $md{ blocks } );
					siprtt( "cell", $md{ chunks } );
					siprtt( "cell", $md{ algorithm } );
					siprt( "endrow" );
					unless ( -e ( ( $RAIDTAB ) || ( "/etc/raid0.conf" ) || ( "/etc/raid1.conf" ) || ( "/etc/raid5.conf" ) ) ) {
						siprtt( "h4", "There seems to be no /etc/raidtab or similar.\n" );
					}
				}
			}
			} elsif ( ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\..*/ ) ) {
			#CODE for kernel-2.2 software-raid
			while ( <IN1> ) {
				$counter1++;
				$counter2 = 0;
				if ( m/^(md\d+)\s:\sactive\s(raid\d)\s([h|s].*)\s(\d+)\s(block.*)$/g ) {
					my $raiddev    = $1;
					my $level      = $2;
					my %md         = ();
					my @partitions = split( ' ', $3 );
					$md{ level }      = $level;
					$md{ partitions } = "@partitions";
					$md{ blocks }     = $4;
					$md{ chunks }     = "";
					$md{ algorithm }  = "";
					if ( $5 =~ m/^blocks\s\w+\s\d,\s(\d+k)\s\w+,\s\w+\s(\d+)\s.*$/g ) {
						$md{ chunks }    = $1;
						$md{ algorithm } = $2;
					} elsif ( $5 =~ m/^blocks\s(\d+k)\s.*$/g ) {
						$md{ chunks }    = $1;
						$md{ algorithm } = " ";
					}
					siprt( "tabrow" );
					siprtt( "cell", $raiddev );
					siprtt( "cell", $md{ level } );
					siprtt( "cell", @md{ partitions } );
					siprtt( "cell", $md{ blocks } );
					siprtt( "cell", $md{ chunks } );
					siprtt( "cell", $md{ algorithm } );
					siprt( "endrow" );
					unless ( -e ( ( $RAIDTAB ) || ( "/etc/raid0.conf" ) || ( "/etc/raid1.conf" ) || ( "/etc/raid5.conf" ) ) ) {
						siprtt( "h4", "There seems to be no /etc/raidtab or similar.\n" );
					}
				}
			}
		}
		siprt( "endtab" );
		unlink "/tmp/mdstat";
		close( IN1 );
	}
}

