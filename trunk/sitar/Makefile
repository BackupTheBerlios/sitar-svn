
PREFIX=/usr

PERL=/usr/bin/perl
LATEX=latex
PDFL=pdflatex
DVIPS=dvips
HOSTNAME=$(shell /bin/hostname -f)
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

dvi:	tex
	${LATEX} sitar-${HOSTNAME}.tex; ${LATEX} sitar-${HOSTNAME}.tex

ps: 	dvi
	${DVIPS} -o sitar-${HOSTNAME}.ps sitar-${HOSTNAME}.dvi

pdf:	tex
	${PDFL} sitar-${HOSTNAME}.tex; ${PDFL} sitar-${HOSTNAME}.tex

tex:	sitar-${HOSTNAME}.tex

html:
	${PERL} ./sitar.pl

install:	binaries sitar.pl
	-mkdir  -p ${PREFIX}/share/sitar
	install -m 700 	sitar.pl	${PREFIX}/sbin/sitar.pl
	install -m 644 	proc.txt	${PREFIX}/share/sitar/proc.txt
	install -m 755 	suse.png	${PREFIX}/share/sitar/suse.png

