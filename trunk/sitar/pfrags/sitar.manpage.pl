#
#	MANPAGE
#

=head1 NAME

SITAR - System InformaTion At Runtime

=head1 SYNOPSIS

sitar|sitar.pl B<--check-consistency> B<--find-unpacked> B<--format>=I<format> B<--outfile>=I<file|dir> B<--help> B<--version> 

Available I<format>s: html, tex, sdocbook, yast1, yast2

=head1 DESCRIPTION

Prepare system information using perl, reading the /proc filesystem. Output is in HTML, LaTeX, simplified docbook-xml (planned: SQL) and can be converted to PostScript and PDF. Sitar is an ancient Indian instrument as well (see  L<"HISTORY"> below).

There are three files/links available:

=over

=item sitar

=item sitar.pl

If called without B<--outfile> and/or without B<--format>, all available output formats are produced below /tmp/sitar-$hostname-$date. 

If called with B<--format> and B<--outfile> exactly this is produced.  Please note, that the format B<yast2> needs a directory given with the parameter B<--outfile>!

=item support_all.pl

must always be called with both options: B<--format> B<--outfile>, but does nothing, if called without any options.

=back

=head1 OPTIONS

=over

=item B<--help>

Prints a short summary of options.

=item B<--version>

Prints the sitar version

=item B<--check-consistency>

This option checks the consistency of configurations-files as declared in the RPMs, by invoking I<rpm -Vca>. It produces a file I</var/lib/support/Configuration_Consistency.include>, which is preserved between different sitar-runs.  The list contains all names of configuration files, which are tagged as configuration files within the RPMs and were changed compared to the release shipped within the RPMs.  

The following standard sitar-run includes the file I</var/lib/support/Configuration_Consistency.include>, as described below (section FILES) and prints out the full content of the changed files.  At the moment, it is neither possible nor intended, to print only the differences to the I<shipped> status.

Please note, that this really might need a long time (from 5-20 minutes).

=item B<--find-unpacked>

Find files below /etc, that do not belong to any RPM, and for that reason should be documented.
A file /var/lib/support/Find_Unpacked.include is written as "cache".

Please note, that this really might need a long time (from 5-20 minutes).

=item B<--format>=I<format>

Tell SITAR, which output format to use. At the moment four formats are supported:

=over

=item tex 

as an alias, also B<latex> can be used.

=item html

=item sdocbook

produces simplified docbook-xml; the format is not named B<xml>, because there are several (in theory: an arbitrary number) of xml flavours available.

=item yast1

=item yast2

Please note, that this format needs a directory given with the parameter B<--outfile>!

=back

=item B<--outfile>=I<file|dir> 

All formatted output will be stored in the file given here.  Please don't forget to give the right extension here: C<.html> for HTML, C<.tex> for TeX or LaTeX, C<.sdocbook.xml> for simplified docbook-xml, C<.sel> for YaST-Selection-files.

Please note, that the format B<yast2> needs a directory given with this parameter!

=back

=head1 FILES

=head2 file-lists in /var/lib/support/

From a tool called C<PaDS> by Thorsten Wandersmann sitar inherited the ability, to extend the list of configuration files. To achieve that, just put a perl-snippet in the directory C</var/lib/support/>; this snippet B<must> have the extension C<.include> and may include only one perl-statement: an array-declaration for the array C<@files>, that contains the file-names with full path, see EXAMPLES below.

See also B<--check-consistency> and B<--find-unpacked> above.

=head2 configuration files

sitar is able to use a configuration file, currently: /etc/sysconfig/sitar. On SUSE Linux systems, this file can be changed also using YaST's sysconfig-editor (System/Monitoring/sitar). The parameters in this file directly correspond global variables in sitar:

=over

=item SITAR_OPT_FORMAT

Type: list("","html","tex","sdocbook","yast1",yast2). Default: "". This parameter defines, which output-format to produce. The default: "" means all formats.

=item SITAR_OPT_OUTDIR

Type: string. Default: "". Directory for yast config files; mandatory, if SITAR_OPT_FORMAT==yast2

=item SITAR_OPT_OUTFILE

Type: string. Default: "". Name of the one output-file for SITAR_OPT_FORMAT=="html","tex","sdocbook","yast1"

