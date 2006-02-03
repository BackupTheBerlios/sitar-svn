#
#	group_etc_analysis.pl
#
sub si_etc() {
	siprtt( "h1", "Configuration" );
	siprtt( "h2", "Common" );
	# SSH/OpenSSH
	my @sshconf = qw ( /etc/ssh/sshd_config /etc/sshd_config );
	foreach $file ( @sshconf ) {
		if ( -r $file ) { si_conf( "SSH/OpenSSH", $file, "\#" ); }
	}
	# DNS - Bind
	my @namedconf = qw ( /etc/named.conf /etc/bind/named.conf );
	foreach $file ( @namedconf ) {
		if ( -r $file ) {
			si_conf( "DNS/Bind", $file, "/**/" );
			open( FILE, $file );
			while ( <FILE> ) {
				if ( $_ =~ m/.*file\s*"(.*)".*/ ) {
					if ( -r "/var/named/" . $1 ) {
						si_conf( "Zones/DB", "/var/named/" . $1, "\#|;" );
					}
				}
			}
			close FILE;
		}
	}
	# Samba
	my @smbconf = qw ( /etc/smb.conf /etc/samba/smb.conf );
	foreach $file ( @smbconf ) {
		if ( -r $file ) { si_conf( "Samba", $file, "\#|;" ); }
	}
	# OpenLDAP
	my @slapdconf = qw ( /etc/openldap/slapd.conf /etc/ldap/slapd.conf /etc/slapd.conf );
	foreach $file ( @slapdconf ) {
		if ( -r $file ) { si_conf( "OpenLDAP Server", $file, "\#" ); }
	}
	my @ldapconf = qw ( /etc/openldap/ldap.conf /etc/ldap/ldap.conf  /etc/ldap.conf );
	foreach $file ( @ldapconf ) {
		if ( -r $file ) { si_conf( "OpenLDAP Client", $file, "\#" ); }
	}
	# Postfix
	if ( ( -d "/etc/postfix/" ) && ( -x "$CMD_POSTCONF" ) ) {
		siprtt( "h2", "Postfix (postconf -n)" );
		siprt( "pre" );
		open( CONFIG, "$CMD_POSTCONF -n |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
		if ( -r "/etc/aliases" ) { si_conf( "/etc/aliases", "/etc/aliases", "\#" ); }
	}
	# some more services/programs
	$SITAR_OPT_ALLCONFIGFILES =~ tr/A-Z/a-z/;
	if (       ( $SITAR_OPT_ALLCONFIGFILES eq "on" )
		|| ( ( !-f "$SITAR_CONFIG_DIR/$SITAR_CONSIST_FN" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_UNPACKED_FN" ) && ( $SITAR_OPT_ALLCONFIGFILES eq "auto" ) ) ) {
		my %myfiles = ();
		foreach ( @allconfigfiless ) {
			$myfiles{ $_ } = 0;
		}
		foreach $mm ( sort keys %myfiles ) {
			if ( $mm !~ /proc/ ) {
				if ( ( $mm eq "/etc/pppoed.conf" ) || ( $mm eq "/etc/grub.conf" ) || ( $mm eq "/boot/grub/menu.lst" ) || ( $mm eq "/etc/lilo.conf" ) ) {
					if ( -r $mm ) { si_conf_secure( $mm, "\#", "[Pp]assword" ); }
				} else {
					if ( -r $mm ) { si_conf( $mm, $mm, "\#" ); }
				}
			}
		}
	}
	#
	# some more services/programs
	#
	if ( -d $SITAR_CONFIG_DIR ) {
		for $NN ( `$CMD_FIND $SITAR_CONFIG_DIR -iname "*.include" -type f` ) {
			chomp $NN;
			%myfiles = ();
			do "$NN";
			foreach ( @files ) {
				$myfiles{ $_ } = 0;
			}
			$OO = $NN;
			$OO =~ s+$SITAR_CONFIG_DIR++g;
			$OO =~ s+^/++g;
			$OO = substr( $OO, 0, rindex( $OO, ".include" ) );
			siprtt( "h2", ucfirst( $OO ) . " ($NN)" );
			si_conf_filename_stat( $NN, "", 1 );
			foreach $mm ( sort keys %myfiles ) {
				if ( $mm !~ /proc/ ) {
					if ( ( $mm eq "/etc/pppoed.conf" ) || ( $mm eq "/etc/grub.conf" ) || ( $mm eq "/boot/grub/menu.lst" ) || ( $mm eq "/etc/lilo.conf" ) ) {
						if ( -r $mm ) { si_conf_secure( $mm, "\#", "[Pp]assword" ); }
					} else {
						if ( -r $mm ) { si_conf( $mm, $mm, "\#" ); }
					}
				}
			}
		}
	}
}

sub si_etc_debian() {
	# special function for debian specific configuration
	#siprtt( "h1", "Configuration" );
}

sub si_etc_redhat() {
	si_usercrontab();
	# Sysconfig
	if ( -r "/etc/sysconfig" ) {
		siprtt( "h2", "Sysconfig" );
		for $NN ( `$CMD_FIND /etc/sysconfig -type f` ) {
			chomp $NN;
			if ( `$CMD_FILE -b $NN | $CMD_GREP -i -e text` ) {
				si_conf( $NN, $NN, "\#" );
			}
		}
	}
}

sub si_etc_united() {
	$SITAR_OPT_ALLSYSCONFIG =~ tr/A-Z/a-z/;
	if (       ( $SITAR_OPT_ALLSYSCONFIG eq "on" )
		|| ( ( !-f "$SITAR_CONFIG_DIR/$SITAR_CONSIST_FN" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_UNPACKED_FN" ) && ( $SITAR_OPT_ALLSYSCONFIG eq "auto" ) ) ) {
		if ( -r "/etc/sysconfig" ) {
			siprtt( "h2", "Sysconfig" );
			for $NN ( `$CMD_FIND /etc/sysconfig -type f` ) {
				chomp $NN;
				if ( `$CMD_FILE -b $NN | $CMD_GREP -i -e text | $CMD_GREP -i -v "shell script"` ) {
					si_conf( $NN, $NN, "\#" );
				}
			}
		}
	}
	# SuSE proxy suite
	if ( -r "/etc/proxy-suite" ) {
		siprtt( "h2", "SuSE Proxy Suite" );
		for $NN ( `$CMD_FIND /etc/proxy-suite -name "*.conf"` ) {
			chomp $NN;
			si_conf( $NN, $NN, "\#" );
		}
	}
}

sub si_etc_suse() {
	# special function for suse specific configuration
	if ( -d "/etc/rc.config.d" || -r "/etc/rc.config" ) {
		siprtt( "h2", "/etc/rc.config*" );
		si_conf( "/etc/rc.config", "/etc/rc.config", "\#" );
		if ( -r "/etc/rc.config.d" ) {
			for $NN ( `$CMD_FIND /etc/rc.config.d -name "*.config"` ) {
				chomp $NN;
				si_conf( $NN, $NN, "\#" );
			}
		}
	}
}

