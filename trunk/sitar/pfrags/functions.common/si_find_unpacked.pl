
sub si_find_unpacked($$$$) {
	chomp( my ( $funpconfdir, $funpfile, $ddd, $ignore_binary ) = @_ );
	my %configfiles  = ();
	my @allrpmfiles  = `$CMD_RPM -qla`;
	my %testrpmfiles = ();
	my @allrealfiles = `$CMD_FIND $ddd -type f`;
	for $arf( @allrpmfiles ) {
		chomp( $arf );
		if( $arf =~ /^$ddd/ ) {
			$testrpmfiles{ $arf } = $arf;
		}
	}
	for $NN ( @allrealfiles ) {
		chomp $NN;
		if( $testrpmfiles{ $NN } ne $NN ) {
			if ( ( $NN !~ /~$/ ) && ( -r $NN ) ) {
				chomp( $type = `$CMD_FILE -p -b $NN` );
				if ( $ignore_binary && ( ( $type =~ /^Berkeley DB/ ) || ( $type =~ /data/ ) ) ) {
				} else {
					$configfiles{ $NN } = 1;
				}
			}
		}
	}
	if ( !-d "$funpconfdir" ) {
		mkdir $funpconfdir;
	}
	open( FINDUNPACKED, ">$funpconfdir/$funpfile" );
	print FINDUNPACKED "\n\@files = (\n";
	foreach my $kkk ( sort keys %configfiles ) {
		print FINDUNPACKED "\"", $kkk, "\",\n";
	}
	print FINDUNPACKED ");\n\n";
	close( FINDUNPACKED );
}

