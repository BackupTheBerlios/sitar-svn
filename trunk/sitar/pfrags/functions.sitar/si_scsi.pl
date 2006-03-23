#
#
#
sub si_scsi() {
	si_debug("si_scsi");
	my $header = 0;
	if ( -r "/proc/scsi/scsi" ) {
		open( SCSIINFO, "/proc/scsi/scsi" );
		while ( <SCSIINFO> ) {
			if ( m/^Host:\s+(.*)Channel:\s+(.*)Id:\s+(.*)Lun:\s+(.*)$/gs ) {
				$host    = $1;
				$channel = $2;
				$id      = $3;
				$lun     = $4;
				if ( !$header ) {
					siprtt( "h1", "SCSI" );
					siprtttt( "tabborder", "lllllllll", "SCSI", 9 );
					siprt( "tabrow" );
					siprtt( "tabhead", "Host" );
					siprtt( "tabhead", "Channel" );
					siprtt( "tabhead", "Id" );
					siprtt( "tabhead", "Lun" );
					siprtt( "tabhead", "Vendor" );
					siprtt( "tabhead", "Model" );
					siprtt( "tabhead", "Revision" );
					siprtt( "tabhead", "Type" );
					siprtt( "tabhead", "SCSI Rev." );
					siprt( "endrow" );
					$header = 1;
				}
			} elsif ( m/^\s+Vendor:\s+(.*)\s+Model:\s+(.*)\s+Rev:\s+(.*)$/gs ) {
				$vendor = $1;
				$model  = $2;
				$rev    = $3;
			} elsif ( m/^\s+Type:\s+(.*)\s+ANSI SCSI revision:\s+(.*)$/gs ) {
				$ttype   = $1;
				$ansirev = $2;
				siprt( "tabrow" );
				siprtt( "cell", $host );
				siprtt( "cell", $channel );
				siprtt( "cell", $id );
				siprtt( "cell", $lun );
				siprtt( "cell", $vendor );
				siprtt( "cell", $model );
				siprtt( "cell", $rev );
				siprtt( "cell", $ttype );
				siprtt( "cell", $ansirev );
				siprt( "endrow" );
			} else {
			}
		}
		close( SCSIINFO );
	}
	if ( $header ) {
		siprt( "endtab" );
	}
}
