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
#  Authors:
#               Matthias G. Eckermann
#               Stephan Müller
#               Janto Trappe
#               Waldemar Brodkorb
#		Bernhard Thoni
#		Pascal Fuckerieder 
#
#  $Log: Makefile,v $
#  Revision 1.17  2002/11/28 01:35:16  mge
#  - Added UnitedLinux finally
#  - Fixed TeX output
#  - Make --outfile --format run (did not work properly)
#  Release 0.7.5
#
#  Revision 1.16  2002/11/27 13:58:26  mge
#  Added patch for RedHat Linux from Andreas Rother <Andreas.Rother@eplus.de>
#  Changes:
#  	- don't use "si_lsdev" on RedHat
#  	- parse alle crontabs (we should make that an option later)
#  Thanks to him!
#  Release 0.7.4
#
#  Revision 1.15  2002/06/01 21:14:24  waldb
#  fixed tex output on debian systems
#  removed restrictions from pod (iptables support is now included)
#  only shortdescriptions for deb's
#  commented out selection routine for debs
#  software raid section only when /proc/mdstat exist
#  new version in Makefile
#
#  Revision 1.14  2002/04/11 14:43:32  mge
#  added check for /etc/sysconfig
#  release 0.7.1
#
#  Revision 1.13  2002/03/18 16:15:59  mge
#  added Pascal Fuckerieder to contributors
#  release is 0.7.0 now:-)
#
#  Revision 1.12  2002/01/14 15:39:49  mge
#  added Bernhard Thoni to contributors
#
#  Revision 1.11  2001/09/07 00:09:09  mge
#  - released 0.6.8
#
#  Revision 1.10  2001/09/03 10:28:27  waldb
#  added removing of deb-selections
#  creation of symlink support_all.pl
#
#  Revision 1.9  2001/08/21 19:00:28  waldb
#  added variable DOCDIR to install documentation in a correct way for
#  all distributions, modified sitar.spec to use macro %doc for docfiles
#
#  Revision 1.8  2001/08/20 22:26:34  mge
#  make "support_all.pl" and "sitar.pl" work slightly different:
#  "sitar.pl" will do everything, as the old "sitar.pl" did, "support_all.pl"
#  uses the command line parameters.
#
#  Revision 1.7  2001/08/20 04:16:39  mge
#  - manpage cleanups
#  - changed release num to 0.6.6
#
#  Revision 1.6  2001/08/15 04:27:40  mge
#  improved semi-automated rpm-generation
#
#  Revision 1.5  2001/08/15 03:57:30  mge
#  Makefile cleanups, introduced CVS-log into
#  	CodingStyle Makefile sitar.pl.in sitar.spec
#
#

PREFIX=usr
DOCDIR=${PREFIX}/share/doc
PERL=/usr/bin/perl
RELEASE=0.7.5
RELDATE=$(shell date +"%Y%m%d")

default	:	sitar.pl sitar.1 sitar.html sitar.ps

tar:		/tmp/sitar-${RELEASE}.tar.gz

clean:
	-rm -f *.ps *.dvi *.log *.toc *.pdf *.aux *.tex *.sel *.part *.html *.sql *~ sitar.pl support_all.pl sitar.1 sitar.html sitar.ps pod2htm* *-selections

/tmp/sitar-${RELEASE}.tar.gz:	clean
	- (pushd .. ; ln -s sitar sitar-${RELEASE}; tar cvzSpf /tmp/sitar-${RELEASE}.tar.gz sitar-${RELEASE}/* ; rm -f sitar-${RELEASE} ; popd)

rpm:	clean
	- (pushd .. ; ln -s sitar sitar-${RELEASE}; tar cvzSpf /tmp/sitar-${RELEASE}.tar.gz sitar-${RELEASE}/* ; rm -f sitar-${RELEASE} ; popd)
	- (pushd /tmp/ ; rpm -ta sitar-${RELEASE}.tar.gz ; chmod 777 /tmp/sitar-${RELEASE}.tar.gz ; popd)
	- rm -f /tmp/sitar-${RELEASE}.tar.gz

sitar.pl:	sitar.pl.in Makefile
	${PERL} -p 	-e '$$pre="${PREFIX}";' \
			-e 's/%%PREFIX%%/$$pre/; '\
			-e 's/%%RELEASE%%/${RELEASE}/;'\
			sitar.pl.in > sitar.pl
	chmod 755 sitar.pl
	ln -fs sitar.pl support_all.pl

sitar.1:	sitar.pl
	pod2man --center=" " sitar.pl > sitar.01
	${PERL} -p	-e 's/.if n .na/.\\\".if n .na/;'\
			sitar.01 > sitar.1
	rm sitar.01

sitar.html:	sitar.pl
	pod2html --infile=sitar.pl --outfile=sitar.html\
	--title "SITAR - System InformaTion At Runtime"

sitar.ps:	sitar.1
	groff -man -Tps sitar.1 > sitar.ps

install:	sitar.pl sitar.1 sitar.ps sitar.html
	install	-d					${DESTDIR}/${PREFIX}/sbin\
							${DESTDIR}/${PREFIX}/share/sitar\
							${DESTDIR}/${PREFIX}/share/man/man1\
							${DESTDIR}/${DOCDIR}/sitar/
	install -m 700 	sitar.pl			${DESTDIR}/${PREFIX}/sbin/sitar.pl
	ln -sf /${PREFIX}/sbin/sitar.pl			${DESTDIR}/${PREFIX}/sbin/support_all.pl
	ln -sf /${PREFIX}/sbin/sitar.pl			${DESTDIR}/${PREFIX}/sbin/sitar
	install -m 644 	sitar.1				${DESTDIR}/${PREFIX}/share/man/man1/sitar.1
	gzip						${DESTDIR}/${PREFIX}/share/man/man1/sitar.1
	ln -sf /${PREFIX}/share/man/man1/sitar.1.gz 	${DESTDIR}/${PREFIX}/share/man/man1/support_all.1.gz
	install	-m 644	sitar.html			${DESTDIR}/${DOCDIR}/sitar/sitar.html
	install	-m 644	sitar.ps			${DESTDIR}/${DOCDIR}/sitar/sitar.ps
	install	-m 644	LICENSE				${DESTDIR}/${DOCDIR}/sitar/LICENSE
	install -m 644 	proc.txt			${DESTDIR}/${PREFIX}/share/sitar/proc.txt
	install -m 755 	suse.png			${DESTDIR}/${PREFIX}/share/sitar/suse.png

