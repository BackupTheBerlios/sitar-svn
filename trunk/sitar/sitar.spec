#
#  SITAR - System InformaTion At Runtime
#  Copyright (C) 1999-2001 SuSE Linux AG
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
#  Authors:
#               Matthias G. Eckermann
#               Stephan Müller
#               Janto Trappe
#               Waldemar Brodkorb
#
#  $Log: sitar.spec,v $
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
#

Vendor:		SuSE, Germany
Distribution:	SuSE Linux
Name:		sitar
Packager:	mge@suse.de
Version:	0.6.6
Release:	1
Summary:	System InformaTion At Runtime
Source:		sitar-%{version}.tar.gz
Copyright:	GPL
Group: 		Applications/System
BuildRoot:	/tmp/root-%{name}/

%%description 
Prepare system information using perl and binary tools,
reading the /proc filesystem, ...
Output is in HTML and LaTeX (planned: XML, SQL), 
can be converted to PS and PDF.
This program must run as "root".
Comment: Sitar is an ancient Indian instrument as well.
Authors:
--------
	Matthias Eckermann <mge@suse.de>,
	Stephan Mueller, Janto Trappe, Waldemar Brodkorb 

%prep
%setup

%build
make

%install
make DESTDIR=${RPM_BUILD_ROOT} install
%{?suse_check}

%files
%attr(744, root, root) /usr/sbin/sitar.pl
%attr(744, root, root) /usr/sbin/sitar
/usr/share/man/man1/sitar.1.gz
/usr/share/doc/packages/sitar/sitar.html
/usr/share/doc/packages/sitar/sitar.ps
/usr/share/doc/packages/sitar/LICENSE
/usr/share/sitar/suse.png
/usr/share/sitar/proc.txt

%clean
if [ -n "$RPM_BUILD_ROOT" ] ; then
   [ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
fi

