#
# core
#
sub si_prepare() {
	mkdir( "$CFG2SCM_OPT_TMP" );
	chdir( "$CFG2SCM_OPT_TMP" );
	if ( $CFG2SCM_OPT_STORAGE eq "svn" ) {
		system( "$CMD_SVN co $CFG2SCM_SVN_AUTH $CFG2SCM_OPT_BASE_URL/$CFG2SCM_OPT_REPOS" );
	}
	chdir( "$CFG2SCM_OPT_TMP/$CFG2SCM_OPT_REPOS" );
}

sub si_add($) {
	chomp( my ( $fname ) = @_ );
	chomp( my $ddd       = `$CMD_DIRNAME $fname` );
	chomp( my $bbb       = `$CMD_BASENAME $fname` );
	if ( !$CFG2SCM_OPT_DEBUG ) {
		open( SAVEERR, ">&STDERR" );
		open( STDERR,  ">/dev/null" );
	}
	$CFG2SCM_OPT_LVMARCHIVE =~ tr/A-Z/a-z/;
	$CFG2SCM_OPT_GCONF      =~ tr/A-Z/a-z/;
	my ( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $fname );
	if ( ( $CFG2SCM_OPT_LVMARCHIVE eq "no" ) && ( $fname =~ /etc\/lvm\/archive/ ) ) {
		print "file below /etc/lvm/archive/     skipped $fname\n";
	} elsif ( ( $CFG2SCM_OPT_GCONF eq "no" ) && ( $fname =~ /etc\/opt\/gnome/ ) ) {
		print "file below /etc/opt/gnome/gconf/ skipped $fname\n";
	} elsif ( ( $CFG2SCM_OPT_LIMIT > 0 ) && ( $ff_size > $CFG2SCM_OPT_LIMIT ) ) {
		printf( "LIMIT of %7d Bytes exceeded; skipped %s\n", $CFG2SCM_OPT_LIMIT, $fname );
	} else {
		if ( $CFG2SCM_OPT_STORAGE eq "svn" ) {
			system( "$CMD_SVN mkdir ./$ddd " );
			system( "$CMD_CP -a $fname ./$ddd/ " );
			system( "$CMD_SVN add ./$fname" );
		} else {
			system( "$CMD_MKDIR -p ./$ddd " );
			system( "$CMD_CP -a $fname ./$ddd/ " );
		}
	}
	if ( !$CFG2SCM_OPT_DEBUG ) {
		open( STDERR, ">&SAVEERR" );
	}
}

sub si_read_and_eval_includes() {
	if ( -d $CFG2SCM_CONFIG_DIR ) {
		my @configfiles = ();
		@configfiles = `$CMD_FIND $CFG2SCM_CONFIG_DIR -iname "*.include" -type f`;
		if ( $#configfiles > -1 ) {
			for $NN ( @configfiles ) {
				chomp $NN;
				si_debug( $NN );
				%myfiles = ();
				do "$NN";
				foreach ( @files ) {
					$myfiles{ $_ } = 0;
				}
				foreach $mm ( sort keys %myfiles ) {
					if ( $mm !~ /proc/ ) {
						if ( -r $mm ) {
							si_add( $mm );
						}
					}
				}
			}
			return 0;
		} else {
			si_attention_no_filelists();
			return -1;
		}
	}
}

sub si_commit_cvs() {
	system( "$CMD_CVS -d $CFG2SCM_OPT_BASE_URL import -m '$CFG2SCM_OPT_MESSAGE' $CFG2SCM_OPT_REPOS 'v$NOW' auto" );
	#  cvs import -m "Imported sources" yoyodyne/RDIR yoyo start
}

