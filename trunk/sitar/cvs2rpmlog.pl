#!/usr/bin/perl

use	POSIX qw(strftime);
my	$log_block=0;

while (<STDIN>) {
	if ( m/^\#  \$Log:/gi ) {
		$log_block=1;
		print "1: ", $_;
	}
	if ( $log_block==1 ) {
		
		if ( m/^\#  Revision/gi ) {
			($begin, $rev, $revnum, $date, $time, $user ) = split;
			my ( $year, $month, $day) = split( "/", $date, 3 );
			$newdate = strftime( "%a %b %d %Y", 0, 0,  1, $day, $month, $year-1900 );
			print "* ", $newdate, " - mge\@suse.de\n";
		} else {
			if ( ! m/^#$/ ){
				my ($begin, $text ) = split ( "\#", $_ );
				chomp $text;
				print $text, "\n";
			}
		}
	}
}

