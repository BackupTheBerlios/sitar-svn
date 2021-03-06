#
# minor
#
# si_now_gmt()
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
# si_debug( text );
#
sub si_debug($) {
	my ( $text ) = @_;
	if ( $CFG2SCM_OPT_DEBUG ) {
		print $text, "\n";
	}
}
