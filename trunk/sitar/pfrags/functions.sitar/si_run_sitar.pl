#
#	si_run_sitar (main loop)
#
sub si_run_sitar() {
	si_debug("si_run_sitar");
	$SITAR_OPT_FORMAT =~ tr/A-Z/a-z/;
	if ( $SITAR_OPT_FORMAT ne "yast2" ) {
		open( TESTFILE, ">$SITAR_OPT_OUTFILE" )
		  || die "ERROR:\tThe output-file:\n\t$SITAR_OPT_OUTFILE\n\tcan not be opened for writing. Probably the parent-directory\n\tdoes not exist. - Exiting ...";
		close( TESTFILE );
	}
	if ( $SITAR_OPT_FORMAT eq "html" || $SITAR_OPT_FORMAT eq "tex" || $SITAR_OPT_FORMAT eq "sdocbook" ) {
		open( SAVEOUT, ">&STDOUT" );
		if ( $SITAR_OPT_OUTFILE ne "" ) {
			open( STDOUT, ">$SITAR_OPT_OUTFILE" );
		}
		print( STDERR "Generating $SITAR_OPT_OUTFILE...\n" );
		siprt( "header" );
		si_general_sys();
		si_cpuinfo();
		si_proc_kernel();
		si_lsdev();
		si_pci();
		si_pnp();
		if ( $mm eq "tex" ) {
			print "\n\\par\\begingroup\\tiny\\par\n";
		}
		# si_df();
		si_software_raid();
		si_mount();
		si_ide();
		si_scsi();
		si_gdth();
		si_ips();
		si_compaq_smart();
		si_dac960();
		si_ifconfig();
		si_route();
		si_packetfilter();
		if ( $mm eq "tex" ) {
			print "\n\\par\\endgroup\\par\n";
		}
		si_immunix_apparmor();
		si_proc();
		if ( $DIST_DISTRIBUTION eq "unitedlinux" ) {
			si_chkconfig();
			si_etc();
			si_etc_united();
			si_installed_sles();
			si_proc_config();
		} elsif ( $DIST_DISTRIBUTION eq "suse" || $DIST_DISTRIBUTION eq "sles" ) {
			si_chkconfig();
			si_etc();
			si_etc_united();
			si_etc_suse();
			si_installed_sles();
			si_proc_config();
		} elsif ( $DIST_DISTRIBUTION eq "redhat" ) {
			si_chkconfig();
			si_etc();
			si_etc_redhat();
			si_installed_rpm();
			si_kernel_config();
		} elsif ( $DIST_DISTRIBUTION eq "debian" ) {
			si_etc();
			si_etc_debian();
			si_installed_deb();
			si_kernel_config();
			#si_selection_deb ();
		} else {
			si_etc();
		}
		siprt( "toc" );
		siprt( "body" );
		siprt( "footer" );
		open( STDOUT, ">&SAVEOUT" );
	} elsif ( $SITAR_OPT_FORMAT eq "yast1" ) {
		open( SAVEOUT, ">&STDOUT" );
		if ( $SITAR_OPT_OUTFILE ne "" ) {
			open( STDOUT, ">$SITAR_OPT_OUTFILE" );
		}
		print( STDERR "Generating $SITAR_OPT_OUTFILE...\n" );
		si_selection_rpm();
		open( STDOUT, ">&SAVEOUT" );
	} elsif ( $SITAR_OPT_FORMAT eq "yast2" ) {
		open( SAVEOUT, ">&STDOUT" );
		print( STDERR "Generating $SITAR_OPT_OUTFILE...\n" );
		si_selection_yast2();
		open( STDOUT, ">&SAVEOUT" );
	} elsif ( $SITAR_OPT_FORMAT eq "pci" ) {
		# open (STDOUT,  ">/tmp/sitar-$HOSTNAME.pci");
		# si_lspci();
		# open (STDOUT,  ">&SAVEOUT");
		# print "\t/tmp/sitar-$HOSTNAME.pci\n";
	}
}
