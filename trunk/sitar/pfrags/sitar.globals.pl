#
#	GLOBALS
#
use Getopt::Long;
use Fcntl;
#
# sitar options and globals
#
my $SITAR_COPYHOLDER         = "SuSE Linux, a Novell Business";
my $SITAR_COPYRIGHT          = "1999-2006 $SITAR_COPYHOLDER";
my $SITAR_RELEASE            = "%%SITAR_RELEASE%%";
my $SITAR_SVNVERSION         = "%%SITAR_SVNVERSION%%";
my $SITAR_PREFIX             = "%%SITAR_PREFIX%%";
my $SITAR_READFILE_LIMIT     = 32767;
my $SITAR_CONFIG_FILE        = "/etc/sysconfig/sitar";
my @SITAR_STRUCTURED         = ( "html", "tex", "sdocbook" );
my @SITAR_SELFILES           = ( "yast1", "yast2" );
my @SITAR_ALLFORMATS         = ( "html", "tex", "sdocbook", "yast1", "yast2" );
my $SITAR_OPT_FORMAT         = "";
my $SITAR_OPT_OUTFILE        = "";
my $SITAR_OPT_OUTDIR         = "";
my $SITAR_OPT_GCONF          = "No";
my $SITAR_OPT_LIMIT          = 700000;
my $SITAR_CONFIG_DIR         = "/var/lib/support";
my $SITAR_CONSIST_FN         = "Configuration_Consistency.include";
my $SITAR_UNPACKED_FN        = "Find_Unpacked.include";
my $SITAR_OPT_ALLSUBDOMAIN   = "Auto";
my $SITAR_OPT_ALLCONFIGFILES = "Auto";
my $SITAR_OPT_ALLSYSCONFIG   = "Auto";
my $SITAR_OPT_LVMARCHIVE     = "No";
my $SITAR_OPT_CONSISTENCY    = 0;
my $SITAR_OPT_FINDUNPACKED   = 0;
my $SITAR_OPT_ALL            = 0;
my $SITAR_OPT_DEBUG          = 1;
my ( $SITAR_OPT_HELP, $SITAR_OPT_VERSION );
#
# commands
#
$ENV{ PATH } = '/sbin:/bin:/usr/bin:/usr/sbin';
open( SAVEERR, ">&STDERR" );
open( STDERR,  ">/dev/null" );
chomp( my $CMD_CHKCONF   = `which chkconfig` );
chomp( my $CMD_DF        = `which df` );
chomp( my $CMD_EVMS_INFO = `which evms_gather_info` );
chomp( my $CMD_FDISK     = `which fdisk` );
chomp( my $CMD_FIND      = `which find` );
chomp( my $CMD_FILE      = `which file` );
chomp( my $CMD_GREP      = `which grep` );
chomp( my $CMD_GZIP      = `which gzip` );
chomp( my $CMD_HEAD      = `which head` );
chomp( my $CMD_HOSTNAME  = `which hostname` );
chomp( my $CMD_IFCONF    = `which ifconfig` );
chomp( my $CMD_INSTSRC   = `which installation_sources` );
chomp( my $CMD_IPTABLES  = `which iptables` );
chomp( my $CMD_LS        = `which ls` );
chomp( my $CMD_LSPCI     = `which lspci` );
chomp( my $CMD_LSHAL     = `which lshal` );
chomp( my $CMD_LSPNP     = `which lspnp` );
chomp( my $CMD_MOUNT     = `which mount` );
chomp( my $CMD_MULTIPATH = `which multipath` );
chomp( my $CMD_POSTCONF  = `which postconf` );
chomp( my $CMD_ROUTE     = `which route` );
chomp( my $CMD_SORT      = `which sort` );
chomp( my $CMD_TUNE2FS   = `which tune2fs` );
chomp( my $CMD_UNAME     = `which uname` );
chomp( my $CMD_UNIQ      = `which uniq` );
open( STDERR, ">&SAVEERR" );
$ENV{ PATH } = '';
#
# distribution test
#
my $DIST_UNITED       = "/etc/UnitedLinux-release";
my $DIST_SUSE         = "/etc/SuSE-release";
my $DIST_SLOX         = "/etc/SLOX-release";
my $DIST_DEBIAN       = "/etc/debian_version";
my $DIST_REDHAT       = "/etc/redhat-release";
my $DIST_LSB          = "/etc/lsb-release";
my $DIST_RELEASE      = "";
my $DIST_DISTRIBUTION = "";
my ( $DPKG, $CMD_RPM, $CMD_STATUS );
if ( -e $DIST_DEBIAN ) {
	$DIST_RELEASE      = `$CMD_HEAD -n 1 /etc/debian_version`;
	$DIST_DISTRIBUTION = "debian";
	$CMD_STATUS        = "/var/lib/dpkg/status";
	$CMD_DPKG          = "/usr/bin/dpkg";
} elsif ( -e $DIST_REDHAT ) {
	$DIST_RELEASE      = `$CMD_HEAD -n 1 /etc/redhat-release`;
	$DIST_DISTRIBUTION = "redhat";
	$CMD_RPM           = "/bin/rpm";
} elsif ( ( -e $DIST_UNITED ) && ( -e $DIST_SUSE ) ) {
	$DIST_RELEASE = `$CMD_HEAD -n 1 /etc/UnitedLinux-release`;
	chomp $DIST_RELEASE;
	$DIST_RELEASE = join "", $DIST_RELEASE, ", ", `$CMD_HEAD -n 1 /etc/SuSE-release`;
	chomp $DIST_RELEASE;
	$DIST_DISTRIBUTION = "sles";
	$CMD_RPM           = "/bin/rpm";
} elsif ( -e $DIST_UNITED ) {
	$DIST_RELEASE      = `$CMD_HEAD -n 1 /etc/UnitedLinux-release`;
	$DIST_DISTRIBUTION = "unitedlinux";
	$CMD_RPM           = "/bin/rpm";
} elsif ( -e $DIST_SLOX ) {
	$DIST_RELEASE      = `$CMD_HEAD -n 1 /etc/SLOX-release`;
	$DIST_DISTRIBUTION = "sles";
	$CMD_RPM           = "/bin/rpm";
} elsif ( -e $DIST_SUSE ) {
	$DIST_RELEASE      = `$CMD_HEAD -n 1 /etc/SuSE-release`;
	$DIST_DISTRIBUTION = "suse";
	$CMD_RPM           = "/bin/rpm";
} else {
	$DIST_DISTRIBUTION = "unknown";
	print "\n distribution not supported!!\n\n";
}
chomp $DIST_RELEASE;
#
my $ULPACK_RAW_NAME    = "http://www.unitedlinux.com/feedback";
my $ULPACK_NICE_NAME   = "United Linux";
my $SUSEPACK_RAW_NAME  = "www.suse.*/feedback";
my $OPENSUSEPACK_NAME  = "bugs.opensuse.org";
my $SUSEPACK_NICE_NAME = "SuSE Linux";
#
# global vars
#
my $now_string_g = localtime();
my %proc_h       = ();
chomp( my $HOSTNAME = `$CMD_HOSTNAME -f` );
chomp( my $UNAME    = `$CMD_UNAME -a` );
chomp( my $UNAMER   = `$CMD_UNAME -r` );
chomp( my $UNAMEM   = `$CMD_UNAME -m` );
chomp( my $CWD      = `pwd` );
#
my ( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks );
#
my $multipath_conf = "/etc/multipath.conf";
#
# AppArmor/SubDomain
#
my $apparmor_verbose_name     = "AppArmor";
my $apparmor_config_log       = "/etc/logprof.conf";
my @apparmor_config_path      = ( "/etc/immunix", "/etc/apparmor" );
my @apparmor_kernel_path      = ( "/subdomain", "/sys/kernel/security/apparmor" );
my @apparmor_profiles_path    = ( "/etc/subdomain.d", "/etc/apparmor.d" );
#
# configfiles to hide/ignore
#
my %ignoreconfigfiles = (
	"/etc/defkeymap.map" => 1,
	""                   => 0
);
#
# allconfigfiless
#
my @allconfigfiless = qw (
  /boot/grub/menu.lst
  /etc/apache/httpd.conf
  /etc/crontab
  /etc/dhclient-enter-hooks
  /etc/dhclient.conf
  /etc/dhcpd.conf
  /etc/elilo.conf
  /etc/group
  /etc/grub.conf
  /etc/ha.d/authkeys
  /etc/ha.d/ha.cf
  /etc/ha.d/haresources
  /etc/hosts
  /etc/hosts.allow
  /etc/hosts.deny
  /etc/httpd/httpd.conf
  /etc/inetd.conf
  /etc/init.d/boot.local
  /etc/inittab
  /etc/lilo.conf
  /etc/ntp.conf
  /etc/passwd
  /etc/ppp/options
  /etc/ppp/pppoe-server-options
  /etc/pppoed.conf
  /etc/printcap
  /etc/raid0.conf
  /etc/raid1.conf
  /etc/raid5.conf
  /etc/raidtab
  /etc/rc.firewall
  /etc/resolv.conf
  /etc/rinetd.conf
  /etc/route.conf
  /etc/snmp/snmpd.conf
  /etc/snort/snort.conf
  /etc/squid.conf
  /etc/squid/squid.conf
  /etc/syslog.conf
  /etc/xinetd.conf
  /etc/X11/xorg.conf
  /etc/X11/XF86Config,
  /etc/X11/XF86Config4,
  /var/spool/fax/etc/config
  /var/spool/fax/etc/config.modem
);
