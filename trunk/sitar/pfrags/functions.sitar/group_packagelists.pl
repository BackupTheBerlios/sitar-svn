#
#	group_packagelists
#
sub si_installed_deb() {
	siprtt( "h1", "Installed Packages" );
	siprtttt( "tabborder", "llllp{.5\\textwidth}", "Installed Packages", 5 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Name" );
	siprtt( "tabhead", "Status" );
	siprtt( "tabhead", "Version" );
	siprtt( "tabhead", "Size" );
	siprtt( "tabhead", "Short Description" );
	siprt( "endrow" );
	my $total = 0;
	my $num   = 0;
	my @debs;
	my $mark = "--sitar-mark-$now_string_g--";
	sysopen( STATUS, "$CMD_STATUS", O_RDONLY ) || die "can't open '$CMD_STATUS'";
	$pos[ 0 ] = 0;
	while ( <STATUS> ) { $pos[ $#pos + 1 ] = tell if /^$/; }
	for ( $i = 0 ; $i < $#pos ; $i++ ) {
		seek( STATUS, $pos[ $i ], seek_set ) || die "can't seek!";
		while ( <STATUS> ) { last if /^$/; $debs[ $i ] .= $_; }
	}
	close STATUS;
	for ( $i = 0 ; $i < $#debs + 1 ; $i++ ) {
		if ( $debs[ $i ] =~ /^Status:.* installed$/im ) {
			$debs[ $i ] =~ s/^Package:(.*)$(\n.*)*^Status:(.*)$(\n.*)*^Installed-Size:(.*)$(\n.*)*^Version:(.*)$(\n.*)*^Description:(.*)$(\n.*)*/$1$mark$3$mark$5$mark$7$mark$9/m;
			my ( $name, $status, $size, $version, $description ) = split( /$mark/, $debs[ $i ] );
			$total += $size;
			$num++;
			siprt( "tabrow" );
			siprtt( "cell",     $name );
			siprtt( "cell",     $status );
			siprtt( "cell",     $version );
			siprtt( "cell",     $size );
			siprtt( "cellwrap", $description );
			siprt( "endrow" );
		}
	}
	siprt( "tabrow" );
	siprtt( "tabhead", "Total" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", int( $total / 1024 ) . " MBytes" );
	siprtt( "tabhead", $num . " packets" );
	siprt( "endrow" );
	siprt( "endtab" );
}

sub si_installed_sles() {
	siprtt( "h1", "Installed Packages" );
	if ( -x $CMD_INSTSRC ) {
		siprtt( "h2", "Installation Sources" );
		siprt( "pre" );
		open( INSTSRC, "$CMD_INSTSRC -s |" );
		while ( <INSTSRC> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( INSTSRC );
		siprt( "endpre" );
	}
	my $total = 0;
	my $num   = 0;
	my @packagers;
	open( PACKS, "$CMD_RPM -qa --queryformat '%{DISTRIBUTION}::%{PACKAGER}\n' | $CMD_SORT | $CMD_UNIQ |" );
	while ( <PACKS> ) { push @packagers, $_; }
	close( PACKS );
	my @rpms;
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{VERSION}-%{RELEASE}::%{SIZE}::%{SUMMARY}::%{DISTRIBUTION}::%{PACKAGER}::a\n' |" );
	while ( <RPMS> ) { push @rpms, $_; }
	close( RPMS );
	for $pack ( sort @packagers ) {
		chomp $pack;
		my ( $mydist, $mypack ) = split /::/, $pack;
		chomp $mydist;
		chomp $mypack;
		# $mypack =~ s/\&/\&amp;/g;
		# $mypack =~ s/</\&lt;/g;
		# $mypack =~ s/>/\&gt;/g;
		if ( $mypack eq $ULPACK_RAW_NAME ) {
			siprtt( "h2", "$mydist" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mydist", 4 );
		} elsif ( $mypack =~ $SUSEPACK_RAW_NAME ) {
			siprtt( "h2", "$mydist" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mydist", 4 );
		} elsif ( $mydist eq "(none)" ) {
			siprtt( "h2", "Packages by $mypack" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mypack", 4 );
		} else {
			siprtt( "h2", "$mydist ($mypack)" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mydist ($mypack)", 4 );
		}
		siprt( "tabrow" );
		siprtt( "tabhead", "Name" );
		siprtt( "tabhead", "Version" );
		siprtt( "tabhead", "Size" );
		siprtt( "tabhead", "Short Description" );
		siprt( "endrow" );
		my $packtotal = 0;
		my $packnum   = 0;
		for $rpm ( sort @rpms ) {
			my ( $name, $ver, $size, $summary, $distrib, $packager, $aa ) = split /::/, $rpm;
			#	print STDERR "|$rpm|\n\t\t"."|$pack|"."\n\t\t\t".$distrib."::".$packager."\n";
			if ( ( $pack ) eq ( $distrib . "::" . $packager ) ) {
				$total += $size;
				$num++;
				$packtotal += $size;
				$packnum++;
				siprt( "tabrow" );
				siprtt( "cell",     $name );
				siprtt( "cell",     $ver );
				siprtt( "cell",     $size );
				siprtt( "cellwrap", $summary );
				siprt( "endrow" );
			}
		}
		siprt( "tabrow" );
		siprtt( "tabhead", "Total" );
		siprtt( "tabhead", "" );
		siprtt( "tabhead", int( $packtotal / 1024 ) . " KBytes" );
		siprtt( "tabhead", $packnum . " packets" );
		siprt( "endrow" );
		siprt( "endtab" );
	}
	siprtt( "h2", "Summary" );
	siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: Summary", 4 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Total" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", int( $total / 1024 ) . " KBytes" );
	siprtt( "tabhead", $num . " packets" );
	siprt( "endrow" );
	siprt( "endtab" );
}

sub si_installed_rpm() {
	siprtt( "h1", "Installed Packages" );
	siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages", 4 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Name" );
	siprtt( "tabhead", "Version" );
	siprtt( "tabhead", "Size" );
	siprtt( "tabhead", "Short Description" );
	siprt( "endrow" );
	my $total = 0;
	my $num   = 0;
	my @rpms;
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{VERSION}::%{SIZE}::%{SUMMARY}\n' |" );
	while ( <RPMS> ) { push @rpms, $_; }
	close( RPMS );
	for $rpm ( sort @rpms ) {
		my ( $name, $ver, $size, $summary ) = split /::/, $rpm;
		$total += $size;
		$num++;
		siprt( "tabrow" );
		siprtt( "cell",     $name );
		siprtt( "cell",     $ver );
		siprtt( "cell",     $size );
		siprtt( "cellwrap", $summary );
		siprt( "endrow" );
	}
	close( RPMS );
	siprt( "tabrow" );
	siprtt( "tabhead", "Total" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", int( $total / 1024 ) . " KBytes" );
	siprtt( "tabhead", $num . " packets" );
	siprt( "endrow" );
	siprt( "endtab" );
}

sub si_selection_deb() {
	my $deb_sel = "sitar-$HOSTNAME-deb-selections";
	sysopen( DEBSEL, "$deb_sel", O_CREAT | O_EXCL | O_WRONLY ) || die "can't create '$deb_sel'!";
	open( IN, "$CMD_DPKG --get-selections |" );
	while ( <IN> ) {
		print DEBSEL $_;
	}
	close IN;
	close DEBSEL;
}

sub si_selection_rpm() {
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{SIZE}\n' |" );
	my $total = 0;
	my $num   = 0;
	my @rpms  = ();
	while ( <RPMS> ) {
		my ( $name, $size ) = split /::/;
		push @rpms, $name;
		$total += $size;
		$num++;
	}
	close( RPMS );
	print "\# SuSE-Linux Configuration : ", int( $total / 1024 ), " : ", $num, "\n", "Description: $HOSTNAME $now_string_g\n", "Info:\n", "Ofni:\n", "Toinstall:\n";
	for $rr ( sort @rpms ) { print $rr, "\n"; }
	print "Llatsniot:\n";
}
