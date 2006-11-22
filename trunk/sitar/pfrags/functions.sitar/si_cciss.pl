#
# HP/Comapaq 3rd Generation SmartArray Controller configuration dump
# $Id: $
#
sub si_cciss() {
	$ENV{ PATH } = '/sbin:/bin:/usr/bin:/usr/sbin';
	si_debug( "si_cciss" );
	if ( -x "$CMD_ACUCLI" ) {
		my %ctrls = ();
		open( CTRL, "$CMD_ACUCLI ctrl all show |" );
		while ( <CTRL> ) {
			chomp;
			my $str = substr $_, 0, 30;
			my $s = undef;
			if ( $str =~ / at / ) {
				( $s ) = ( split( / at /, $str ) )[ 1 ];
				$s =~ s/ //g;
				$ctrls{ "$s" } = "csn=$s";
			}
			if ( $str =~ / in Slot / ) {
				( $s ) = ( split( / in Slot /, $str ) )[ 1 ];
				$s =~ s/ //g;
				$ctrls{ "$s" } = "slot=$s";
			}
		}
		close( CTRL );
		siprtt( "h1", "HP/Compaq 3rd Generation Smart Array Controller Configuration" );
		foreach my $key ( sort ( keys( %ctrls ) ) ) {
			my $ctrl = $ctrls{ "$key" };
			siprtt( "h2", "Controller $ctrl" );
			siprt( "pre" );
			open( CTRL, "$CMD_ACUCLI ctrl $ctrl show |" );
			while ( <CTRL> ) {
				chomp();
				if ( !( /^$/ || /^\w/ ) ) {
					siprtt( "verb", "$_\n" );
				}
			}
			close( CTRL );
			siprt( "endpre" );
			siprtt( "h2", "Controller $ctrl logical drives" );
			siprt( "pre" );
			open( CTRL, "$CMD_ACUCLI ctrl $ctrl ld all show |" );
			while ( <CTRL> ) {
				chomp();
				if ( !( /^$/ || /^\w/ ) ) {
					siprtt( "verb", "$_\n" );
				}
			}
			close( CTRL );
			siprt( "endpre" );
			siprtt( "h2", "Controller $ctrl physical drives" );
			siprt( "pre" );
			open( CTRL, "$CMD_ACUCLI ctrl $ctrl pd all show |" );
			while ( <CTRL> ) {
				chomp();
				if ( !( /^$/ || /^\w/ ) ) {
					siprtt( "verb", "$_\n" );
				}
			}
			close( CTRL );
			siprt( "endpre" );
		}
	}
	$ENV{ PATH } = '';
}