sub si_store_tar() {
	chomp( my $basefilename  = `$CMD_BASENAME $CFG2SCM_OPT_OUTFILE .$CFG2SCM_OPT_STORAGE` );
	chomp( my $filedirname   = `$CMD_DIRNAME  $CFG2SCM_OPT_OUTFILE` );
	chomp( my $tmpdirname    = `$CMD_BASENAME $CFG2SCM_OPT_TMP` );
	chomp( my $tmpdirprefix  = `$CMD_DIRNAME  $CFG2SCM_OPT_TMP` );
	chomp( my $storefilename = $filedirname . "/" . $basefilename . "." . $CFG2SCM_OPT_STORAGE );
	si_debug( sprintf "tmp directory='$CFG2SCM_OPT_TMP'" );
	si_debug( sprintf "storefilename='$storefilename'" );
	chdir( $tmpdirprefix );
	if ( $CFG2SCM_OPT_STORAGE eq "tar" ) {
		system( "$CMD_TAR cspf  $storefilename $tmpdirname" );
	} elsif ( $CFG2SCM_OPT_STORAGE eq "tar.gz" ) {
		system( "$CMD_TAR cszpf $storefilename $tmpdirname" );
	} elsif ( $CFG2SCM_OPT_STORAGE eq "tar.bz2" ) {
		system( "$CMD_TAR csjpf $storefilename $tmpdirname" );
	}
}

sub si_commit_svn() {
	if ( !$CFG2SCM_OPT_DEBUG ) {
		open( SAVEERR, ">&STDERR" );
		open( STDERR,  ">/dev/null" );
		open( SAVEOUT, ">&STDOUT" );
		open( STDOUT,  ">/dev/null" );
	}
	system( "$CMD_SVN add *" );
	system( "$CMD_FIND . -iname '*.html' -exec $CMD_SVN propset svn:mime-type text/html {} \\; " );
	system( "$CMD_FIND . -iname '*.conf' -exec $CMD_SVN propset svn:mime-type text/plain {} \\; " );
	system( "$CMD_FIND . -iname '*.txt'  -exec $CMD_SVN propset svn:mime-type text/plain {} \\; " );
	system( "$CMD_FIND . -iname '*.png'  -exec $CMD_SVN propset svn:mime-type image/png {} \\; " );
	system( "$CMD_FIND . -iname '*.tex'  -exec $CMD_SVN propset svn:mime-type application/x-latex {} \\; " );
	system( "$CMD_FIND . -iname '*.dvi'  -exec $CMD_SVN propset svn:mime-type application/x-dvi {} \\; " );
	system( "$CMD_FIND . -iname '*.pdf'  -exec $CMD_SVN propset svn:mime-type application/pdf {} \\; " );
	system( "$CMD_FIND . -iname '*.doc'  -exec $CMD_SVN propset svn:mime-type application/msword {} \\; " );
	system( "$CMD_FIND . -iname '*.xls'  -exec $CMD_SVN propset svn:mime-type application/excel {} \\; " );
	system( "$CMD_FIND . -iname '*.sxw'  -exec $CMD_SVN propset svn:mime-type application/vnd.sun.xml.writer {} \\; " );
	system( "$CMD_FIND . -iname '*.sxi'  -exec $CMD_SVN propset svn:mime-type application/vnd.sun.xml.impress {} \\; " );
	system( "$CMD_FIND . -iname '*.sxc'  -exec $CMD_SVN propset svn:mime-type application/vnd.sun.xml.calc {} \\; " );
	system( "$CMD_FIND . -iname '*.ppt'  -exec $CMD_SVN propset svn:mime-type application/octet-stream {} \\; " );
	system( "$CMD_FIND . -iname '*.rpm'  -exec $CMD_SVN propset svn:mime-type application/octet-stream {} \\; " );
	if ( !$CFG2SCM_OPT_DEBUG ) {
		open( STDERR, ">&SAVEERR" );
		open( STDOUT, ">&SAVEOUT" );
	}
	system( "$CMD_SVN commit $CFG2SCM_SVN_AUTH -m '$CFG2SCM_OPT_MESSAGE' " );
}
