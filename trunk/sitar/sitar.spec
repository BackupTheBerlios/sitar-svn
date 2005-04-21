#
#  SITAR - System InformaTion At Runtime
#  Copyright (C) 1999-2005 SuSE Linux, a Novell Business
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#  Authors/Contributors:
#		Matthias G. Eckermann
#		Stephan Müller		Janto Trappe
#		Waldemar Brodkorb	Björn Jacke
#		Bernhard Thoni		Pascal Fuckerieder
#		Andreas Rother		Uwe Hering
#		Jan Jensen		Falko Trojahn
#		Stephan Martin		Holger Dopp
#		Seth Arnold
#

Vendor:		SuSE Linux, a Novell Business
Name:		sitar
Version:	0.9.3
Release:	0
Summary:	System InformaTion At Runtime
Source0:	sitar-%{version}.tar.bz2
Copyright:	GPL
Group: 		Applications/System
BuildRoot:	/tmp/root-%{name}/
BuildArch: 	noarch

#Requires:	coreutils util-linux gzip grep rpm net-tools

Packager:	Matthias G. Eckermann <mge@suse.de>

%description 
Sitar prepares system information using perl and binary tools, and by
reading the /proc file system.

Output is in HTML, LaTeX and (docbook) XML, and can be converted to
PS and PDF.

This program must be run as "root".

sitar.pl includes scsiinfo by Eric Youngdale, Michael Weller
<eowmob@exp-math.uni-essen.de> and ide_info by David A. Hinds
<dhinds@hyper.stanford.edu>.

Comment: Sitar is an ancient Indian instrument as well.

Authors:
--------
    Matthias Eckermann  <mge@suse.de>
    and contributors

%prep
%setup

%build
make

