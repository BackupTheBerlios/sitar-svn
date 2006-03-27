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

DESTDIR		=
PREFIX		= /usr
DOCDIR		= $(PREFIX)/share/doc/packages
MANDIR		= $(PREFIX)/share/man/man1
PERL		= /usr/bin/perl
RELEASE		= 1.0.5

SVNVERSION     := $(shell svnversion -n . | sed "s/:/./" )
RELDATE        := $(shell date +"%Y%m%d")
CFG_PFRAGS	= pfrags/cfg2scm.header.pl				\
		  pfrags/cfg2scm.manpage.pl 				\
		  pfrags/cfg2scm.globals.pl 				\
		  pfrags/functions.cfg2scm/group_minor.pl		\
		  pfrags/functions.cfg2scm/group_help.pl		\
		  pfrags/functions.cfg2scm/group_read_configfile.pl	\
		  pfrags/functions.common/si_check_consistency.pl	\
		  pfrags/functions.common/si_find_unpacked.pl		\
		  pfrags/functions.cfg2scm/group_core.pl		\
		  pfrags/cfg2scm.main.pl

SITAR_PFRAGS	= pfrags/sitar.header.pl 				\
		  pfrags/sitar.manpage.pl 				\
		  pfrags/sitar.globals.pl 				\
		  pfrags/functions.sitar/group_output_xml.pl		\
		  pfrags/functions.sitar/group_output_html.pl		\
		  pfrags/functions.sitar/group_output_tex.pl		\
		  pfrags/functions.sitar/group_output_dispatcher.pl	\
		  pfrags/functions.sitar/group_minor.pl			\
		  pfrags/functions.sitar/group_read_configfile.pl	\
		  pfrags/functions.sitar/si_readfile.pl			\
		  pfrags/functions.sitar/si_cpuinfo.pl			\
		  pfrags/functions.sitar/si_general_sys.pl		\
		  pfrags/functions.sitar/si_proc_kernel.pl		\
		  pfrags/functions.sitar/group_swraid.pl		\
		  pfrags/functions.sitar/si_pnp.pl			\
		  pfrags/functions.sitar/si_proc_modules.pl		\
		  pfrags/functions.sitar/si_pci.pl			\
		  pfrags/functions.sitar/si_lsdev.pl			\
		  pfrags/functions.sitar/si_ide.pl			\
		  pfrags/functions.sitar/si_dac960.pl			\
		  pfrags/functions.sitar/si_compaq_smart.pl		\
		  pfrags/functions.sitar/si_gdth.pl			\
		  pfrags/functions.sitar/si_ips.pl			\
		  pfrags/functions.sitar/si_scsi.pl			\
		  pfrags/functions.sitar/si_df.pl			\
		  pfrags/functions.sitar/si_mount.pl			\
		  pfrags/functions.sitar/si_ifconfig.pl			\
		  pfrags/functions.sitar/si_route.pl			\
		  pfrags/functions.sitar/group_firewalling.pl		\
		  pfrags/functions.sitar/si_chkconfig.pl		\
		  pfrags/functions.sitar/group_configurations.pl	\
		  pfrags/functions.sitar/group_proc_fs.pl		\
		  pfrags/functions.sitar/si_immunix_apparmor.pl		\
		  pfrags/functions.sitar/group_etc_analysis.pl		\
		  pfrags/functions.sitar/group_kernel.pl		\
		  pfrags/functions.sitar/group_packagelists.pl		\
		  pfrags/functions.sitar/si_selection_yast2.pl		\
		  pfrags/functions.common/si_check_consistency.pl	\
		  pfrags/functions.common/si_find_unpacked.pl		\
		  pfrags/functions.sitar/group_help.pl			\
		  pfrags/functions.sitar/group_run_sitar.pl		\
		  pfrags/sitar.main.pl

#-----------------------------------------------------------------------

.PHONY:		default
default:	sitar.pl cfg2scm.pl sitar.1 sitar.html sitar.ps		\
		cfg2scm.1 cfg2scm.html cfg2scm.ps sitar.spec

