
PREFIX=/usr

PERL=/usr/bin/perl
LATEX=latex
PDFL=pdflatex
DVIPS=dvips
HOSTNAME=$(shell /bin/hostname -f)
RELEASE=0.6.4
RELDATE=$(shell date +"%Y%m%d")

default	:	sitar.pl binaries

clean:
	-rm *.ps *.dvi *.log *.toc *.pdf *.aux *.tex *.sel *.part *.html *.sql *~ si_scsiinfo si_ide_info sitar.pl

tar:		clean
		- (pushd ..; tar cvzSpf sitar-${RELEASE}.tar.gz sitar-${RELEASE}/ ; popd)

binaries:	si_scsiinfo si_ide_info

sitar.pl:	sitar.pl.in Makefile
	${PERL} -p 	-e '$$pre="${PREFIX}";' \
			-e 's/%%PREFIX%%/$$pre/; '\
			-e 's/%%RELDATE%%/${RELDATE}/;'\
			-e 's/%%RELEASE%%/${RELEASE}/;'\
			sitar.pl.in > sitar.pl
	chmod 755 sitar.pl

dvi:	tex
	${LATEX} sitar-${HOSTNAME}.tex; ${LATEX} sitar-${HOSTNAME}.tex

ps: 	dvi
	${DVIPS} -o sitar-${HOSTNAME}.ps sitar-${HOSTNAME}.dvi

pdf:	tex
	${PDFL} sitar-${HOSTNAME}.tex; ${PDFL} sitar-${HOSTNAME}.tex

tex:	sitar-${HOSTNAME}.tex

html:	binaries
	${PERL} ./sitar.pl

install:	binaries sitar.pl
	-mkdir  -p ${PREFIX}/share/sitar
	install -m 700 	sitar.pl	${PREFIX}/sbin/sitar.pl
	install -m 700 	si_ide_info	${PREFIX}/share/sitar/si_ide_info
	install -m 700 	si_scsiinfo	${PREFIX}/share/sitar/si_scsiinfo
	install -m 644 	proc.txt	${PREFIX}/share/sitar/proc.txt
	install -m 755 	suse.png	${PREFIX}/share/sitar/suse.png

si_ide_info:	si_ide_info.c
	gcc -o si_ide_info si_ide_info.c -static -s

si_scsiinfo:	si_scsiinfo.c
	gcc -o si_scsiinfo si_scsiinfo.c -static -s

