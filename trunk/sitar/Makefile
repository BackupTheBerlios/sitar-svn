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
#		Stephan Müller 		Janto Trappe
#		Waldemar Brodkorb 	Björn Jacke
#		Bernhard Thoni 		Pascal Fuckerieder
#		Andreas Rother 		Uwe Hering
#		Jan Jensen 		Falko Trojahn
#		Stephan Martin		Holger Dopp
#		Seth Arnold
#

PREFIX=/usr
DOCDIR=${PREFIX}/share/doc/packages
PERL=/usr/bin/perl
RELEASE=0.9.3
RELDATE=$(shell date +"%Y%m%d")

default	:	sitar.pl sitar.1 sitar.html sitar.ps

tar:		/tmp/sitar-${RELEASE}.tar.bz2

clean:
	-rm -f *.ps *.dvi *.log *.toc *.pdf *.aux *.tex *.sel *.part *.html *.sql *~ sitar.pl support_all.pl sitar.1 sitar.html sitar.ps pod2htm* *-selections

/tmp/sitar-${RELEASE}.tar.bz2:	clean
	- (pushd .. ; ln -s sitar sitar-${RELEASE}; tar cvSjpf /tmp/sitar-${RELEASE}.tar.bz2 sitar-${RELEASE}/* ; rm -f sitar-${RELEASE} ; popd)

rpm:	clean
	- (pushd .. ; ln -s sitar sitar-${RELEASE}; tar cvjSpf /tmp/sitar-${RELEASE}.tar.bz2 sitar-${RELEASE}/* ; rm -f sitar-${RELEASE} ; popd)
	- (pushd /tmp/ ; rpmbuild -ta sitar-${RELEASE}.tar.bz2 ; chmod 777 /tmp/sitar-${RELEASE}.tar.bz2 ; popd)
	- rm -f /tmp/sitar-${RELEASE}.tar.bz2

signed:	clean
	- (pushd .. ; ln -s sitar sitar-${RELEASE}; tar cvjSpf /tmp/sitar-${RELEASE}.tar.bz2 sitar-${RELEASE}/* ; rm -f sitar-${RELEASE} ; popd)
	- (pushd /tmp/ ; rpmbuild -ta --sign sitar-${RELEASE}.tar.bz2 ; chmod 777 /tmp/sitar-${RELEASE}.tar.bz2 ; popd)
	- rm -f /tmp/sitar-${RELEASE}.tar.bz2

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

perltidy:	sitar.pl.in
	perltidy -i=8 -t -l=0 -nbbc -nbbb -bbs -mbl=1 -nbl -bar -sob -ce -sbt=0 -bt=0 -pt=0 -nola sitar.pl.in

#
#  $Log: Makefile,v $
#  Revision 1.43  2005/03/11 08:55:38  mge
#  improved Immunix/AppArmor integration; thanks to Seth Arnold
#
#  Revision 1.42  2005/03/08 15:37:01  mge
#  added support for AppArmor by Immunix
#
#  Revision 1.41  2005/02/11 20:04:48  mge
#  0.9.pre7: added cvs2rpmlog.pl for changelog in RPM
#
#  Revision 1.40  2005/02/09 13:02:04  mge
#  small patch regarding /proc/cpuinfo
#
#  Revision 1.39  2005/01/28 16:18:07  mge
#  exit with error, if target directory of output-file does not exist
#
#  Revision 1.38  2005/01/24 12:53:32  mge
#  added HD and SM to list of contributors/helpers
#
#  Revision 1.37  2005/01/24 09:48:14  mge
#  fixed error in TeX-output (forgotten chomp)
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
#  Revision 1.33  2005/01/18 11:23:42  mge
#  removed suse.png suse.xpm
#
#  Revision 1.32  2005/01/18 11:21:36  mge
#  SuSE Linux AG -> SuSE Linux, a Novell Business
#
#  Revision 1.31  2004/09/17 14:56:07  mge
#  added lspci for kernel 2.6 without /proc/pci
#
#  Revision 1.30  2004/03/22 14:38:46  mge
#  - Update LICENSE to 2004
#  - fix typo in Makefile ( cvzSpf -> tvSjpf )
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

