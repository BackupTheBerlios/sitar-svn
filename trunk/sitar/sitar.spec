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
Version:	0.9.4
Release:	dev
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
* Mon May 09 2005 - mge@suse.de
- 0.9.4-dev:
	- code cleanups (globals)
	- remove log-entries from files (-> subversion)
* Thu Apr 21 2005 - mge@suse.de
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
