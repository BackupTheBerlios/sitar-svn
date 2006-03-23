#
#	group_kernel
#
sub si_kernel_config() {
	si_debug("si_kernel_config");
	my $comment = "\#";
	my $config  = "/boot/config-$UNAMER";
	if( -r $config ) {
		siprtt( "h1", "Kernel Configuration" );
		siprt( "multipre" );
		open( CONFIG, "<$config" );
		while ( <CONFIG> ) {
			chomp();
			if ( !m/^($comment)|^$/ ) {
				siprtt( "verb", "$_\n" );
			}
		}
		close( CONFIG );
		siprt( "endmultipre" );
	}
}

sub si_proc_config() {
	si_debug("si_proc_config");
	my $comment = "\#";
	if ( ( -r "/proc/config.gz" ) && ( -x "$CMD_GZIP" ) ) {
		siprtt( "h1", "Kernel Configuration" );
		siprt( "multipre" );
		open( CONFIG, "$CMD_GZIP -dc /proc/config.gz |" );
		while ( <CONFIG> ) {
			chomp();
			if ( !m/^($comment)|^$/ ) {
				siprtt( "verb", "$_\n" );
			}
		}
		close( CONFIG );
		siprt( "endmultipre" );
	}
}