.PHONY:		dist
dist:		sitar-$(RELEASE).tar.bz2

.PHONY:		clean
clean:
	rm -f *.ps *.dvi *.log *.toc *.pdf *.aux *.tex *.sel pod2htm*	\
	      *.part *.html *.sql *~ *-selections support_all.pl	\
	      sitar.pl sitar.1 sitar.html sitar.ps sitar.spec		\
	      cfg2scm.pl cfg2scm.1 cfg2scm.html cfg2scm.ps cfg2scm.spec	\
	      sitar-$(RELEASE).tar.bz2

#-----------------------------------------------------------------------

srcdir		= ../sitar
TMPDIR		= /tmp

sitar-$(RELEASE).tar.bz2:	clean sitar.spec sitar.pl cfg2scm.pl
	cwd=`pwd`;							\
	rm -f $@ ; rm -rf $(TMPDIR)/sitar-$$$$;				\
	umask 0022; mkdir $(TMPDIR)/sitar-$$$$;				\
	mkdir $(TMPDIR)/sitar-$$$$/sitar-$(RELEASE); 			\
	tar -C $(srcdir) -cSf - . --exclude=.svn --exclude=$@		\
	| tar -C $(TMPDIR)/sitar-$$$$/sitar-$(RELEASE) -xBSpf - ;	\
	tar -C $(TMPDIR)/sitar-$$$$ -cspjf $${cwd}/$@ sitar-$(RELEASE);	\
	rm -rf $(TMPDIR)/sitar-$$$$

sitar.spec:   sitar.spec.in
	$(PERL) -p -e '$$pre="$(PREFIX)";'				\
		-e 's/%%SITAR_PREFIX%%/$$pre/; '			\
		-e 's/%%SITAR_RELEASE%%/$(RELEASE)/;'			\
		-e 's/%%SITAR_SVNVERSION%%/$(SVNVERSION)/;'		\
		$< > $@

.PHONY:		rpm
rpm:	sitar-$(RELEASE).tar.bz2
	rpmbuild -ta $<

signed:	sitar-$(RELEASE).tar.bz2
	rpmbuild -ta --sign $<

#-----------------------------------------------------------------------

sitar.pl: $(SITAR_PFRAGS)
	cat $(SITAR_PFRAGS) |						\
	$(PERL) -p -e '$$pre="$(PREFIX)";'				\
		-e 's/%%SITAR_PREFIX%%/$$pre/; '			\
		-e 's/%%SITAR_RELEASE%%/$(RELEASE)/;' 			\
		-e 's/%%SITAR_SVNVERSION%%/$(SVNVERSION)/;' > $@
	chmod 755 sitar.pl

sitar.1:	sitar.pl
	pod2man --center=" " --release="$(RELEASE)-$(SVNVERSION)"	\
		--date=$(RELDATE) sitar.pl > sitar.$$$$;		\
	$(PERL) -p -e 's/.if n .na/.\\\".if n .na/;' sitar.$$$$ > $@;	\
	rm -f sitar.$$$$

sitar.html:	sitar.pl
	pod2html --infile=sitar.pl --outfile=sitar.html			\
		 --title "SITAR - System InformaTion At Runtime"

sitar.ps:	sitar.1
	groff -man -Tps $< > $@

#-----------------------------------------------------------------------

cfg2scm.pl: $(CFG_PFRAGS)
	cat $(CFG_PFRAGS) |						\
	$(PERL) -p -e '$$pre="$(PREFIX)";'				\
		-e 's/%%CFG2SCM_PREFIX%%/$$pre/; '			\
		-e 's/%%CFG2SCM_RELEASE%%/$(RELEASE)/;'			\
		-e 's/%%CFG2SCM_SVNVERSION%%/$(SVNVERSION)/;' > $@
	chmod 755 cfg2scm.pl

