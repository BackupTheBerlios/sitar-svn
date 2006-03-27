#
#	group_firewalling.pl
#
sub si_ipvs () {
}

sub si_ipfwadm() {
	siprt( "pre" );
	siprtt( "verb", "ipfwadm is not supported." );
	siprt( "endpre" );
}
#
#
#
sub si_ipchains () {
	my @protocols = ();
	si_debug("si_ipchains");
	open( PROTO, "/etc/protocols" );
	while ( <PROTO> ) {
		if ( !m/^#/ ) {
			m/^(\w+)\s+(\w+)\s+(\w+)\s*/g;
			$protocols[ $2 ] = $1;
		}
	}
	close( PROTO );
	open( CHAIN, "/proc/net/ip_fwchains" );
	$no_header = 1;
	while ( <CHAIN> ) {
		( $empty, $chainname, $sourcedest, $ifname, $fw_flg, $fw_invflg, $proto, $packa, $packb, $bytea, $byteb, $portsrc, $portdest, $tos, $xor, $redir, $fw_mark, $outsize, $target ) = split /\s+/;
		$sourcedest =~ m/(\w\w)(\w\w)(\w\w)(\w\w)\/(\w\w)(\w\w)(\w\w)(\w\w)->(\w\w)(\w\w)(\w\w)(\w\w)\/(\w\w)(\w\w)(\w\w)(\w\w)/g;
		$source = join "", hex( $1 ), ".", hex( $2 ),  ".", hex( $3 ),  ".", hex( $4 ),  "/", hex( $5 ),  ".", hex( $6 ),  ".", hex( $7 ),  ".", hex( $8 );
		$dest   = join "", hex( $9 ), ".", hex( $10 ), ".", hex( $11 ), ".", hex( $12 ), "/", hex( $13 ), ".", hex( $14 ), ".", hex( $15 ), ".", hex( $16 );
		if ( $no_header ) {
			if ( $chainname ne "" ) {
				siprtt( "h2", "Filter Rules" );
				siprtttt( "tabborder", "lllllllllllllllll", "Filter Rules", 17 );
				siprt( "tabrow" );
				siprtt( "tabhead", "Name" );
				siprtt( "tabhead", "Target" );
				siprtt( "tabhead", "I.face" );
				siprtt( "tabhead", "Proto" );
				siprtt( "tabhead", "Src" );
				siprtt( "tabhead", "Port" );
				siprtt( "tabhead", "Dest" );
				siprtt( "tabhead", "Port" );
				siprtt( "tabhead", "Flag" );
				siprtt( "tabhead", "Inv" );
				siprtt( "tabhead", "TOS" );
				siprtt( "tabhead", "XOR" );
				siprtt( "tabhead", "RdPort" );
				siprtt( "tabhead", "FWMark" );
				# siprtt("tabhead","OutputSize");
				# siprtt("tabhead","Packets");
				# siprtt("tabhead","Bytes");
				siprt( "endrow" );
				$no_header = 0;
			}
		}
		@PORT = split '-', $portsrc;
		if ( $PORT[ 0 ] == $PORT[ 1 ] ) { $portsrc = $PORT[ 0 ]; }
		@PORT = split '-', $portdest;
		siprt( "tabrow" );
		siprtt( "cell", $chainname );
		siprtt( "cell", $target );
		siprtt( "cell", $ifname );
		siprtt( "cell", ( ( $proto eq "0" ) ? "-" : $protocols[ $proto ] ) );
		siprtt( "cell", $source );
		siprtt( "cell", $portsrc );
		siprtt( "cell", $dest );
		siprtt( "cell", $portdest );
		siprtt( "cell", $fw_flg );
		siprtt( "cell", $fw_invflg );
		siprtt( "cell", $tos );
		siprtt( "cell", $xor );
		siprtt( "cell", $redir );
		siprtt( "cell", $fw_mark );
		# siprtt("cell",$outsize);
		# siprtt("cell","$packa,$packb");
		# siprtt("cell","$bytea,$byteb");
		siprt( "endrow" );
	}
	close( CHAIN );
	if ( $no_header ) {
		## siprtt("h2","No Filter Rules active");
	} else {
		siprt( "endtab" );
	}
	$no_header = 1;
	open( NAMES, "/proc/net/ip_fwnames" );
	while ( <NAMES> ) {
		( $chainname, $policy, $refcount ) = split /\s+/;
		if ( $no_header ) {
			siprtt( "h2", "Filter Policy" );
			siprtttt( "tabborder", "lll", "Filter Policy", 3 );
			siprt( "tabrow" );
			siprtt( "tabhead", "Name" );
			siprtt( "tabhead", "Policy" );
			siprtt( "tabhead", "RefCount" );
			siprt( "endrow" );
			$no_header = 0;
		}
		siprt( "tabrow" );
		siprtt( "cell", $chainname );
		siprtt( "cell", $policy );
		siprtt( "cell", $refcount );
		siprt( "endrow" );
	}
	if ( $no_header == 0 ) {
		siprt( "endtab" );
	}
	close( NAMES );
}

sub si_iptables () {
	si_debug("si_iptables");
	if ( -x "$CMD_IPTABLES" ) {
		push @lines, $_;
		open( TABLES, "/proc/net/ip_tables_names" );
		while ( $tabname = <TABLES> ) {
			chomp( $tabname );
			push @tables, $tabname;
		}
		close( TABLES );
		foreach $tabname ( @tables ) {
			chomp();
			siprtt( "h2", "Table $tabname" );
			siprt( "pre" );
			open( CONFIG, "$CMD_IPTABLES -v -L -n -t $tabname |" );
			while ( <CONFIG> ) {
				chomp();
				siprtt( "verb", "$_\n" );
			}
			close( CONFIG );
			siprt( "endpre" );
		}
	}
}

sub si_packetfilter() {
	si_debug("si_packetfilter");
	if ( -r "/proc/net/ip_input" ) {
		siprtt( "h1", "Packet Filter (ipfwadm)" );
		si_ipfwadm();
	} elsif ( -r "/proc/net/ip_fwnames" ) {
		siprtt( "h1", "Packet Filter (ipchains)" );
		si_ipchains();
	} elsif ( -r "/proc/net/ip_tables_names" ) {
		siprtt( "h1", "Packet Filter (iptables)" );
		si_iptables();
	} else {
		siprtt( "h1", "Packet Filter" );
		siprt( "pre" );
		siprtt( "verb", "No packet filter installed." );
		siprt( "endpre" );
	}
}
