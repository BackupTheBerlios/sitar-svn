#
# si_now_gmt()
#
sub si_now_gmt() {
	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = gmtime( time );
	$year += 1900;
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
	if ( $SITAR_OPT_DEBUG ) {
		my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = gmtime( time );
		$year += 1900;
		$mon  = sprintf( "%02d", $mon );
		$mday = sprintf( "%02d", $mday );
		$hour = sprintf( "%02d", $hour );
		$min  = sprintf( "%02d", $min  );
		$sec  = sprintf( "%02d", $sec  );
		print STDERR "$year$mon$mday $hour$min$sec: $text\n";
	}
}
#
#
#
sub si_getopts($) {
}
