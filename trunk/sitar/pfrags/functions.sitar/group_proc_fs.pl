#
#	group_proc_fs.pl
#
sub si_build_proc_description() {
	open( PROCTXT, "<$SITAR_PREFIX/share/sitar/proc.txt" );
	#if ( -r "/usr/src/linux/Documentation/proc.txt" ) {
	#	open( PROCTXT, "</usr/src/linux/Documentation/proc.txt" );
	#} elsif ( -r "/usr/src/linux/Documentation/filesystems/proc.txt" ) {
	#	open( PROCTXT, "</usr/src/linux/Documentation/filesystems/proc.txt" );
	#} else {
	#}
	$old_slash = $/;
	undef $/;
	$_ = <PROCTXT>;
	my @proc_a = split /\n\n/;
	close( PROCTXT );
	$/ = $old_slash;
	for $NN ( @proc_a ) {
		my @mypair = split /\n/, $NN, 2;
		my $newkey = $mypair[ 0 ];
		my $newval = $mypair[ 1 ];
		$proc_h{ $newkey } = $newval;
	}
}

sub si_proc_sys_net () {
	my $value;
	siprtt( "h2", "/proc/sys/net" );
	my @nettypes = qw(802 appletalk ax25 rose x25 bridge core decnet ethernet ipv4 ipv6 irda ipx net-rom token-ring unix);
	for $NET ( @nettypes ) {
		if ( ( -d "/proc/sys/net/$NET" ) ) {
			opendir( DIR, "/proc/sys/net/$NET" );
			@curr_dir = readdir( DIR );
			if ( $#curr_dir > 1 ) {
				siprtt( "h3", "/proc/sys/net/$NET" );
				siprtttt( "tabborder", "llp{.5\\textwidth}", "/proc/sys/net/$NET", 3 );
				open( SAVEERR, ">&STDERR" );
				open( STDERR,  ">/dev/null" );
				for $NN ( sort `$CMD_FIND /proc/sys/net/$NET/ -type f` ) {
					chomp $NN;
					$value = si_readfile( "$NN" );
					if ( $value ne "" ) {
						my $MM = $NN;
						$MM =~ s/\/proc\/sys\/net\/$NET\///;
						$OO = $MM;
						$OO =~ s/(\w+\/)*(\w+)$/$+/;
						chomp $OO;
						siprt( "tabrow" );
						siprtt( "cell",     $MM );
						siprtt( "cell",     $value );
						siprtt( "cellwrap", $proc_h{ $OO } );
						siprt( "endrow" );
					}
				}
				open( STDERR, ">&SAVEERR" );
				siprt( "endtab" );
			}
		}
	}
}

sub si_proc () {
	si_build_proc_description();
	siprtt( "h1", "/proc" );
	si_proc_sys_net();
	si_proc_modules();
}
