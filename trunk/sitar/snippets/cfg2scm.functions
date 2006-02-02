#
# functions
#
# 1. si_now_gmt()
#
sub si_now_gmt() {
	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = gmtime( time );
	$year += 1900;
	$mon  += 1;
	$mon  = sprintf( "%02d", $mon );
	$mday = sprintf( "%02d", $mday );
	$hour = sprintf( "%02d", $hour );
	$gmt  = "gmt";
	return "$year$mon$mday$hour$gmt";
}
#
# 2. si_debug( text );
#
sub si_debug($) {
	my ( $text ) = @_;
	if ( $CFG2SCM_OPT_DEBUG ) {
		print $text, "\n";
	}
}

sub si_set_on_find($$$) {
	my ( $line, $parm, $VAR ) = @_;
	if ( $line =~ /$parm/ ) {
		my ( $dummy, $FOUND_VAR ) = split( /.*=\s*/, $line );
		$FOUND_VAR =~ s/^\"//;
		$FOUND_VAR =~ s/\"$//;
		return $FOUND_VAR;
	}
	return $VAR;
}

sub si_parse_conf_file($) {
	my $fname = shift;
	my $dummy;
	open( CONFIG_DATA, "$fname" ) || die "could not open \"$fname\": $!";
	while ( my $line = <CONFIG_DATA> ) {
		next if $line =~ /^#|^$/;
		chomp( $line );
		$CFG2SCM_OPT_TMP        = si_set_on_find( $line, "CFG2SCM_OPT_TMP",        $CFG2SCM_OPT_TMP );
		$CFG2SCM_OPT_BASE_URL   = si_set_on_find( $line, "CFG2SCM_OPT_BASE_URL",   $CFG2SCM_OPT_BASE_URL );
		$CFG2SCM_OPT_REPOS      = si_set_on_find( $line, "CFG2SCM_OPT_REPOS",      $CFG2SCM_OPT_REPOS );
		$CFG2SCM_OPT_USER       = si_set_on_find( $line, "CFG2SCM_OPT_USER",       $CFG2SCM_OPT_USER );
		$CFG2SCM_OPT_PASS       = si_set_on_find( $line, "CFG2SCM_OPT_PASS",       $CFG2SCM_OPT_PASS );
		$CFG2SCM_OPT_MESSAGE    = si_set_on_find( $line, "CFG2SCM_OPT_MESSAGE",    $CFG2SCM_OPT_MESSAGE );
		$CFG2SCM_OPT_STORAGE    = si_set_on_find( $line, "CFG2SCM_OPT_STORAGE",    $CFG2SCM_OPT_STORAGE );
		$CFG2SCM_OPT_OUTFILE    = si_set_on_find( $line, "CFG2SCM_OPT_OUTFILE",    $CFG2SCM_OPT_OUTFILE );
		$CFG2SCM_OPT_LIMIT      = si_set_on_find( $line, "CFG2SCM_OPT_LIMIT",      $CFG2SCM_OPT_LIMIT );
		$CFG2SCM_OPT_GCONF      = si_set_on_find( $line, "CFG2SCM_OPT_GCONF",      $CFG2SCM_OPT_GCONF );
		$CFG2SCM_OPT_LVMARCHIVE = si_set_on_find( $line, "CFG2SCM_OPT_LVMARCHIVE", $CFG2SCM_OPT_LVMARCHIVE );
	}
	close( CONFIG_DATA );
}

sub si_prepare_config() {
	# read configuration file
	si_parse_conf_file( $CFG2SCM_CONFIG_FILE );
	# parse command line options
	GetOptions(
		'c|check-consistency' => \$CFG2SCM_OPT_CONSISTENCY,
		'b|base-url=s'        => \$CFG2SCM_OPT_BASE_URL,
		'd|debug'             => \$CFG2SCM_OPT_DEBUG,
		'f|find-unpacked'     => \$CFG2SCM_OPT_FINDUNPACKED,
		'h|help'              => \$CFG2SCM_OPT_HELP,
		'l|limit=i'           => \$CFG2SCM_OPT_LIMIT,
		'm|message=s'         => \$CFG2SCM_OPT_MESSAGE,
		'n|non-root=s'        => \$CFG2SCM_OPT_NON_ROOT,       # undocumented, testing only
		'o|outfile=s'         => \$CFG2SCM_OPT_OUTFILE,
		'p|password=s'        => \$CFG2SCM_OPT_PASS,
		'r|repository=s'      => \$CFG2SCM_OPT_REPOS,
		's|storage=s'         => \$CFG2SCM_OPT_STORAGE,
		'u|username=s'        => \$CFG2SCM_OPT_USER,
		'v|version'           => \$CFG2SCM_OPT_VERSION
	);
	# subversion authentication string
	if ( ( $CFG2SCM_OPT_USER ) && ( $CFG2SCM_OPT_USER ne "" ) ) {
		$CFG2SCM_SVN_AUTH = "--username $CFG2SCM_OPT_USER";
		if ( ( $CFG2SCM_OPT_PASS ) && ( $CFG2SCM_OPT_PASS ne "" ) ) {
			$CFG2SCM_SVN_AUTH = "--username $CFG2SCM_OPT_USER --password $CFG2SCM_OPT_PASS";
		}
	}
}

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
		system( " $CMD_MKDIR -p ./$ddd " );
		system( " cp -a $fname ./$ddd/ " );
		if ( $CFG2SCM_OPT_STORAGE eq "svn" ) {
			system( "$CMD_SVN add ./$fname" );
		}
	}
	if ( !$CFG2SCM_OPT_DEBUG ) {
		open( STDERR, ">&SAVEERR" );
	}
}

sub si_attention_no_filelists() {
	print "Attention:
\tno file-lists have been found. Please write your own
\tand put it as $CFG2SCM_CONFIG_DIR/<name>.include
\tor let CFG2SCM produce some with
\t--check-consistency
\t\tand/or
\t--find-unpacked\n";
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

sub si_print_version () {
	print "cfg2scm.pl -\tCheck configuration changes into SCM - Release ", $CFG2SCM_RELEASE, "-", $CFG2SCM_SVNVERSION, "\nCopyright (C) ", $CFG2SCM_COPYRIGHT, "\n";
}

sub si_print_help () {
	print "Options:
\t--base-url=<url>\tmain path to subversion repositories (mandatory)\n\t\t\t\tdefault: $CFG2SCM_OPT_BASE_URL
\t--repository=<name>\tname of the one repository to be used (mandatory)\n\t\t\t\tdefault: $CFG2SCM_OPT_REPOS
\t--debug
\t--check-consistency
\t--find-unpacked
\t--limit=<max filesize; 0=no limit>
\t--username=<username>
\t--password=<password>
\t--message=<commit msg>
\t--outfile=<file>
\t--storage=<svn|cvs|tar|tar.gz|tar.bz2>
\t--help\t\t\tthis page
\t--version\t\tprintout CFG2SCM version";
}

sub si_warn_no_root() {
	print "Attention:
\tyou have choosen to run the program as non-root-user;
\tthis is for testing purposes only.\n"
}

sub si_attention_no_config() {
	print "Attention:
\tyou have to set at least the 'storage' type,
\teither on the commandline or in the configuration-file
\t\t$CFG2SCM_CONFIG_FILE
\tFor storage types 'cvs' or 'svn', please also provide
\t'base-url' and 'repository'.\n";
}