cfg2scm.1:	cfg2scm.pl
	pod2man --center=" " --release="$(RELEASE)-$(SVNVERSION)"	\
		--date=$(RELDATE) cfg2scm.pl > cfg2scm.$$$$;		\
	$(PERL) -p -e 's/.if n .na/.\\\".if n .na/;' cfg2scm.$$$$ > $@;	\
	rm -f cfg2scm.$$$$ pod2*.tmp

cfg2scm.html:	cfg2scm.pl
	pod2html --infile=cfg2scm.pl --outfile=cfg2scm.html		\
		 --title "CFG2SCM - Check configuration changes into SCM"
	rm -f pod2*.tmp

cfg2scm.ps:	cfg2scm.1
	groff -man -Tps $< > $@

#-----------------------------------------------------------------------

test_cvs:	cfg2scm.pl
	rm -rf /tmp/testcvs*
	cvs -d /tmp/testcvs init
	./cfg2scm.pl --storage="cvs" --non-root="Yes" --debug		\
		     --base-url="/tmp/testcvs"
	rm -rf /tmp/testcvs*

test_tar:	cfg2scm.pl
	./cfg2scm.pl --storage="tar"     --non-root="Yes" --debug
	./cfg2scm.pl --storage="tar.gz"  --non-root="Yes" --debug
	./cfg2scm.pl --storage="tar.bz2" --non-root="Yes" --debug

#-----------------------------------------------------------------------

INSTALL		= install -c
INSTALL_PROGRAM	= $(INSTALL) -m 755
INSTALL_DATA	= $(INSTALL) -m 644

INSTALL_DEPS	= sitar.1 sitar.ps sitar.html sitar.pl cfg2scm.1	\
		  cfg2scm.pl cfg2scm.ps cfg2scm.html

.PHONY:	install
install:	mkinstalldirs $(INSTALL_DEPS)
	$(INSTALL_DATA) sitar.sysconfig $(DESTDIR)/etc/sysconfig/sitar
	$(INSTALL_DATA) cfg2scm.sysconfig $(DESTDIR)/etc/sysconfig/cfg2scm
	$(INSTALL_PROGRAM) sitar.pl cfg2scm.pl $(DESTDIR)/$(PREFIX)/sbin
	ln -snf $(PREFIX)/sbin/sitar.pl $(DESTDIR)/$(PREFIX)/sbin/sitar
	$(INSTALL_DATA) proc.txt $(DESTDIR)/$(PREFIX)/share/sitar/proc.txt
#
	$(INSTALL_DATA) sitar.1 cfg2scm.1 $(DESTDIR)/$(MANDIR)
	gzip $(DESTDIR)/$(MANDIR)/sitar.1 $(DESTDIR)/$(MANDIR)/cfg2scm.1
#
	$(INSTALL_DATA) sitar.html sitar.ps LICENSE cfg2scm.html	\
			cfg2scm.ps $(DESTDIR)/$(DOCDIR)/sitar
# ln -snf $(PREFIX)/sbin/sitar.pl $(DESTDIR)/$(PREFIX)/sbin/support_all.pl
# ln -snf $(MANDIR)/sitar.1.gz $(DESTDIR)/$(MANDIR)/support_all.1.gz

.PHONY:	mkinstalldirs
mkinstalldirs:
	$(INSTALL) -d -m 755	\
		$(DESTDIR)/var/lib/support				\
		$(DESTDIR)/$(PREFIX)/sbin				\
		$(DESTDIR)/$(MANDIR)					\
		$(DESTDIR)/$(DOCDIR)/sitar				\
		$(DESTDIR)/etc/sysconfig				\
		$(DESTDIR)/$(PREFIX)/share/sitar

.PHONY:	perltidy
perltidy:	cfg2scm.pl sitar.pl
	perltidy -i=8 -t -l=0 -nbbc -nbbb -bbs -mbl=1 -nbl -bar -sob	\
			-ce -sbt=0 -bt=0 -pt=0 -nola cfg2scm.pl
	perltidy -i=8 -t -l=0 -nbbc -nbbb -bbs -mbl=1 -nbl -bar -sob	\
			-ce -sbt=0 -bt=0 -pt=0 -nola sitar.pl

#-----------------------------------------------------------------------

