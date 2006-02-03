#
#	group_configurations
#
sub si_conf_filename_stat($$$) {
	my ( $filename, $comment, $call_stat ) = @_;
	if ( $call_stat == 1 ) {
		( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $filename );
	}
	siprtttt( "tabborder", "ll", "stat:$filename", 2 );
	siprt( "tabrow" );
	siprtt( "cell", "uid gid" );
	siprtt( "cell", "$ff_uid $ff_gid" );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "mode" );
	siprtt( "cell", sprintf "%lo", ( $ff_mode & 07777 ) );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "size" );
	siprtt( "cell", $ff_size );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "mtime" );
	siprtt( "cell", localtime( $ff_mtime ) );
	siprt( "endrow" );
	if ( $comment ne "" ) {
		siprt( "tabrow" );
		siprtt( "cell", "line comment char" );
		siprtt( "cell", $comment );
		siprt( "endrow" );
	}
	siprt( "endtab" );
}

sub si_conf_secure($$$) {
	my ( $filename, $comment, $blankout ) = @_;
	( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $filename );
	if ( $NN !~ /(\w*\.orig$)|(\w*\.org$)|(\w*\.ori$)|(\w*\.bak$)|(\w*\.bac$)|(\w*\~)|(\#\w*)/ ) {
		siprtt( "h3", $filename );
		# print STDERR $filename, ": ", $comment, "\n";
		si_conf_filename_stat( $filename, $comment, 0 );
		siprt( "pre" );
		if ( $comment eq "/**/" ) {
			open( CONFIG, $filename );
			my $old_recsep = $/;
			undef $/;
			$ttt = <CONFIG>;
			$ttt =~ s#/\*.*?\*/##gs;
			$ttt =~ s#//.*##g;
			$ttt =~ s/\n\s*\n/\n/gs;
			close( CONFIG );
			siprtt( "verb", $ttt );
			$/ = $old_recsep;
		} else {
			open( CONFIG, "<$filename" );
			while ( <CONFIG> ) {
				chomp();
				if ( !m/^\s*($comment)|^\s*$|^$/ ) {
					if ( m/$blankout/ ) {
						s/($blankout.*=)(.*)/$1### sensitive data blanked out ###/;
					}
					siprtt( "verb", "$_\n" );
				}
			}
			close( CONFIG );
		}
		siprt( "endpre" );
	}
}

sub si_conf($$$) {
	my ( $title, $filename, $comment ) = @_;
	( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $filename );
	if ( $NN !~ /(\w*\.orig$)|(\w*\.org$)|(\w*\.ori$)|(\w*\.bak$)|(\w*\.bac$)|(\w*\~)|(\#\w*)/ ) {
		$SITAR_OPT_LVMARCHIVE =~ tr/A-Z/a-z/;
		$SITAR_OPT_GCONF      =~ tr/A-Z/a-z/;
		if ( exists( $ignoreconfigfiles{ $filename } ) ) {
			# debug
		} elsif ( ( $SITAR_OPT_LVMARCHIVE eq "no" ) && ( $filename =~ /etc\/lvm\/archive/ ) ) {
			# print "file below /etc/lvm/archive/ found; skipped $fname\n";
		} elsif ( ( $SITAR_OPT_GCONF eq "no" ) && ( $filename =~ /etc\/opt\/gnome/ ) ) {
			# print "GCONF below /etc/opt/gnome/gconf/ found; skipped $fname\n";
		} elsif ( ( $SITAR_OPT_LIMIT > 0 ) && ( $ff_size > $SITAR_OPT_LIMIT ) ) {
			# print "LIMIT exceed; skipped $fname\n";
		} else {
			if ( $title eq $filename ) {
				siprtt( "h3", "$filename" );
			} else {
				siprtt( "h3", "$title - $filename" );
			}
			si_conf_filename_stat( $filename, $comment, 0 );
			# print STDERR $filename, ": ", $comment, "\n";
			siprt( "pre" );
			if ( $comment eq "/**/" ) {
				open( CONFIG, $filename );
				my $old_recsep = $/;
				undef $/;
				$ttt = <CONFIG>;
				$ttt =~ s#/\*.*?\*/##gs;
				$ttt =~ s#//.*##g;
				$ttt =~ s/\n\s*\n/\n/gs;
				close( CONFIG );
				siprtt( "verb", $ttt );
				$/ = $old_recsep;
			} elsif ( $comment eq "" ) {
				open( CONFIG, "<$filename" );
				while ( <CONFIG> ) {
					chomp();
					siprtt( "verb", "$_\n" );
				}
				close( CONFIG );
			} else {
				open( CONFIG, "<$filename" );
				while ( <CONFIG> ) {
					chomp();
					if ( !m/^\s*($comment)|^\s*$|^$/ ) {
						siprtt( "verb", "$_\n" );
					}
				}
				close( CONFIG );
			}
			siprt( "endpre" );
		}
	}
}
