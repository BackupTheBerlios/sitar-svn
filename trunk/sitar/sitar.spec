#
#  SITAR - System InformaTion At Runtime
#  Copyright (C) 1999-2002 SuSE Linux AG
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
#               Matthias G. Eckermann
#               Stephan M�ller
#               Janto Trappe
#               Waldemar Brodkorb
#               Bj�rn Jacke
#		Bernhard Thoni
#		Pascal Fuckerieder
#
#  $Log: sitar.spec,v $
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
#  - added Bj�rn Jacke to list of authors
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

Vendor:		SuSE, Germany
Distribution:	SuSE Linux
Name:		sitar
Packager:	mge@suse.de
Version:	0.7.1
Release:	6
Summary:	System InformaTion At Runtime
Source:		sitar-%{version}.tar.gz
Copyright:	GPL
Group: 		Applications/System
BuildRoot:	/tmp/root-%{name}/
BuildArch: 	noarch

%description 
Prepare system information using perl and binary tools,
reading the /proc filesystem, ...
Output is in HTML and LaTeX (planned: XML, SQL), 
can be converted to PS and PDF.
This program must run as "root".
Comment: Sitar is an ancient Indian instrument as well.
Authors:
--------
	Matthias Eckermann <mge@suse.de>,
	Stephan Mueller, Janto Trappe, Waldemar Brodkorb, Bjoern Jacke,
	Bernhard Thoni, Pascal Fuckerieder

%prep
%setup

%build
make

%install
make DESTDIR=${RPM_BUILD_ROOT} install
%{?suse_check}

%files
%doc sitar.html sitar.ps LICENSE
%attr(700, root, root) /usr/sbin/sitar.pl
%attr(700, root, root) /usr/sbin/sitar
%attr(700, root, root) /usr/sbin/support_all.pl
/usr/share/man/man1/sitar.1.gz
/usr/share/man/man1/support_all.1.gz
/usr/share/sitar/suse.png
/usr/share/sitar/proc.txt

%clean
if [ -n "$RPM_BUILD_ROOT" ] ; then
   [ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
fi

