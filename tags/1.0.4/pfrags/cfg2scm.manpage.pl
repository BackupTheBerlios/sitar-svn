#
#	MANPAGE
#

=head1 NAME

CFG2SCM - Check configuration changes into SCM

=head1 SYNOPSIS

cfg2scm.pl B<--check-consistency> B<--storage>=I<svn|cvs|tar|tar.gz|tar.bz2> B<--outfile>=I<file> B<--base-url>=I<url> B<--repository>=I<name> B<--username>=I<username> B<--password>=I<password> B<--message>=I<commit message> B<--help> B<--version>

=head1 DESCRIPTION

Check configuration changes into SCM (like SVN, CVS, ... or tar file)

=head1 OPTIONS

=over

=item B<--storage>=I<svn|cvs|tar|tar.gz|tar.bz2>

type of storage, either "svn", "cvs", "tar", "tar.gz" or "tar.bz2"

=item B<--outfile>=I<file> 

This option only works with storage-types tar, tar.gz, tar.bz2.
The extension is set automatically, if not given.

=item B<--base-url>=I<url>

url

=item B<--repository>=I<name>

name

=item B<--username>=I<username>

username

=item B<--password>=I<password>

password

=item B<--message>=I<commit message>

commit message

=item B<--help>

Prints a short summary of options.

=item B<--version>

Prints the cfg2scm.pl version

=item B<--check-consistency>

This option checks the consistency of configurations-files as declared in the RPMs, by invoking I<rpm -Vca>. It produces a file I</var/lib/support/Configuration_Consistency.include>, which is preserved between different cfg2scm.pl-runs.  The list contains all names of configuration files, which are tagged as configuration files within the RPMs and were changed compared to the release shipped within the RPMs.  

The following standard cfg2scm.pl-run includes the file I</var/lib/support/Configuration_Consistency.include>, as described below (section FILES) and commits the full content of the changed files.

Please note, that this really might need a long time (from 5-20 minutes).

=item B<--find-unpacked>

Find files below /etc, that do not belong to any RPM, and for that reason should be documented.
A file /var/lib/support/Find_Unpacked.include is written as "cache".

=back

=head1 FILES file-lists in /var/lib/support/

From a tool called C<PaDS> by Thorsten Wandersmann cfg2scm.pl inherited the ability, to extend the list of configuration files. To achieve that, just put a perl-snippet in the directory C</var/lib/support/>; this snippet B<must> have the extension C<.include> and may include only one perl-statement: an array-declaration for the array C<@files>, that contains the file-names with full path, see EXAMPLES below.

See also B<--check-consistency> and B<--find-unpacked> above.

=head2 configuration files

cfg2scm is able to use a configuration file, currently: /etc/sysconfig/cfg2scm. On SUSE Linux systems, this file can be changed also using YaST's sysconfig-editor (System/Monitoring/cfg2scm). The parameters in this file directly correspond global variables in cfg2scm:

=over

=back

=head1 ERRORS

Enough:-|

=head1 DIAGNOSTICS

-

=head1 EXAMPLES

Check configuration files and commit everything.

C<cfg2scm.pl --check-consistency>

A typical file to include the configurations files of the application C<foobar> could look like this:

 # /var/lib/support/foobar.include
 
 @files= (
 	"/etc/opt/foobar/foo.conf",
 	"/etc/opt/foobar/bar.conf"
 	);

 # eof
 
=head1 AUTHOR

The CFG2SCM project was created by Matthias G. Eckermann <mge@suse.de>; many
thanks to Günther Deschner <gd@suse.de> and Manfred Hollstein <mh@novell.com>
for tips and code.

=head1 LICENSE

Copyright (C) 2005-2006 SuSE Linux, a Novell Business

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

=cut

