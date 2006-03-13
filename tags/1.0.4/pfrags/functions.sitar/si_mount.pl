#
#
#
sub si_mount() {
	%fsystem   = ();
	%mountp    = ();
	%blocks    = ();
	%resblocks = ();
	%ftype     = ();
	%fbegin    = ();
	%fend      = ();
	%mountopts = ();
	@sarray    = ();
	open( MOUNT, "$CMD_MOUNT |" );
	while ( <MOUNT> ) {
		if ( m/^\/dev/g ) {
			@params                    = split /\s+/;
			$fsystem{ $params[ 0 ] }   = $params[ 4 ];
			$mountp{ $params[ 0 ] }    = $params[ 2 ];
			$mountopts{ $params[ 0 ] } = $params[ 5 ];
		}
	}
	close( MOUNT );
	open( FDISK, "$CMD_fdisk -l |" );
	while ( <FDISK> ) {
		s/\*//gs;
		if ( m/^\/dev/g ) {
			@fparams = split /\s+/, $_, 6;
			$blocks{ $fparams[ 0 ] } = $fparams[ 3 ];
			chomp( $ftype{ $fparams[ 0 ] } = $fparams[ 5 ] );
			$fbegin{ $fparams[ 0 ] }   = $fparams[ 1 ];
			$fend{ $fparams[ 0 ] }     = $fparams[ 2 ];
			$ftypenum{ $fparams[ 0 ] } = $fparams[ 4 ];
			if ( $ftypenum{ $fparams[ 0 ] } eq "8e" ) {
				$ftype{ $fparams[ 0 ] } = "LVM-PV";
			}
			if ( $ftypenum{ $fparams[ 0 ] } eq "fe" ) {
				$ftype{ $fparams[ 0 ] } = "old LVM";
			}
		}
	}
	close( FDISK );
	open( DFK, "$CMD_DF -PPk |" );
	while ( <DFK> ) {
		if ( m/^\/dev/g ) {
			@dfkparams = split /\s+/, $_, 6;
			# $blocks{$dfkparams[0]} = $dfkparams[3];
			$dfkblocks{ $dfkparams[ 0 ] }  = $dfkparams[ 1 ];
			$dfkused{ $dfkparams[ 0 ] }    = $dfkparams[ 2 ];
			$dfkavail{ $dfkparams[ 0 ] }   = $dfkparams[ 3 ];
			$dfkpercent{ $dfkparams[ 0 ] } = $dfkparams[ 4 ];
			$dfkmountp{ $dfkparams[ 0 ] }  = $dfkmountp[ 4 ];
		}
	}
	close( DFK );
	open( LVM, "/proc/lvm |" );
	while ( <LVM> ) {
		if ( m/^LVM/g )        { }
		if ( m/^Total/g )      { }
		if ( m/^Global/g )     { }
		if ( m/^VG/g )         { }
		if ( m/^\s\sPV/g )     { }
		if ( m/^\s\s\s\sLV/g ) { }
		if ( m/^\/dev/g )      {
			#@dfkparams = split /\s+/,$_, 6;
			## $blocks{$dfkparams[0]} = $dfkparams[3];
			#$dfkblocks{$dfkparams[0]}  = $dfkparams[1];
			#$dfkused{$dfkparams[0]}    = $dfkparams[2];
			#$dfkavail{$dfkparams[0]}   = $dfkparams[3];
			#$dfkpercent{$dfkparams[0]} = $dfkparams[4];
		}
	}
	close( LVM );
	siprtt( "h1", "Partitions, Mounts, LVM" );
	siprtt( "h2", "Overview" );
	siprtttt( "tabborder", "llllllllllllllll", "Partitions, Mounts, LVM", 16 );
	@tarray = sort keys %mountp;
	push @tarray, sort keys %blocks;
	$oldtt = "";
	for $tt ( sort @tarray ) {
		if ( $oldtt ne $tt ) { push @sarray, $tt; }
		$oldtt = $tt;
	}
	# for $tt (sort keys %mountp) {
	siprt( "tabrow" );
	siprtt( "tabhead", "Partition" );
	siprtt( "tabhead", "PType" );
	siprtt( "tabhead", "\#" );
	siprtt( "tabhead", "Begin" );
	siprtt( "tabhead", "End" );
	siprtt( "tabhead", "Raw size" );
	siprtt( "tabhead", "Mountpoint" );
	siprtt( "tabhead", "Filesys." );
	siprtt( "tabhead", "res." );
	siprtt( "tabhead", "BlkSize" );
	siprtt( "tabhead", "I.Dens." );
	siprtt( "tabhead", "MaxMnt" );
	siprtt( "tabhead", "Blocks" );
	siprtt( "tabhead", "Used" );
	siprtt( "tabhead", "Avail." );
	siprtt( "tabhead", "%" );
	siprt( "endrow" );
	open( SAVEERR, ">&STDERR" );
	open( STDERR,  ">/dev/null" );
	for $tt ( sort @sarray ) {
		open( TUNE, "$CMD_TUNEFS -l $tt |" );
		while ( <TUNE> ) {
			if ( m/^Reserved block count:\s*(\w+)\s*$/g ) {
				$resblocks{ $tt } = $1;
			}
			if ( m/^Block size:\s*(\w+)\s*$/g )          { $blocksize{ $tt }  = $1; }
			if ( m/^Inode count:\s*(\w+)\s*$/g )         { $inodecount{ $tt } = $1; }
			if ( m/^Block count:\s*(\w+)\s*$/g )         { $blockcount{ $tt } = $1; }
			if ( m/^Maximum mount count:\s*(\w+)\s*$/g ) { $maxmount{ $tt }   = $1; }
		}
		close( TUNE );
		if ( ( $inodecount{ $tt } != 0 ) && ( $blockcount{ $tt } != 0 ) && ( $blocksize{ $tt } != 0 ) ) {
			$inodedensity{ $tt } = ( 2**int( log( $blockcount{ $tt } / $inodecount{ $tt } ) / log( 2 ) + 0.5 ) ) * $blocksize{ $tt };
		} else {
			$inodedensity{ $tt } = "-";
		}
	}
	open( STDERR, ">&SAVEERR" );
	for $tt ( sort @sarray ) {
		siprt( "tabrow" );
		siprtt( "cell", $tt );
		siprtt( "cell", $ftype{ $tt } );
		siprtt( "cell", $ftypenum{ $tt } );
		siprtt( "cell", $fbegin{ $tt } );
		siprtt( "cell", $fend{ $tt } );
		siprtt( "cell", $blocks{ $tt } );
		siprtt( "cell", $mountp{ $tt } );
		siprtt( "cell", $fsystem{ $tt } );
		siprtt( "cell", $resblocks{ $tt } );
		siprtt( "cell", $blocksize{ $tt } );
		siprtt( "cell", $inodedensity{ $tt } );
		siprtt( "cell", $maxmount{ $tt } );
		siprtt( "cell", $dfkblocks{ $tt } );
		siprtt( "cell", $dfkused{ $tt } );
		siprtt( "cell", $dfkavail{ $tt } );
		siprtt( "cell", $dfkpercent{ $tt } );
		siprt( "endrow" );
	}
	siprt( "endtab" );
	#
	# open(PART, ">sitar-$HOSTNAME.part");
	# for $tt (sort @sarray) {
	#  print PART "";
	#  $tt, $ftype{$tt}, "</td>",
	#  "<td>", $ftypenum{$tt}, "</td>",
	#  "<td>", $fbegin{$tt}, "</td>",
	#  "<td>", $fend{$tt}, "</td>",
	#  "<td>", $blocks{$tt}, "</td>",
	#  "<td>", $mountp{$tt}, "</td>",
	#  "<td>", $fsystem{$tt}, "</td>",
	#  "<td>", $resblocks{$tt}, "</td>",
	#  "<td>", $blocksize{$tt}, "</td>",
	#  "<td>", $inodedensity{$tt}, "</td>",
	#  "<td>", $maxmount{$tt}, "</td>",
	#  "<td>", $dfkblocks{$tt}, "</td>",
	#  "<td>", $dfkused{$tt}, "</td>",
	#  "<td>", $dfkavail{$tt}, "</td>",
	#  "<td>", $dfkpercent{$tt}, "</td>",
	#  "\n</tr>\n";
	# }
	# close(PART);
	siprtt( "h2", "Configuration Files (fstab, lvm)" );
	si_conf( "/etc/fstab",        "/etc/fstab",        "\#" );
	si_conf( "/etc/lvm/lvm.conf", "/etc/lvm/lvm.conf", "\#" );
	si_conf( "/etc/lvm/.cache",   "/etc/lvm/.cache",   "\#" );
	if ( -d "/etc/lvm/backup" ) {
		for $NN ( sort `$CMD_FIND /etc/lvm/backup/ -type f` ) {
			chomp $NN;
			si_conf( $NN, $NN, "\#" );
		}
	}
	if ( -x "$CMD_EVMS_INFO" ) {
		siprtt( "h2", "EVMS Information" );
		siprt( "pre" );
		# 'evms_gather_info' searches for 'evms' internally, ...
		$ENV{ PATH } = '/sbin:/bin:/usr/bin:/usr/sbin';
		open( EVMSINFO, "$CMD_EVMS_INFO |" );
		while ( <EVMSINFO> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( EVMSINFO );
		$ENV{ PATH } = '';
		# cleanup behind 'evms_gather_info'
		if ( -r "gather_info.qry" ) {
			unlink "gather_info.qry";
		}
		siprt( "endpre" );
	}
	if ( -x "$CMD_MULTIPATH" ) {
		siprtt( "h2", "Multipathing (dm based)" );
		si_conf( $multipath_conf, $multipath_conf, "\#" );
		siprtt( "h3", "$CMD_MULTIPATH -ll" );
		siprt( "pre" );
		open( CONFIG, "$CMD_MULTIPATH -ll |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
	}
}
