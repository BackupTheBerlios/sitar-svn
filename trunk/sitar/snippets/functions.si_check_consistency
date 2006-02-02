
sub si_check_consistency($$$) {
	chomp( my ( $consconfdir, $consfile, $consdebug ) = @_ );
	my %configfiles = ();
	if ( !$consdebug ) {
		open( SAVEERR, ">&STDERR" );
		open( STDERR,  ">/dev/null" );
	}
	open( CONFIGFILES, "$CMD_RPM -qca |" );
	while ( <CONFIGFILES> ) {
		chomp();
		my $ccc = $_;
		if ( $ccc =~ /^\// ) {
			open( ONERPM, "$CMD_RPM -Vf --nodeps --noscript $ccc |" );
			while ( <ONERPM> ) {
				chomp();
				if ( $_ && ( $_ !~ /^missing/ ) ) {
					$ddd = substr( $_, index( $_, "/" ) );
					if ( $ddd eq $ccc ) {
						$configfiles{ $ddd } = 1;
					}
				}
			}
			close( ONERPM );
		}
	}
	close( CONFIGFILES );
	if ( !-d "$consconfdir" ) {
		mkdir $consconfdir;
	}
	open( CONSISTENCY, ">$consconfdir/$consfile" );
	print CONSISTENCY "\n\@files = (\n";
	foreach my $kkk ( sort keys %configfiles ) {
		print CONSISTENCY "\"", $kkk, "\",\n";
	}
	print CONSISTENCY ");\n\n";
	close( CONSISTENCY );
	if ( !$consdebug ) {
		open( STDERR, ">&SAVEERR" );
	}
}

