
sub si_check_consistency($$$) {
	chomp( my ( $consconfdir, $consfile, $consdebug ) = @_ );
	my %configfiles = ();
	my %brokenfiles = ();
	my %packlist=();
	my $packname="";
	my $rrr, $ddd;
	open( CONFIGFILES, "$CMD_RPM -qca --queryformat '%{NAME}\n'|" );
	while ( <CONFIGFILES> ) {
		if( $_ !~ '^\(' ) {
			if( $_ !~ '^/' ) {
				chomp();
				$packname=$_;
			} else {
				$packlist{ $packname }=1;
				chomp();
				$configfiles{ $_ } = $packname;
			}
		}
	}
	close( CONFIGFILES );
	for $rrr ( sort keys %packlist ) {
		chomp( $rrr );
		open( ONERPM, "$CMD_RPM -V --nodeps --noscript $rrr |" );
		while ( <ONERPM> ) {
			chomp();
			if ( $_ && ( $_ !~ /^missing/ ) ) {
				$ddd = substr( $_, index( $_, "/" ) );
				chomp( $ddd );
				if ( $configfiles{ $ddd } eq $rrr ) {
					$brokenfiles{ $ddd } = 1;
				}
			}
		}
		close( ONERPM );
	}
	if ( !-d "$consconfdir" ) {
		mkdir $consconfdir;
	}
	open( CONSISTENCY, ">$consconfdir/$consfile" );
	print CONSISTENCY "\n\@files = (\n";
	foreach my $kkk ( sort keys %brokenfiles ) {
		print CONSISTENCY "\"", $kkk, "\",\n";
	}
	print CONSISTENCY ");\n\n";
	close( CONSISTENCY );
}

