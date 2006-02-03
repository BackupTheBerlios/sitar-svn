#
#	si_selection_yast2
#
sub si_selection_yast2( ) {
	my %total = ( ul => 0, sles => 0, addon => 0, suse => 0 );
	my %num   = ( ul => 0, sles => 0, addon => 0, suse => 0 );
	my %rpms = ( ul => (), sles => (), addon => (), suse => () );
	my %ords = ( ul => 1, sles => 2, addon => 4, suse => 3 );
	my @alltypes = qw ( addon sles suse ul );
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{SIZE}::%{PACKAGER}::%{DISTRIBUTION}\n' |" );
	while ( <RPMS> ) {
		my ( $name, $size, $mypack, $distri ) = split /::/;
		chomp $mypack;
		chomp $distri;
		if ( $mypack eq $ULPACK_RAW_NAME ) {
			push @{ $rpms{ 'ul' } }, $name;
			$total{ 'ul' } += $size;
			$num{ 'ul' }++;
		} elsif ( $mypack eq $SUSEPACK_RAW_NAME ) {
			if ( $distri =~ "SLES" ) {
				push @{ $rpms{ 'sles' } }, $name;
				$total{ 'sles' } += $size;
				$num{ 'sles' }++;
			} else {
				push @{ $rpms{ 'suse' } }, $name;
				$total{ 'suse' } += $size;
				$num{ 'suse' }++;
			}
		} else {
			push @{ $rpms{ 'addon' } }, $name;
			$total{ 'addon' } += $size;
			$num{ 'addon' }++;
		}
	}
	close( RPMS );
	foreach $mytype ( @alltypes ) {
		if ( $num{ $mytype } > 0 ) {
			$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$mytype-$HOSTNAME-yast2.sel";
			if ( $SITAR_OPT_OUTFILE ne "" ) {
				open( STDOUT, ">$SITAR_OPT_OUTFILE" );
			}
			print "\# SuSE Linux Package Selection 3.0 (c) 2002 SUSE LINUX AG\n";
			print "\# generated on ", $now_string_g, " by SITAR ", $SITAR_RELEASE, "\n\n";
			print "=Ver: 3.0\n\n";
			print "=Sel: ", $mytype, "-sitar-", $HOSTNAME, " ", $SITAR_RELEASE, "\n\n";
			print "=Siz: ", $total{ $mytype }, " ", $total{ $mytype }, "\n\n";
			print "=Sum: ",    $mytype, " selection of '", $HOSTNAME, "'; by SITAR on ", $now_string_g, "\n";
			print "=Sum.de: ", $mytype, " Auswahl für '", $HOSTNAME, "'; SITAR am ",    $now_string_g, "\n";
			my @alllanguages = qw ( cs el_GR en es fr gl hu it ja lt nl pt pt_BR sl_SI sv tr);
			foreach $ll ( sort @alllanguages ) {
				print "=Sum.", $ll, ": SITAR '", $HOSTNAME, "', ", $now_string_g, "\n";
			}
			if ( $mytype eq "ul" ) {
				print "\n=Cat: baseconf\n\n";
			} else {
				print "\n=Cat: addon\n\n";
			}
			print "=Ord: 01", $ords{ $mytype }, "\n\n";
			print "=Vis: true\n\n";
			print "+Ins:\n";
			for $rr ( sort @{ $rpms{ $mytype } } ) { print $rr, "\n"; }
			print "-Ins:\n\n";
		}
	}
}
