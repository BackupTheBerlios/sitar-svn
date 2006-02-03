#
#	si_route.pl
#
sub si_route() {
	my %rule    = ();
	my $isbegin = 1;
	open( ROUTE, "$CMD_ROUTE -n |" );
	siprtt( "h1", "Routing" );
	siprtttt( "tabborder", "llllllll", "Routing", 8 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Destination" );
	siprtt( "tabhead", "Gateway" );
	siprtt( "tabhead", "Genmask" );
	siprtt( "tabhead", "Flags" );
	siprtt( "tabhead", "Metric" );
	siprtt( "tabhead", "Ref" );
	siprtt( "tabhead", "Use" );
	siprtt( "tabhead", "IFace" );
	siprt( "endrow" );
	while ( <ROUTE> ) {
		if ( m/^\d/ ) {
			my ( $dest, $gate, $genmask, $flags, $metric, $ref, $use, $iface ) = split /\s+/;
			siprt( "tabrow" );
			siprtt( "cell", $dest );
			siprtt( "cell", $gate );
			siprtt( "cell", $genmask );

			sub si_usercrontab() {
				# Crontab
				siprtt( "h1", "Crontab" );
				if ( -r "/etc/crontab" ) {
					open( CRONTAB, "/etc/crontab" );
					siprtt( "h2", "/etc/crontab" );
					siprtttt( "tabborder", "llllllll", "/etc/crontab", 8 );
					siprt( "tabrow" );
					siprtt( "tabhead", "Minute" );
					siprtt( "tabhead", "Hour" );
					siprtt( "tabhead", "Day of month" );
					siprtt( "tabhead", "Month" );
					siprtt( "tabhead", "Day of week" );
					siprtt( "tabhead", "User" );
					siprtt( "tabhead", "Command" );
					siprt( "endrow" );
					while ( <CRONTAB> ) {
						if ( m/^\d/ ) {
							my ( $minute, $hour, $dayofmonth, $month, $dayofweek, $user, @command ) = split /\s+/;
							siprt( "tabrow" );
							siprtt( "cell", $minute );
							siprtt( "cell", $hour );
							siprtt( "cell", $dayofmonth );
							siprtt( "cell", $month );
							siprtt( "cell", $dayofweek );
							siprtt( "cell", $user );
							siprtt( "cell", "@command" );
							siprt( "endrow" );
						}
					}
					siprt( "endtab" );
					close( CRONTAB );
				}
				if ( -r "/var/spool/cron" ) {
					for $NN ( `$CMD_FIND /var/spool/cron -type f` ) {
						chomp $NN;
						my %rule    = ();
						my $isbegin = 1;
						open( CRONTAB, $NN );
						siprtt( "h2", "$NN" );
						siprtttt( "tabborder", "llllllll", "$NN", 8 );
						siprt( "tabrow" );
						siprtt( "tabhead", "Minute" );
						siprtt( "tabhead", "Hour" );
						siprtt( "tabhead", "Day of month" );
						siprtt( "tabhead", "Month" );
						siprtt( "tabhead", "Day of week" );
						siprtt( "tabhead", "Command" );
						siprt( "endrow" );
						while ( <CRONTAB> ) {
							if ( m/^\d/ ) {
								my ( $minute, $hour, $dayofmonth, $month, $dayofweek, @command ) = split /\s+/;
								siprt( "tabrow" );
								siprtt( "cell", $minute );
								siprtt( "cell", $hour );
								siprtt( "cell", $dayofmonth );
								siprtt( "cell", $month );
								siprtt( "cell", $dayofweek );
								siprtt( "cell", "@command" );
								siprt( "endrow" );
							}
						}
						siprt( "endtab" );
						close( CRONTAB );
					}
				}
			}
			siprtt( "cell", $flags );
			siprtt( "cell", $metric );
			siprtt( "cell", $ref );
			siprtt( "cell", $use );
			siprtt( "cell", $iface );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
	close( ROUTE );
}