=item SITAR_OPT_LIMIT

Type: integer(0:).  Default: 500000.  File size limit (byte) for files to recognize; 0=no limits.

=item SITAR_OPT_ALLCONFIGFILES

Type: list("On","Off","Auto"). Default:	"Auto".  

If "On", the hardcoded list of config-files is used; if "Off", the list is not used; 
if "Auto", and no files /var/lib/support/Configuration_Consistency.include AND /var/lib/support/Find_Unpacked.include exist, it is like "On", else like "Off"

=item SITAR_OPT_ALLSUBDOMAIN

Type: list("On","Off","Auto"). Default:	"Auto".

If "On", all files below /etc/subdomain.d | /etc/apparmor.d are scanned; if "Off", the files are not scanned by default;
if "Auto", and no files /var/lib/support/Configuration_Consistency.include AND /var/lib/support/Find_Unpacked.include exist, it is like "On", else like "Off"

=item SITAR_OPT_ALLSYSCONFIG="Auto"

Type: list("On","Off","Auto"). Default:	"".

If "On", all files below /etc/sysconfig/ are scanned; if "Off", the files are not scanned by default;
if "Auto", and no files /var/lib/support/Configuration_Consistency.include AND /var/lib/support/Find_Unpacked.include exist, it is like "On", else like "Off"

=item SITAR_OPT_GCONF

Type: yesno. Default: No. Include the many small config files below /etc/opt/gnome?

=item SITAR_OPT_LVMARCHIVE

Type: yesno. Default: No. Include /etc/lvm/archive/*?

=back

=head1 ERRORS

The program may B<silently> fail if either the C</proc> Filesystem does not exist or the program is not startet by the C<root> user.

=head1 DIAGNOSTICS

While running, stdout is redirected to the designated C<outfile> file. So one will find diagnostics in this file; this (not very helpful) behaviour may change in the future.

=head1 EXAMPLES

Check configuration files and produce the full stack of output-formats:

C<sitar --check-consistency>

For generating a HTML documentation type as user C<root>:
	
C<sitar.pl --format=html --outfile=/tmp/$HOSTNAME.html>

For PDF type as user C<root>:

C<sitar.pl --format=tex --outfile=/tmp/$HOSTNAME.tex>

and twice (as an ordinary user): 

C<pdflatex /tmp/$HOSTNAME.tex>

A typical file to include the configurations files of the application C<foobar> could look like this:

 # /var/lib/support/foobar.include
 
 @files= (
 	"/etc/opt/foobar/foo.conf",
 	"/etc/opt/foobar/bar.conf"
 	);

 # eof
 
=head1 AUTHOR

The SITAR project was created by Matthias G. Eckermann <mge@suse.de>;
Stephan M"uller helped with Firewalling and Security issues; Janto Trappe and
Waldemar Brodkorb created the Debian port; Bj"orn Jacke helped on several
issues; Bernhard Thoni introduced the software raid support; Pascal Fuckerieder
wrote the IPTables/Netfilter code and Andreas Rother submitted a patch for
running sitar on RedHat Linux. So finally these Linux Systems are supported:
SuSE Linux, Debian, RedHat.

With testing, bug-reporting, enhancements and code-contributions also helped: Uwe Hering, Jan Jensen, Falko Trojahn, Stephan Martin, Holger Dopp, Seth Arnold, Manfred Hollstein, Stefan Werden and others.

For more information on SITAR, see: http://sitar.berlios.de/

=head1 LICENSE

Copyright (C) 1999-2006 SuSE Linux, a Novell Business

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass
Ave, Cambridge, MA 02139, USA. 

=head1 HISTORY

The sitar is the invention of Amir Shusru, the famous poet and singer attached
to the Court of Sultan Alauddin Khilju of Delhi (1295-1315). This is the most
popular instrument in Northern India. The sitar is a lute-like instrument with
a long fretted neck and a resonating gourd. It is plucked by the index finger
of the left hand fitted with a plectrum made of wire. Sitars generally have 6
or 7 main playing strings which run above the frets, and an additional 12 or
more sympathetic strings which give the instrument a shimmering echo when
played. The frets herein are movable and can be adjusted according to the scale
selected to be played upon. The sitar is also called as satar and sundari.

=cut

