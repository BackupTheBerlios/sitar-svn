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
RELEASE=0.9.4
SVNVERSION=$(shell svnversion .)
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
			-e 's/%%SITAR_PREFIX%%/$$pre/; '\
			-e 's/%%SITAR_RELEASE%%/${RELEASE}/;'\
			-e 's/%%SITAR_SVNVERSION%%/${SVNVERSION}/;'\
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

