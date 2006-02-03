sub si_find_unpacked($$$$) {
	chomp( my ( $funpconfdir, $funpfile, $ddd, $ignore_binary ) = @_ );
	my %configfiles = ();
	for $NN ( `$CMD_FIND $ddd -type f` ) {
		chomp $NN;
		chomp( my $res = `$CMD_RPM -qf $NN` );
		if ( $res =~ /is not owned by any package$/ ) {
			if ( ( $NN !~ /~$/ ) && ( -r $NN ) ) {
				chomp( $type = `$CMD_FILE -p -b $NN` );
				if ( $ignore_binary && ( ( $type =~ /^Berkeley DB/ ) || ( $type =~ /data/ ) ) ) {
					si_debug( sprintf "---\t", $type, "\t", $NN );
				} else {
					si_debug( sprintf "\t", $type, "\t", $NN );
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
