#
# read config file
#
sub si_set_on_find($$$) {
	my ( $line, $parm, $VAR ) = @_;
	if ( $line =~ /$parm/ ) {
		my ( $dummy, $FOUND_VAR ) = split( /.*=\s*/, $line );
		$FOUND_VAR =~ s/^\"//;
		$FOUND_VAR =~ s/\"$//;
		return $FOUND_VAR;
	}
	chomp $VAR;
	return $VAR;
}

sub si_parse_conf_file($) {
	my $fname = shift;
	my $dummy;
	if ( -r $fname ) {
		open( CONFIG_DATA, "$fname" ) || die "could not open \"$fname\": $!";
		while ( my $line = <CONFIG_DATA> ) {
			next if $line =~ /^#|^$/;
			chomp( $line );
			$SITAR_OPT_FORMAT         = si_set_on_find( $line, "SITAR_OPT_FORMAT",         $SITAR_OPT_FORMAT );
			$SITAR_OPT_OUTDIR         = si_set_on_find( $line, "SITAR_OPT_OUTDIR",         $SITAR_OPT_OUTDIR );
			$SITAR_OPT_OUTFILE        = si_set_on_find( $line, "SITAR_OPT_OUTFILE",        $SITAR_OPT_OUTFILE );
			$SITAR_OPT_LIMIT          = si_set_on_find( $line, "SITAR_OPT_LIMIT",          $SITAR_OPT_LIMIT );
			$SITAR_OPT_GCONF          = si_set_on_find( $line, "SITAR_OPT_GCONF",          $SITAR_OPT_GCONF );
			$SITAR_OPT_ALLCONFIGFILES = si_set_on_find( $line, "SITAR_OPT_ALLCONFIGFILES", $SITAR_OPT_ALLCONFIGFILES );
			$SITAR_OPT_ALLSUBDOMAIN   = si_set_on_find( $line, "SITAR_OPT_ALLSUBDOMAIN",   $SITAR_OPT_ALLSUBDOMAIN );
			$SITAR_OPT_ALLSYSCONFIG   = si_set_on_find( $line, "SITAR_OPT_ALLSYSCONFIG",   $SITAR_OPT_ALLSYSCONFIG );
			$SITAR_OPT_LVMARCHIVE     = si_set_on_find( $line, "SITAR_OPT_LVMARCHIVE",     $SITAR_OPT_LVMARCHIVE );
		}
		close( CONFIG_DATA );
	}
}

sub si_prepare_config() {
	# read configuration file
	si_parse_conf_file( $SITAR_CONFIG_FILE );
	# parse command line options
	GetOptions(
		'f|format=s'          => \$SITAR_OPT_FORMAT,
		'o|outfile=s'         => \$SITAR_OPT_OUTFILE,
		'c|check-consistency' => \$SITAR_OPT_CONSISTENCY,
		'u|find-unpacked'     => \$SITAR_OPT_FINDUNPACKED,
		'h|help'              => \$SITAR_OPT_HELP,
		'v|version'           => \$SITAR_OPT_VERSION
	);
}
