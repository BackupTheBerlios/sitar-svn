#
#	si_lsdev.pl
#
sub si_lsdev() {
	si_debug("si_lsdev");
	#	lsdev.pl
	#	Created by Sander van Malssen <svm@ava.kozmix.cistron.nl>
	#	Date:        1996-01-22 19:06:22
	#	Last Change: 1998-05-31 15:26:58
	my %device_h = ();
	use vars qw($device_h @line $line @tmp $tmp0 $name %port $abc $hddev);
	my %dma = ();
	my %irq = ();
	open( IRQ, "/proc/interrupts" ) || return ();
	while ( <IRQ> ) {
		next if /^[ \t]*[A-Z]/;
		chop;
		my $n;
		if ( /PIC/ ) {
			$n = ( @line = split() );
		} else {
			$n = ( @line = split( ' [ +] ' ) );
		}
		my $name = $line[ $n - 1 ];
		$device_h{ $name } = $name;
		@tmp          = split( ':', $line[ 0 ] );
		$tmp0         = int( $tmp[ 0 ] );
		$irq{ $name } = "$irq{$name} $tmp0";
	}
	close( IRQ );
	open( DMA, "/proc/dma" ) || return ();
	while ( <DMA> ) {
		chop;
		@line = split( ': ' );
		if ( $DIST_DISTRIBUTION eq "redhat" ) {
			$name = $line[ 1 ];
		} else {
			@tmp = split( /[ \(]/, $line[ 1 ] );
			$name = $tmp[ 0 ];
		}
		$device_h{ $name } = $name;
		$dma{ $name }      = "$dma{$name}$line[0]";
	}
	close( DMA );
	open( IOPORTS, "</proc/ioports" ) || return ();
	while ( <IOPORTS> ) {
		chop;
		@line = split( ' : ' );
		if ( $DIST_DISTRIBUTION eq "redhat" ) {
			$name = $line[ 1 ];
		} else {
			@tmp = split( /[ \(]/, $line[ 1 ] );
			$name = $tmp[ 0 ];
		}
		$device_h{ $name } = $name;
		$port{ $name }     = "$port{$name} $line[0]";
	}
	close( IOPORTS );
	siprtt( "h1", "Devices" );
	siprtttt( "tabborder", "llll", "Devices", 4 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Device" );
	siprtt( "tabhead", "DMA" );
	siprtt( "tabhead", "IRQ" );
	siprtt( "tabhead", "I/O Ports" );
	siprt( "endrow" );
	foreach $name ( sort { uc( $a ) cmp uc( $b ) } keys %device_h ) {
		siprt( "tabrow" );
		siprtt( "cell", $name );
		siprtt( "cell", $dma{ $name } );
		siprtt( "cell", $irq{ $name } );
		siprtt( "cell", $port{ $name } );
		siprt( "endrow" );
	}
	siprt( "endtab" );
}
