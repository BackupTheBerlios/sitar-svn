#
#  SITAR - System InformaTion At Runtime
#  CFG2SCM - Check configuration changes into SCM
#  Copyright (C) 1999-2006 SuSE Linux, a Novell Business
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

PREFIX		:=	/usr
DOCDIR		:=	${PREFIX}/share/doc/packages
PERL		:=	/usr/bin/perl
RELEASE		:=	1.0.0
SVNVERSION      :=      $(shell svnversion -n . | sed "s/:/./" )
RELDATE         :=      $(shell date +"%Y%m%d")


default	:	sitar.pl sitar.1 sitar.html sitar.ps cfg2scm.pl cfg2scm.1 cfg2scm.html cfg2scm.ps sitar.spec

tar:		/tmp/sitar-${RELEASE}.tar.bz2

clean:
	-rm -f *.ps *.dvi *.log *.toc *.pdf *.aux *.tex *.sel *.part *.html *.sql *~ sitar.pl support_all.pl sitar.1 sitar.html sitar.ps cfg2scm.pl cfg2scm.1 cfg2scm.html cfg2scm.ps cfg2scm.spec pod2htm* *-selections sitar.spec

/tmp/sitar-${RELEASE}.tar.bz2:	clean sitar.spec
	- ( pushd ..; cp -a sitar /tmp/sitar-${RELEASE} ; rm -rf /tmp/sitar-${RELEASE}/.svn ;  popd )
	- ( pushd /tmp/sitar-${RELEASE} ; cp -a sitar.pl.in sitar.pl.in.pre ; ${PERL} -p -e '$$pre="${PREFIX}";' -e 's/%%SITAR_PREFIX%%/$$pre/; ' -e 's/%%SITAR_RELEASE%%/${RELEASE}/;' -e 's/%%SITAR_SVNVERSION%%/${SVNVERSION}/;' sitar.pl.in.pre > sitar.pl.in ; rm -f sitar.pl.in.pre ; popd )
	- ( pushd /tmp/sitar-${RELEASE} ; cp -a cfg2scm.pl.in cfg2scm.pl.in.pre ; ${PERL} -p -e '$$pre="${PREFIX}";' -e 's/%%CFG2SCM_PREFIX%%/$$pre/; ' -e 's/%%CFG2SCM_RELEASE%%/${RELEASE}/;' -e 's/%%CFG2SCM_SVNVERSION%%/${SVNVERSION}/;' cfg2scm.pl.in.pre > cfg2scm.pl.in ; rm -f cfg2scm.pl.in.pre ; popd )
	- ( pushd /tmp/ ; tar cvSjpf /tmp/sitar-${RELEASE}.tar.bz2 sitar-${RELEASE}/* ; rm -rf /tmp/sitar-${RELEASE} ; popd )

sitar.spec:   sitar.spec.in
	${PERL} -p -e '$$pre="${PREFIX}";' -e 's/%%SITAR_PREFIX%%/$$pre/; ' -e 's/%%SITAR_RELEASE%%/${RELEASE}/;' -e 's/%%SITAR_SVNVERSION%%/${SVNVERSION}/;' sitar.spec.in > sitar.spec

rpm:	/tmp/sitar-${RELEASE}.tar.bz2
	- (pushd /tmp/ ; rpmbuild -ta sitar-${RELEASE}.tar.bz2 ; chmod 777 /tmp/sitar-${RELEASE}.tar.bz2 ; popd)
	- rm -f /tmp/sitar-${RELEASE}.tar.bz2

signed:	/tmp/sitar-${RELEASE}.tar.bz2
	- (pushd /tmp/ ; rpmbuild -ta --sign sitar-${RELEASE}.tar.bz2 ; chmod 777 /tmp/sitar-${RELEASE}.tar.bz2 ; popd)
	- rm -f /tmp/sitar-${RELEASE}.tar.bz2

sitar.pl:	sitar.pl.in Makefile
	${PERL} -p -e '$$pre="${PREFIX}";' -e 's/%%SITAR_PREFIX%%/$$pre/; ' -e 's/%%SITAR_RELEASE%%/${RELEASE}/;' -e 's/%%SITAR_SVNVERSION%%/${SVNVERSION}/;' sitar.pl.in > sitar.pl
	chmod 755 sitar.pl
	ln -fs sitar.pl support_all.pl

sitar.1:	sitar.pl
	pod2man --center=" " --release="${RELEASE}-${SVNVERSION}" --date=${RELDATE} sitar.pl > sitar.01
	${PERL} -p	-e 's/.if n .na/.\\\".if n .na/;'\
			sitar.01 > sitar.1
	rm sitar.01

sitar.html:	sitar.pl
	pod2html  --infile=sitar.pl --outfile=sitar.html\
	--title "SITAR - System InformaTion At Runtime"

sitar.ps:	sitar.1
	groff -man -Tps sitar.1 > sitar.ps

cfg2scm.pl:	cfg2scm.pl.in Makefile
	${PERL} -p -e '$$pre="${PREFIX}";' -e 's/%%CFG2SCM_PREFIX%%/$$pre/; ' -e 's/%%CFG2SCM_RELEASE%%/${RELEASE}/;' -e 's/%%CFG2SCM_SVNVERSION%%/${SVNVERSION}/;' cfg2scm.pl.in > cfg2scm.pl
	chmod 755 cfg2scm.pl

cfg2scm.1:	cfg2scm.pl
	pod2man --center=" " --release="${RELEASE}-${SVNVERSION}" --date=${RELDATE} cfg2scm.pl > cfg2scm.01
	${PERL} -p	-e 's/.if n .na/.\\\".if n .na/;' cfg2scm.01 > cfg2scm.1
	-rm cfg2scm.01
	-rm pod2*.tmp

cfg2scm.html:	cfg2scm.pl
	pod2html  --infile=cfg2scm.pl --outfile=cfg2scm.html --title "CFG2SCM - Check configuration changes into SCM"
	-rm pod2*.tmp

cfg2scm.ps:	cfg2scm.1
	groff -man -Tps cfg2scm.1 > cfg2scm.ps

test_cvs:	cfg2scm.pl
	cvs -d /tmp/testcvs init
	./cfg2scm.pl --storage="cvs"     --non-root="Yes" --debug --base-url="/tmp/testcvs"
	./cfg2scm.pl --storage="cvs"     --non-root="Yes" --debug --base-url="/tmp/testcvs"
	./cfg2scm.pl --storage="cvs"     --non-root="Yes" --debug --base-url="/tmp/testcvs"
	rm -rf /tmp/testcvs*

test_tar:	cfg2scm.pl
	./cfg2scm.pl --storage="tar"     --non-root="Yes" --debug
	./cfg2scm.pl --storage="tar.gz"  --non-root="Yes" --debug
	./cfg2scm.pl --storage="tar.bz2" --non-root="Yes" --debug

install:	install-sitar install-cfg2scm 
	install -d					${DESTDIR}/var/lib/support

install-sitar:	sitar.pl sitar.1 sitar.ps sitar.html
	install	-d					${DESTDIR}/${PREFIX}/sbin\
							${DESTDIR}/${PREFIX}/share/sitar\
							${DESTDIR}/${PREFIX}/share/man/man1\
							${DESTDIR}/${DOCDIR}/sitar/\
							${DESTDIR}/etc/sysconfig
	install -m 644 	sitar.sysconfig			${DESTDIR}/etc/sysconfig/sitar
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

install-cfg2scm: cfg2scm.pl cfg2scm.1
	install	-d					${DESTDIR}/${PREFIX}/sbin\
							${DESTDIR}/${PREFIX}/share/cfg2scm\
							${DESTDIR}/${PREFIX}/share/man/man1\
							${DESTDIR}/etc/sysconfig
	install -m 700 	cfg2scm.pl			${DESTDIR}/${PREFIX}/sbin/cfg2scm.pl
	install -m 644 	cfg2scm.1			${DESTDIR}/${PREFIX}/share/man/man1/cfg2scm.1
	install -m 644 	cfg2scm.sysconfig		${DESTDIR}/etc/sysconfig/cfg2scm
	gzip						${DESTDIR}/${PREFIX}/share/man/man1/cfg2scm.1

doc-install-cfg2scm:	cfg2scm.ps cfg2scm.html
	install	-d					${DESTDIR}/${DOCDIR}/cfg2scm/
	install	-m 644	cfg2scm.html			${DESTDIR}/${DOCDIR}/cfg2scm/cfg2scm.html
	install	-m 644	cfg2scm.ps			${DESTDIR}/${DOCDIR}/cfg2scm/cfg2scm.ps
	install	-m 644	LICENSE				${DESTDIR}/${DOCDIR}/cfg2scm/LICENSE

perltidy:	cfg2scm.pl.in sitar.pl.in
	perltidy -i=8 -t -l=0 -nbbc -nbbb -bbs -mbl=1 -nbl -bar -sob -ce -sbt=0 -bt=0 -pt=0 -nola cfg2scm.pl.in
	perltidy -i=8 -t -l=0 -nbbc -nbbb -bbs -mbl=1 -nbl -bar -sob -ce -sbt=0 -bt=0 -pt=0 -nola sitar.pl.in

