#
# spec file for package sitar (Version 0.6.4)
# 
# Copyright  (c)  2001  SuSE GmbH  Nuernberg, Germany.
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
# 
# please send bugfixes or comments to feedback@suse.de.
#

# neededforbuild  
# usedforbuild    aaa_base aaa_dir autoconf automake base bash bindutil binutils bison bzip compress cpio cracklib db devs diffutils e2fsprogs file fileutils findutils flex gawk gcc gdbm gdbm-devel gettext glibc glibc-devel gpm gppshare groff gzip kbd less libtool libz lx_suse make mktemp modutils ncurses ncurses-devel net-tools netcfg nkitb pam pam-devel patch perl pgp ps rcs rpm sendmail sh-utils shadow strace syslogd sysvinit texinfo textutils timezone unzip util-linux vim xdevel xf86 xshared

Vendor:       SuSE GmbH, Nuernberg, Germany
Distribution: SuSE Linux 7.1a (i386)
Name:         sitar
Packager:     feedback@suse.de

Version:      0.6.4
Release:      0
Summary:      SuSE System InformaTion at Runtime
Source: sitar-%{version}.tar.gz
Copyright: GPL
Group: Applications/System

%%description 
Prepare system information using perl and binary tools,
reading the /proc filesystem, ...
Output is in HTML and (again since 0.6.0) LaTeX
(planned: XML, SQL), can be converted to PS and PDF.
This program must run as "root".
sitar.pl includes scsiinfo by Eric Youngdale, 
Michael Weller <eowmob@exp-math.uni-essen.de> 
and ide_info by David A. Hinds <dhinds@hyper.stanford.edu>.
Comment: Sitar is an ancient Indian instrument.
Authors:
--------
	Matthias Eckermann <mge@suse.de>
Thanks to:
----------
	Stephan Mueller <smueller@suse.de>
	and all the others of SuSE Munich!
							
%prep
%setup

%build
make

%install
make install
chmod 744 /usr/sbin/sitar.pl
%{?suse_check}

%files
/usr/sbin/sitar.pl
/usr/share/sitar/si_scsiinfo
/usr/share/sitar/suse.png
/usr/share/sitar/si_ide_info
/usr/share/sitar/proc.txt

%description
Prepare system information using perl and binary tools,
reading the /proc filesystem, ...
Output is in HTML (LaTeX; planned: XML, SQL),
can be converted to PS and PDF.
This program must be run as "root".
sitar.pl includes scsiinfo by Eric Youngdale,
Michael Weller <eowmob@exp-math.uni-essen.de>
and ide_info by David A. Hinds <dhinds@hyper.stanford.edu>.
Comment: Sitar is an ancient Indian instrument as well.

Authors:
--------
    Matthias Eckermann <mge@suse.de> with special thanks to 
    Stephan Mueller <smueller@suse.de>

SuSE series: ap


%changelog -n sitar
* Fri Jan 12 2001 - mge@suse.de
- update to 0.6.4
* Fri Nov 17 2000 - kukuk@suse.de
- Remove Requires tag, it is not necessary
* Mon Sep 18 2000 - mge@suse.de
- 0.6.3: 	fixed BUG 3865
- since 0.6.0: 	LaTeX output re-introduced
  new copyright-holder: now SuSE Linux Solutions AG
* Tue Jun 27 2000 - mge@suse.de
- 0.5.15: improved Table of contents
* Wed Mar 08 2000 - mge@suse.de
- 0.5.13: added /etc/fstab, /etc/passwd, /etc/group, /etc/inittab
  /var/spool/fax/etc/config,/var/spool/fax/etc/config.modem
* Mon Mar 06 2000 - mge@suse.de
- 0.5.12: improved HTML
* Fri Mar 03 2000 - mge@suse.de
- 0.5.11: added /etc/lilo.conf /etc/hosts /etc/aliases
  postfix now via "postconf -n"
  added table of contents
* Wed Mar 01 2000 - mge@suse.de
- 0.5.10: moved sitar.pl to /usr/sbin,
  all the other files to /usr/share/sitar
* Mon Feb 21 2000 - mge@suse.de
- 0.5.8: sysinfo is sitar now:
  sitar is an ancient indian instrument as well.
* Wed Feb 16 2000 - mge@suse.de
- initial public release 0.5.7