%install
if [ -n "$RPM_BUILD_ROOT" ] ; then
   [ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
fi
make DESTDIR=${RPM_BUILD_ROOT} install
rm -rf $RPM_BUILD_ROOT/usr/share/doc/sitar
%{?suse_check}

%files
%defattr(-,root,root)
%doc sitar.html sitar.ps LICENSE
%attr(700, root, root) /usr/sbin/sitar.pl
%attr(700, root, root) /usr/sbin/sitar
%attr(700, root, root) /usr/sbin/support_all.pl
/usr/share/man/man1/sitar.1.gz
/usr/share/man/man1/support_all.1.gz
%dir /usr/share/sitar
/usr/share/sitar/proc.txt

# # %changelog -n sitar.changes

%clean
if [ -n "$RPM_BUILD_ROOT" ] ; then
   [ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
fi

%changelog
* Thi Apr 21 2005 - mge@suse.de
- 0.9.3: (hopefully) final fix for Novell Bug #76733:
	configfile verification
* Mon Apr 12 2005 - mge@suse.de
- fixes Novell Bug #76733:
  SITAR should optionally check system consistency
- release 0.9.2:
	* fixes issue around --output=yast2, thanks to 
	  Dr. Stefan Werden
	* introduces "--check-consistency" as required by 
	  Manfred Hollstein ( = #76733)
* Mon Apr 11 2005 - mge@suse.de
- this is release 0.9.1:
	* added initial support for EVMS
	* converted all files to UTF-8
	* moved all external programs to one block;
	  enabled PATH-searching for these tools
* Mon Mar 21 2005 - mge@suse.de
- more fixes for Novell #73833:
        * lvm scanning, if /etc/lvm/backup does not exist
        * simple output of /proc/mdstat for kernel 2.4/2.6
* Fri Mar 18 2005 - mge@suse.de
- update to 0.9.0, fixes Novell #73833,
	SITAR is missing some required output fields:
	md-devices, sitar version
* Fri Mar 11 2005 - mge@suse.de
- 0.9.pre10
- improved Immunix/AppArmor integration; thanks to Seth Arnold
* Tue Mar 08 2005 - mge@suse.de
- 0.9.pre9
- add some stat()-information to config-files
- exclude listing backup-files from /etc/sysconfig
  (*~ #* *.bak *.bac *.orig *.ori) by request of mh@novell.com
* Tue Mar 08 2005 - mge@suse.de
- 0.9.pre8
- add support for AppArmor (subdomain) by Immunix

#
#  $Log: sitar.spec,v $
#  Revision 1.45  2005/03/11 08:55:38  mge
#  improved Immunix/AppArmor integration; thanks to Seth Arnold
#
#  Revision 1.44  2005/03/08 18:19:45  mge
#  added first support for stat() in config-files; used perltidy again
#
#  Revision 1.43  2005/03/08 15:37:01  mge
#  added support for AppArmor by Immunix
#
#  Revision 1.42  2005/02/11 20:04:48  mge
#  0.9.pre7: added cvs2rpmlog.pl for changelog in RPM
#
#  Revision 1.41  2005/02/09 13:02:04  mge
#  small patch regarding /proc/cpuinfo
#
#  Revision 1.40  2005/01/28 16:18:07  mge
#  exit with error, if target directory of output-file does not exist
#
#  Revision 1.39  2005/01/24 12:53:32  mge
#  added HD and SM to list of contributors/helpers
#
#  Revision 1.38  2005/01/24 09:48:15  mge
#  fixed error in TeX-output (forgotten chomp)
#
#  Revision 1.37  2005/01/19 01:55:00  mge
#  version: 0.9.pre2; added sdocbook to help
#
#  Revision 1.36  2005/01/19 01:49:56  mge
#  xml: well-formed and valid (as tested so far:-)
#
#  Revision 1.35  2005/01/18 17:33:53  mge
#  xml: better articleinfo
#
#  Revision 1.34  2005/01/18 14:13:43  mge
#  added first XML support (simplified docbook)
#
#  Revision 1.33  2005/01/18 11:31:41  mge
#  *** empty log message ***
#
#  Revision 1.32  2005/01/18 11:23:42  mge
#  removed suse.png suse.xpm
#
#  Revision 1.31  2005/01/18 11:21:36  mge
#  SuSE Linux AG -> SuSE Linux, a Novell Business
#
#  Revision 1.30  2004/09/17 14:56:07  mge
#  added lspci for kernel 2.6 without /proc/pci
#
#  Revision 1.29  2004/03/22 14:24:02  mge
#  - fixed off by one in directory name
#  - cleanups
#  - data from /etc/lvm/ (LVM2)
#
#  Revision 1.28  2003/10/22 22:24:33  mge
#  - sitar-files are now in /tmp/sitar-HOSTNAME-DATE/
#  - minor fixes
#
#  Revision 1.27  2003/08/29 11:42:16  mge
#  fixes SuSE bug #29632
#
#  Revision 1.26  2003/08/08 08:05:52  mge
#  - fixed BUG #561 /tmp/mdstat (but not perfect, still uses tmp-file:-(
#  - better yast2 selections
#  - minor corrections
#
#  Revision 1.25  2003/03/24 09:55:03  mge
#  Additions for SLOX, thanks to Uwe Hering (SuSE)
#
#  Revision 1.24  2003/01/10 16:26:18  mge
#  - (United Linux / SuSE Linux only): split packages by Packager
#  - minor TeX improvements
#  - release 0.8.6
#
#  Revision 1.23  2002/12/16 10:45:25  mge
#  minor changes
#
#  Revision 1.22  2002/12/10 09:36:57  mge
#  Release 0.8.4:
#  	- introduce "--version"
#  	- use ".tar.bz2" instead of ".tar.gz"
#  	- make new release on website
#
#  Revision 1.21  2002/12/04 23:30:37  mge
#  Release 0.8.3:
#  	- fixed si_etc / si_etc_suse function calls
#  	- minor corrections
#
#  Revision 1.20  2002/12/02 17:45:52  mge
#  0.8.2 (according to new CodingStyle)
#
#  Revision 1.19  2002/11/29 08:51:06  mge
#  correct naming of module parameters
#
#  Revision 1.18  2002/11/28 08:07:36  mge
#  Release 0.8.0:
#  	- yast2 output
#  	- /proc/sys/net fixes
#  	- better TeX output
#
#  Revision 1.17  2002/11/28 01:35:17  mge
#  - Added UnitedLinux finally
#  - Fixed TeX output
#  - Make --outfile --format run (did not work properly)
#  Release 0.7.5
#
#  Revision 1.16  2002/11/27 13:59:16  mge
#  Release 0.7.4
#
#  Revision 1.15  2002/04/11 14:43:32  mge
#  added check for /etc/sysconfig
#  release 0.7.1
#
#  Revision 1.14  2002/03/18 16:21:16  mge
#  added "BuildArch: noarch" to spec file
#
#  Revision 1.13  2002/03/18 16:18:19  mge
#  release 0.7.0
#
#  Revision 1.12  2002/03/18 16:11:45  mge
#  cosmetic changes
#
#  Revision 1.11  2002/01/14 15:37:39  mge
#  Added sitar-0.6.8-sw-raid.v0.1.patch by Bernhard Thoni
#
#  Revision 1.10  2001/09/07 01:13:54  mge
#  - cosmetic changes
#
#  Revision 1.9  2001/09/07 00:59:13  mge
#  - added Björn Jacke to list of authors
#
#  Revision 1.8  2001/09/07 00:09:09  mge
#  - released 0.6.8
#
#  Revision 1.7  2001/08/21 19:00:28  waldb
#  added variable DOCDIR to install documentation in a correct way for
#  all distributions, modified sitar.spec to use macro %doc for docfiles
#
#  Revision 1.6  2001/08/20 22:26:34  mge
#  make "support_all.pl" and "sitar.pl" work slightly different:
#  "sitar.pl" will do everything, as the old "sitar.pl" did, "support_all.pl"
#  uses the command line parameters.
#
#  Revision 1.5  2001/08/20 04:16:39  mge
#  - manpage cleanups
#  - changed release num to 0.6.6
#
#  Revision 1.4  2001/08/15 04:27:40  mge
#  improved semi-automated rpm-generation
#
#  Revision 1.3  2001/08/15 03:57:30  mge
#  Makefile cleanups, introduced CVS-log into
#  	CodingStyle Makefile sitar.pl.in sitar.spec
#

