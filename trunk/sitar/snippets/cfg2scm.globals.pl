#
#	GLOBALS
#
use Getopt::Long;
#
# commands
#
$ENV{ PATH } = '/sbin:/bin:/usr/bin:/usr/sbin:/opt/subversion/bin';
if ( !$CFG2SCM_OPT_DEBUG ) {
	open( SAVEERR, ">&STDERR" );
	open( STDERR,  ">/dev/null" );
}
chomp( my $CMD_BASENAME = `which basename` );
chomp( my $CMD_CAT      = `which cat` );
chomp( my $CMD_CVS      = `which cvs` );
chomp( my $CMD_DIRNAME  = `which dirname` );
chomp( my $CMD_FILE     = `which file` );
chomp( my $CMD_FIND     = `which find` );
chomp( my $CMD_GREP     = `which grep` );
chomp( my $CMD_GZIP     = `which gzip` );
chomp( my $CMD_HEAD     = `which head` );
chomp( my $CMD_HOSTNAME = `which hostname` );
chomp( my $CMD_MKDIR    = `which mkdir` );
chomp( my $CMD_RPM      = `which rpm` );
chomp( my $CMD_SORT     = `which sort` );
chomp( my $CMD_SVN      = `which svn` );
chomp( my $CMD_TAR      = `which tar` );
chomp( my $CMD_UNAME    = `which uname` );
chomp( my $CMD_UNIQ     = `which uniq` );
if ( !$CFG2SCM_OPT_DEBUG ) {
	open( STDERR, ">&SAVEERR" );
}
$ENV{ PATH } = '/bin:/usr/bin';
#
# predefined variables
#
sub si_now_gmt();
my $NOW = si_now_gmt();
chomp( my $HOSTNAME = `$CMD_HOSTNAME -f` );
my $CFG2SCM_OPT_TMP        = "/tmp/cfg2scm.$HOSTNAME.$NOW";
my $CFG2SCM_OPT_BASE_URL   = "";
my $CFG2SCM_OPT_REPOS      = "";
my $CFG2SCM_OPT_USER       = "";
my $CFG2SCM_OPT_PASS       = "";
my $CFG2SCM_OPT_STORAGE    = "tar.bz2";
my $CFG2SCM_OPT_MESSAGE    = "autocommit by cfg2scm";
my $CFG2SCM_OPT_OUTFILE    = "/tmp/cfg2scm.$HOSTNAME.$NOW";
my $CFG2SCM_OPT_LIMIT      = 0;
my $CFG2SCM_OPT_NON_ROOT   = "No";
my $CFG2SCM_OPT_GCONF      = "No";
my $CFG2SCM_OPT_LVMARCHIVE = "No";
my $CFG2SCM_SVN_AUTH       = "";
#
# static globals
#
my $CFG2SCM_COPYHOLDER            = "SuSE Linux, a Novell Business";
my $CFG2SCM_COPYRIGHT             = "2005-2006 $CFG2SCM_COPYHOLDER";
my $CFG2SCM_RELEASE               = "%%CFG2SCM_RELEASE%%";
my $CFG2SCM_SVNVERSION            = "%%CFG2SCM_SVNVERSION%%";
my $CFG2SCM_PREFIX                = "%%CFG2SCM_PREFIX%%";
my $CFG2SCM_CONSISTENCY_FILENAME  = "Configuration_Consistency.include";
my $CFG2SCM_FINDUNPACKED_FILENAME = "Find_Unpacked.include";
my $CFG2SCM_CONFIG_DIR            = "/var/lib/support";
my $CFG2SCM_CONFIG_FILE           = "/etc/sysconfig/cfg2scm";
