#
#	si_proc_kernel
#
sub si_proc_kernel() {
	siprtt( "h1", "Kernel" );
	siprtttt( "tabborder", "ll", "Kernel", 2 );
	for $NN ( sort `$CMD_FIND /proc/sys/kernel/ -type f` ) {
		chomp $NN;
		$value = `$CMD_CAT $NN`;
		if ( $value ne "" ) {
			my $MM = $NN;
			$MM =~ s/\/proc\/sys\/kernel\///;
			$OO = $MM;
			$OO =~ s/(\w+\/)*(\w+)$/$+/;
			chomp $OO;
			siprt( "tabrow" );
			siprtt( "cell", $MM );
			siprtt( "cell", $value );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
}
