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
#  $Log: Makefile,v $
#  Revision 1.5  2001/08/15 03:57:30  mge
#  Makefile cleanups, introduced CVS-log into
#  	CodingStyle Makefile sitar.pl.in sitar.spec
#
#

PREFIX=usr
PERL=/usr/bin/perl
RELEASE=0.6.5
RELDATE=$(shell date +"%Y%m%d")

default	:	sitar.pl sitar.1 sitar.html sitar.ps

clean:
	-rm *.ps *.dvi *.log *.toc *.pdf *.aux *.tex *.sel *.part *.html *.sql *~ sitar.pl sitar.1 sitar.html sitar.ps pod2htm*

tar:		clean
		- (pushd ..; tar cvzSpf sitar-${RELEASE}.tar.gz sitar-${RELEASE}/ ; popd)

sitar.pl:	sitar.pl.in Makefile
	${PERL} -p 	-e '$$pre="${PREFIX}";' \
			-e 's/%%PREFIX%%/$$pre/; '\
			-e 's/%%RELEASE%%/${RELEASE}/;'\
			sitar.pl.in > sitar.pl
	chmod 755 sitar.pl

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
	install -d 			${DESTDIR}/${PREFIX}/share/sitar
	install	-d			${DESTDIR}/${PREFIX}/share/doc/packages/sitar/
	install -m 700 	sitar.pl	${DESTDIR}/${PREFIX}/sbin/sitar.pl
	install -m 644 	sitar.1		${DESTDIR}/${PREFIX}/share/man/man1/sitar.1
	gzip				${DESTDIR}/${PREFIX}/share/man/man1/sitar.1
	install	-m 644	sitar.html	${DESTDIR}/${PREFIX}/share/doc/packages/sitar/sitar.html
	install	-m 644	sitar.ps	${DESTDIR}/${PREFIX}/share/doc/packages/sitar/sitar.ps
	install	-m 644	LICENSE		${DESTDIR}/${PREFIX}/share/doc/packages/sitar/LICENSE
	install -m 644 	proc.txt	${DESTDIR}/${PREFIX}/share/sitar/proc.txt
	install -m 755 	suse.png	${DESTDIR}/${PREFIX}/share/sitar/suse.png

