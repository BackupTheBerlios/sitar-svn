#
# configfile
#
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
