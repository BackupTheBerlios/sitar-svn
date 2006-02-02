#
# HEADER
#
# # <?xml-stylesheet type="text/css2" href="file:///xyz.css"?>
#
my $sdocbook_header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE article PUBLIC \"-//OASIS//DTD DocBook XML V4.1.2//EN\" \"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd\" [
  <!ENTITY nbsp \"&#x000A0;\" >
]>
<article class=\"techreport\" lang=\"en-US\">
<articleinfo>
  <corpauthor>SITAR $SITAR_RELEASE-$SITAR_SVNVERSION</corpauthor>
  <copyright>
    <year>1999</year>
    <year>2006</year>
    <holder>$SITAR_COPYHOLDER</holder>
  </copyright>
  <bibliomisc><ulink url=\"http://sitar.berlios.de/\">http://sitar.berlios.de/</ulink></bibliomisc>
  <title>$HOSTNAME</title>
  <date>$now_string_g</date>
  <subtitle>$DIST_RELEASE</subtitle>
</articleinfo>";
my $sdocbook_footer = "</article>";
my $html_header     = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"
  \"http://www.w3.org/TR/REC-html40/loose.dtd\">
<html>
  <head>
  <style type=\"text/css\" media=\"screen\">
  <!--
    body            { background: #ffffff; color: #000000; font-family: sans-serif; }
    table           { font-family: sans-serif; }
    p               { font-family: serif; text-align: justify; text-indent: 1em; }
    h1,h2,h3,h4,h5  { font-family: sans-serif }
    h1.noextraskip  { font-size: large; }
    h2.noextraskip  { font-size: medium; }
    h1              { font-size: large ; line-height: 200%; text-align: center; }
    h2              { font-size: medium; line-height: 150%; text-align: center; }
    h3              { font-size: medium; line-height: 120%; text-align: center; }
    pre             { font-family: sans-serif; text-indent: 0em; font-size: small; }
    table           { font-family: sans-serif; text-indent: 0em; font-size: normal; }
    table.small     { font-family: sans-serif; text-indent: 0em; font-size: small; }
    th              { font-family: sans-serif; text-indent: 0em; text-align: left; font-size: small; }
    td              { font-family: sans-serif; text-indent: 0em; text-align: left; font-size: small; }
    ul p            { text-indent: 0em; list-style: disc outside; text-align: left; margin-left: 0em; }
    ol p            { text-indent: 0em; }
    ul              { margin-left: 0em; list-style-type: disc outside; 
                      text-align: left ; text-indent: 0em; font-family: sans-serif; }
    ul.toc          { margin-left: 2.5em; list-style-type: none ;
                      text-align: left ; text-indent: 0em; font-family: sans-serif; }
    strong          { font-style: normal; font-weight: bold; }
    em              { font-style: italic; }
    address         { font-family: sans-serif; font-style: italic; }
    a:link          { color: #0000cc; text-decoration: underline; }
    a:visited       { color: #551a8b; text-decoration: underline; }
  -->
  </style>
    <title>$HOSTNAME, $now_string_g</title>
</head>
<body bgcolor=\"#FFFFFF\">
  <table summary=\"header\" border=\"0\" width=\"100%\">
    <tr>
      <td valign=\"bottom\"><h1>$HOSTNAME, $now_string_g</h1></td>
    </tr>
    <tr>
      <td valign=\"top\"><h2>$UNAME<br>$DIST_RELEASE</h2></td>
    </tr>
  </table>
  <hr>";
my $html_footer = "<hr />
<address>SITAR $SITAR_RELEASE-$SITAR_SVNVERSION is &copy; $SITAR_COPYRIGHT</address>
</html>\n";
#
# $tex_header
#
$UNAMET = $UNAME;
$UNAMET =~ s/\_/\\_/g;
$UNAMET =~ s/\#/\\\#/g;
my $tex_header = "%
% produced by SITAR (C) $SITAR_COPYRIGHT
%
% for standalone documents use:
%
\\documentclass[headinclude,a4paper,DIV20]\{scrartcl\} 
\\usepackage[latin1]\{inputenc\} 
\\usepackage\{hyperref\} 
\\usepackage\{longtable,verbatim,multicol\} 
\\pagestyle\{plain\} 
\\newcommand\{\\tm\}\{\\texttrademark\} 
% 
\\begin\{document\} 
%
\\title\{$HOSTNAME, $now_string_g \\\\
\{\\normalsize $UNAMET\\ $DIST_RELEASE\} \}
\\author\{$SITAR_RELEASE-$SITAR_SVNVERSION\}
\\maketitle
\\tableofcontents 
\\newpage
%
% for embedded documents you should use:
%
% \\usepackage[headinclude,a4paper]\{typearea\} 
% \\areaset\{40em\}\{50\\baselineskip\} 
% \\usepackage\{german\} 
% \\selectlanguage\{english\} 
% 
% \\section{$HOSTNAME, 
% 	$now_string_g \\\\ 
%	\{\\normalsize $UNAMET\\ $DIST_RELEASE\} \}}
% ( by $SITAR_RELEASE-$SITAR_SVNVERSION ) 
%
";
my $tex_footer     = "\n\\end\{document\}\n";
my $old_tex_footer = "\n
\\par\\noindent
\\textsf{SITAR is \\textcopyright{} $SITAR_COPYRIGHT}\\par
\\end\{document\}\n";
#
# Table of contents and output
#
my $toc_seccnt_g         = 0;
my $toc_subseccnt_g      = 0;
my $toc_subsubseccnt_g   = 0;
my $toc_last_toc_level_g = 0;
my $toc_last_sec_level_g = 0;
my $toc_buffer_g         = "";
my $output_is_verbatim_g = 0;
my $output_buffer_g      = "";

sub mysprint {
	$output_buffer_g = join "", $output_buffer_g, @_;
}

sub addtoc($$$) {
	my ( $level, $ancor, $value ) = @_;
	if ( $level > $toc_last_toc_level_g ) {
		$toc_buffer_g = join "", $toc_buffer_g, "<ul class=\"toc\">\n";
	} elsif ( $level < $toc_last_toc_level_g ) {
		for ( $ll = $toc_last_toc_level_g ; $ll > $level ; $ll-- ) {
			$toc_buffer_g = join "", $toc_buffer_g, "</li>\n</ul>\n\n";
		}
		$toc_buffer_g = join "", $toc_buffer_g, "</li>\n";
	} elsif ( $toc_last_toc_level_g != 0 ) {
		$toc_buffer_g = join "", $toc_buffer_g, "</li>\n";
	} else {
	}
	$toc_buffer_g = join "", $toc_buffer_g, "<li><a href=\"#", $ancor, "\">", $value, "</a>\n";
	$toc_last_toc_level_g = $level;
}

sub addtoc_sdocbook($$$) {
	my ( $level, $ancor, $value ) = @_;
	if ( $level > $toc_last_toc_level_g ) {
		$toc_buffer_g = join "", $toc_buffer_g, "<itemizedlist>\n";
	} elsif ( $level < $toc_last_toc_level_g ) {
		for ( $ll = $toc_last_toc_level_g ; $ll > $level ; $ll-- ) {
			$toc_buffer_g = join "", $toc_buffer_g, "</listitem>\n</itemizedlist>\n\n";
		}
		$toc_buffer_g = join "", $toc_buffer_g, "</listitem>\n";
	} elsif ( $toc_last_toc_level_g != 0 ) {
		$toc_buffer_g = join "", $toc_buffer_g, "</listitem>\n";
	} else {
	}
	$toc_buffer_g = join "", $toc_buffer_g, "<listitem><para><xref linkend=\"sec$ancor\"/>$value</para>\n";
	$toc_last_toc_level_g = $level;
}

sub siprint($$$$) {
	my ( $m, $value, $attr, $colsnum ) = @_;
	if ( $SITAR_OPT_FORMAT eq "html" ) {
		$value =~ s/\&/\&amp;/g;
		$value =~ s/</\&lt;/g;
		$value =~ s/>/\&gt;/g;
		if ( $m eq "h1" ) {
			$toc_seccnt_g++;
			mysprint "<h1><a name=\"", $toc_seccnt_g, "\"\n>", $toc_seccnt_g, ".&nbsp;", $value, "</a></h1>";
			addtoc( 1, "$toc_seccnt_g", "$toc_seccnt_g.&nbsp;$value" );
			$toc_subseccnt_g = 0;
		}
		if ( $m eq "h2" ) {
			$toc_subseccnt_g++;
			mysprint "<h2><a name=\"", $toc_seccnt_g, ".", $toc_subseccnt_g, "\"\n>", $toc_seccnt_g, ".", $toc_subseccnt_g, "&nbsp;", $value, "</a></h2>";
			addtoc( 2, "$toc_seccnt_g.$toc_subseccnt_g", "$toc_seccnt_g.$toc_subseccnt_g&nbsp;$value" );
			$toc_subsubseccnt_g = 0;
		}
		if ( $m eq "h3" ) {
			$toc_subsubseccnt_g++;
			mysprint "<h3><a name=\"", $toc_seccnt_g, ".", $toc_subseccnt_g, ".", $toc_subsubseccnt_g, "\"\n>", $toc_seccnt_g, ".", $toc_subseccnt_g, ".", $toc_subsubseccnt_g, "&nbsp;", $value, "</a></h3>";
			addtoc( 3, "$toc_seccnt_g.$toc_subseccnt_g.$toc_subsubseccnt_g", "$toc_seccnt_g.$toc_subseccnt_g.$toc_subsubseccnt_g&nbsp;$value" );
		}
		if ( $m eq "tabborder" ) {
			mysprint "<table summary=\"", $attr, "\"\n border=\"1\">";
		}
		if ( $m eq "tab" )         { mysprint "<table summary=\"\"\n border=\"0\">"; }
		if ( $m eq "endtab" )      { mysprint "</table>\n"; }
		if ( $m eq "tabrow" )      { mysprint "<tr\n>"; }
		if ( $m eq "endrow" )      { mysprint "</tr>\n"; }
		if ( $m eq "pre" )         { mysprint "<pre>"; $output_is_verbatim_g = 1; }
		if ( $m eq "endpre" )      { mysprint "</pre>\n"; $output_is_verbatim_g = 0; }
		if ( $m eq "multipre" )    { mysprint "<pre>"; $output_is_verbatim_g = 1; }
		if ( $m eq "endmultipre" ) { mysprint "</pre>\n"; $output_is_verbatim_g = 0; }
		if ( $m eq "cellspan" )    {
			mysprint "<td \nnowrap colspan=\"", $attr, "\">", $value, "</td>";
		}
		if ( $m eq "emptycell" ) { mysprint "<td>&nbsp;</td>"; }
		if ( $m eq "cell" )      { mysprint "<td \nnowrap>", $value, "</td>"; }
		if ( $m eq "cellwrap" )  { mysprint "<td>", $value, "</td>"; }
		if ( $m eq "cellcolor" ) {
			mysprint "<td bgcolor=\"", $attr, "\" \nnowrap>", $value, "</td>";
		}
		if ( $m eq "headcolor" ) {
			mysprint "<th bgcolor=\"", $attr, "\" \nnowrap>", $value, "</th>";
		}
		if ( $m eq "tabhead" ) { mysprint "<th \nnowrap>", $value, "</th>"; }
		if ( $m eq "verb" )    { mysprint $value; }
		if ( $m eq "header" )  { print $html_header; }
		if ( $m eq "toc" )     {
			for ( $ii = $toc_last_toc_level_g ; $ii > 0 ; $ii-- ) {
				$toc_buffer_g = join "", $toc_buffer_g, "</li>\n</ul>\n";
			}
			print "<h1>Table of Contents</h1>\n", $toc_buffer_g;
			print "\n<hr />\n";
		}
		if ( $m eq "body" )   { print $output_buffer_g; }
		if ( $m eq "footer" ) { print $html_footer; }
	} elsif ( $SITAR_OPT_FORMAT eq "tex" || $SITAR_OPT_FORMAT eq "latex" ) {
		if ( $output_is_verbatim_g == 0 ) {
			$value =~ s/\_/\\_/g;
			$value =~ s/\#/\\\#/g;
			$value =~ s/%/\\%/g;
			$value =~ s/\&/\\\&/g;
			$value =~ s/</\$<\$/g;
			$value =~ s/>/\$>\$/g;
		}
		## s/(\")(\w)/\"\`$2/g; s/(\w)(\")/$1\"\'/g; s/([.,;?!])(\")/$1\"\'/g;
		if ( $m eq "h1" ) { print "\\section\{",       $value, "\}\n"; }
		if ( $m eq "h2" ) { print "\\subsection\{",    $value, "\}\n"; }
		if ( $m eq "h3" ) { print "\\subsubsection\{", $value, "\}\n"; }
		if ( $m eq "tabborder" ) {
			print "\\begingroup\\tiny\\par", "\\noindent\\begin\{longtable\}[l]\{\@\{\}", $value, "l\@\{\}\}\n";
		}
		if ( $m eq "tab" ) {
			print "\\begingroup\\tiny\\par", "\\noindent\\begin\{longtable\}[l]\{\@\{\}", $value, "l\@\{\}\}\n";
		}
		if ( $m eq "endtab" )   { print "\\end\{longtable\}\\par\\endgroup\n"; }
		if ( $m eq "tabrow" )   { }
		if ( $m eq "endrow" )   { print "\\\\\n"; }
		if ( $m eq "pre" )      { print "\\begin\{verbatim\}"; $output_is_verbatim_g = 1; }
		if ( $m eq "endpre" )   { print "\\end\{verbatim\}\n"; $output_is_verbatim_g = 0; }
		if ( $m eq "multipre" ) {
			print "\n\\par\\begingroup\\tiny\\par\n";
			print "\\begin\{multicols\}\{2\}\n\\begin\{verbatim\}\n";
			$output_is_verbatim_g = 1;
		}
		if ( $m eq "endmultipre" ) {
			print "\\end\{verbatim\}\n";
			print "\\end\{multicols\}\\par\\endgroup\\par\n";
			$output_is_verbatim_g = 0;
		}
		if ( $m eq "cellspan" ) { print $value, "\&"; }
		if ( $m eq "emptycell" ) { print "\&"; }
		if ( $m eq "cell" )      { print $value, "\&"; }
		if ( $m eq "cellwrap" )  { print $value, "\&"; }
		if ( $m eq "cellcolor" ) { print $value, "\&"; }
		if ( $m eq "headcolor" ) { print $value, "\&"; }
		if ( $m eq "tabhead" )   { print $value, "\&"; }
		if ( $m eq "verb" )      { print $value; }
		if ( $m eq "header" )    { print $tex_header; }
		if ( $m eq "footer" )    { print $tex_footer; }
	} elsif ( $SITAR_OPT_FORMAT eq "sdocbook" ) {
		$value =~ s/\&/\&amp;/g;
		$value =~ s/</\&lt;/g;
		$value =~ s/>/\&gt;/g;
		$attr  =~ s/\&/\&amp;/g;
		$attr  =~ s/</\&lt;/g;
		$attr  =~ s/>/\&gt;/g;
		if ( $m eq "h1" ) {
			while ( $toc_last_sec_level_g > 0 ) {
				mysprint "\n</section>\n";
				$toc_last_sec_level_g--;
			}
			$toc_seccnt_g++;
			mysprint "<section label=\"sec", $toc_seccnt_g, "\" id=\"sec", $toc_seccnt_g, "\"\n><title>", $value, "</title><para />\n";
			addtoc_sdocbook( 1, "$toc_seccnt_g", "$toc_seccnt_g.$value" );
			$toc_subseccnt_g      = 0;
			$toc_last_sec_level_g = 1;
		}
		if ( $m eq "h2" ) {
			while ( $toc_last_sec_level_g > 1 ) {
				mysprint "\n</section>\n";
				$toc_last_sec_level_g--;
			}
			$toc_subseccnt_g++;
			mysprint "<section label=\"sec", $toc_seccnt_g, ".", $toc_subseccnt_g, "\" id=\"sec", $toc_seccnt_g, ".", $toc_subseccnt_g, "\"\n><title>", $value, "</title><para />\n";
			addtoc_sdocbook( 2, "$toc_seccnt_g.$toc_subseccnt_g", "$toc_seccnt_g.$toc_subseccnt_g&nbsp;$value" );
			$toc_subsubseccnt_g   = 0;
			$toc_last_sec_level_g = 2;
		}
		if ( $m eq "h3" ) {
			if ( $toc_last_sec_level_g > 2 ) {
				mysprint "\n</section>\n";
			}
			$toc_subsubseccnt_g++;
			mysprint "<section label=\"sec", $toc_seccnt_g, ".", $toc_subseccnt_g, ".", $toc_subsubseccnt_g, "\" id=\"sec", $toc_seccnt_g, ".", $toc_subseccnt_g, ".", $toc_subsubseccnt_g, "\"\n><title>", $value, "</title><para />\n";
			addtoc_sdocbook( 3, "$toc_seccnt_g.$toc_subseccnt_g.$toc_subsubseccnt_g", "$toc_seccnt_g.$toc_subseccnt_g.$toc_subsubseccnt_g&nbsp;$value" );
			$toc_last_sec_level_g = 3;
		}
		if ( $m eq "tabborder" ) {
			mysprint "<table frame=\"all\"><title>", $attr, "</title><tgroup cols=\"", $colsnum, "\"><tbody>";
		}
		if ( $m eq "tab" ) { mysprint "<table frame=\"none\"><title></title><tgroup cols=\"", $colsnum, "\"><tbody>"; }
		if ( $m eq "endtab" )    { mysprint "</tbody></tgroup></table>\n"; }
		if ( $m eq "tabrow" )    { mysprint "<row\n>"; }
		if ( $m eq "endrow" )    { mysprint "</row>\n"; }
		if ( $m eq "emptycell" ) { mysprint "<entry>&nbsp;</entry>"; }
		if ( $m eq "cell" )      { mysprint "<entry>", $value, "</entry>"; }
		if ( $m eq "cellwrap" )  { mysprint "<entry><para>", $value, "</para></entry>"; }
		if ( $m eq "cellspan" )  { mysprint "<entry namest=\"c1\" nameend=\"c", $attr, "\">", $value, "</entry>"; }
		if ( $m eq "cellcolor" ) { mysprint "<entry>", $value, "</entry>"; }
		if ( $m eq "headcolor" ) { mysprint "<entry>", $value, "</entry>"; }
		if ( $m eq "tabhead" )   { mysprint "<entry>", $value, "</entry>"; }
		if ( $m eq "pre" )       {
			mysprint "<programlisting>\n<![CDATA[\n";
			$output_is_verbatim_g = 1;
		}
		if ( $m eq "endpre" ) {
			mysprint "\n]]>\n</programlisting>\n";
			$output_is_verbatim_g = 0;
		}
		if ( $m eq "multipre" ) {
			mysprint "<programlisting>\n<![CDATA[\n";
			$output_is_verbatim_g = 1;
		}
		if ( $m eq "endmultipre" ) {
			mysprint "\n]]>\n</programlisting>\n";
			$output_is_verbatim_g = 0;
		}
		if ( $m eq "verb" )   { mysprint $value; }
		if ( $m eq "header" ) { print $sdocbook_header; }
		if ( $m eq "body" )   {
			while ( $toc_last_sec_level_g > 0 ) {
				mysprint "\n</section>\n";
				$toc_last_sec_level_g--;
			}
			print $output_buffer_g;
		}
		if ( $m eq "footer" ) { print $sdocbook_footer; }
		if ( $m eq "toc" )    {
			for ( $ii = $toc_last_toc_level_g ; $ii > 0 ; $ii-- ) {
				$toc_buffer_g = join "", $toc_buffer_g, "</listitem>\n</itemizedlist>\n";
			}
			print "<section id=\"TOC\" label=\"TOC\"><title>Table of Contents</title><para />\n", $toc_buffer_g, "</section>\n";
		}
	} elsif ( $SITAR_OPT_FORMAT eq "sql" ) {
	}
}
sub siprt($) { my ( $t1 ) = shift( @_ ); siprint( $t1, "", "", 0 ); }
sub siprtt($$) { my ( $t1, $t2 ) = @_; siprint( $t1, $t2, "", 0 ); }
sub siprttt($$$) { my ( $t1, $t2, $t3 ) = @_; siprint( $t1, $t2, $t3, 0 ); }
sub siprtttt($$$$) { my ( $t1, $t2, $t3, $t4 ) = @_; siprint( $t1, $t2, $t3, $t4 ); }
#
# si_now_gmt()
#
sub si_now_gmt() {
	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = gmtime( time );
	$year += 1900;
	$mon  = sprintf( "%02d", $mon );
	$mday = sprintf( "%02d", $mday );
	$hour = sprintf( "%02d", $hour );
	$gmt  = "gmt";
	return "$year$mon$mday$hour$gmt";
}
#
# si_debug( text );
#
sub si_debug($) {
	my ( $text ) = @_;
	if ( $SITAR_OPT_DEBUG ) {
		print $text, "\n";
	}
}
#
# read config file
#
sub si_set_on_find($$$) {
	my ( $line, $parm, $VAR ) = @_;
	if ( $line =~ /$parm/ ) {
		my ( $dummy, $FOUND_VAR ) = split( /.*=\s*/, $line );
		$FOUND_VAR =~ s/^\"//;
		$FOUND_VAR =~ s/\"$//;
		return $FOUND_VAR;
	}
	return $VAR;
}

sub si_parse_conf_file($) {
	my $fname = shift;
	my $dummy;
	if ( -r $fname ) {
		open( CONFIG_DATA, "$fname" ) || die "could not open \"$fname\": $!";
		while ( my $line = <CONFIG_DATA> ) {
			next if $line =~ /^#|^$/;
			chomp( $line );
			$SITAR_OPT_FORMAT         = si_set_on_find( $line, "SITAR_OPT_FORMAT",         $SITAR_OPT_FORMAT );
			$SITAR_OPT_OUTDIR         = si_set_on_find( $line, "SITAR_OPT_OUTDIR",         $SITAR_OPT_OUTDIR );
			$SITAR_OPT_OUTFILE        = si_set_on_find( $line, "SITAR_OPT_OUTFILE",        $SITAR_OPT_OUTFILE );
			$SITAR_OPT_LIMIT          = si_set_on_find( $line, "SITAR_OPT_LIMIT",          $SITAR_OPT_LIMIT );
			$SITAR_OPT_GCONF          = si_set_on_find( $line, "SITAR_OPT_GCONF",          $SITAR_OPT_GCONF );
			$SITAR_OPT_ALLCONFIGFILES = si_set_on_find( $line, "SITAR_OPT_ALLCONFIGFILES", $SITAR_OPT_ALLCONFIGFILES );
			$SITAR_OPT_ALLSUBDOMAIN   = si_set_on_find( $line, "SITAR_OPT_ALLSUBDOMAIN",   $SITAR_OPT_ALLSUBDOMAIN );
			$SITAR_OPT_ALLSYSCONFIG   = si_set_on_find( $line, "SITAR_OPT_ALLSYSCONFIG",   $SITAR_OPT_ALLSYSCONFIG );
			$SITAR_OPT_LVMARCHIVE     = si_set_on_find( $line, "SITAR_OPT_LVMARCHIVE",     $SITAR_OPT_LVMARCHIVE );
		}
		close( CONFIG_DATA );
	}
}
#
#
#
sub si_cpuinfo() {
	siprtt( "h1", "CPU" );
	siprtttt( "tabborder", "ll", "CPU", 2 );
	open( IN, "/proc/cpuinfo" );
	if ( $UNAMEM eq "alpha" ) {
		while ( <IN> ) {
			my ( $proc, $value ) = split /:/;
			chop( $proc );
			chop( $value );
			if ( $proc eq "cpus detected" ) {
				siprt( "tabrow" );
				siprttt( "headcolor", "cpus detected", "\#CCCCCC" );
				siprttt( "cellcolor", $value, "\#CCCCCC" );
				siprt( "endrow" );
			} else {
				siprt( "tabrow" );
				siprtt( "tabhead", $proc );
				siprtt( "cell",    $value );
				siprt( "endrow" );
			}
		}
	} else {
		while ( <IN> ) {
			if ( m/^(processor)/gi ) {
				# m/(\d+)/gs;
				my ( $proc, $value ) = split /:/;
				siprt( "tabrow" );
				siprttt( "headcolor", "Processor", "\#CCCCCC" );
				siprttt( "cellcolor", $value, "\#CCCCCC" );
				siprt( "endrow" );
			}
			if ( m/^(cpu MHz)|^(model name)|^(vendor_id)|^(cache size)|^(stepping)|^(cpu family)|^(model)/i ) {
				m/^(.*):(.*)$/gsi;
				my $tt1 = $1;
				chop( my $tt2 = $2 );
				siprt( "tabrow" );
				siprtt( "tabhead", $tt1 );
				siprtt( "cell",    $tt2 );
				siprt( "endrow" );
			}
		}
	}
	close( IN );
	siprt( "endtab" );
}

sub si_general_sys() {
	siprtt( "h1", "General Information" );
	siprtttt( "tabborder", "ll", "General Information", 2 );
	siprt( "tabrow" );
	siprtt( "cell", "Hostname" );
	siprtt( "cell", $HOSTNAME );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "Operating System" );
	siprtt( "cell", $DIST_RELEASE );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "UName" );
	siprtt( "cell", $UNAME );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "Date" );
	siprtt( "cell", $now_string_g );
	siprt( "endrow" );
	open( IN, "/proc/meminfo" );
	while ( <IN> ) {
		if ( m/MemTotal/g ) {
			m/(\d+)/gs;
			siprt( "tabrow" );
			siprtt( "cell", "Main Memory" );
			siprtt( "cell", "$1 KByte" );
			siprt( "endrow" );
		}
	}
	close( IN );
	open( IN, "/proc/cmdline" );
	while ( <IN> ) {
		chomp $_;
		siprt( "tabrow" );
		siprtt( "cell", "Cmdline" );
		siprtt( "cell", "$_" );
		siprt( "endrow" );
	}
	close( IN );
	open( IN, "/proc/loadavg" );
	while ( <IN> ) {
		chomp $_;
		siprt( "tabrow" );
		siprtt( "cell", "Load" );
		siprtt( "cell", "$_" );
		siprt( "endrow" );
	}
	close( IN );
	open( IN, "/proc/uptime" );
	while ( <IN> ) {
		( $uptime,  $idletime ) = split / /,  $_,        2;
		( $upmin,   $rest )     = split /\./, $uptime,   2;
		( $idlemin, $rest )     = split /\./, $idletime, 2;
		siprt( "tabrow" );
		siprtt( "cell", "Uptime (minutes hours days)" );
		siprtt( "cell", int( $upmin / 60 ) . " " . int( $upmin / 3600 ) . " " . int( $upmin / 87400 ) );
		siprt( "endrow" );
		siprt( "tabrow" );
		siprtt( "cell", "Idletime (minutes hours days)" );
		siprtt( "cell", int( $idlemin / 60 ) . " " . int( $idlemin / 3600 ) . " " . int( $idlemin / 87400 ) );
		siprt( "endrow" );
	}
	close( IN );
	siprt( "endtab" );
}

sub si_proc_kernel() {
	siprtt( "h1", "Kernel" );
	siprtttt( "tabborder", "ll", "Kernel", 2 );
	for $NN ( sort `$CMD_FIND /proc/sys/kernel/ -type f` ) {
		chomp $NN;
		$value = `$CMD_CAT $NN`;
		if ( $value ne "" ) {
			my $MM = $NN;
			$MM =~ s/\/proc\/sys\/kernel\///;
			$OO = $MM;
			$OO =~ s/(\w+\/)*(\w+)$/$+/;
			chomp $OO;
			siprt( "tabrow" );
			siprtt( "cell", $MM );
			siprtt( "cell", $value );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
}

sub si_software_raid() {
	my $MDSTAT  = "/proc/mdstat";
	my $RAIDTAB = "/etc/raidtab";
	chomp( $UNAMER );
	if (       ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.4.*/ )
		|| ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.6.*/ ) ) {
		siprtt( "h1", "Software RAID" );
		siprtt( "h2", "Configuration" );
		si_conf( $MDSTAT, $MDSTAT, "" );
		if ( -r $RAIDTAB ) {
			si_conf( $RAIDTAB, $RAIDTAB, "" );
		}
	}
}

sub si_software_raid_details() {
	my $MDSTAT  = "/proc/mdstat";
	my $RAIDTAB = "/etc/raidtab";
	if ( -r $MDSTAT ) {
		siprtt( "h2", "Details" );
		siprtttt( "tabborder", "llllll", "Software RAID", 6 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Raid-Device" );
		siprtt( "tabhead", "Raid-Level" );
		siprtt( "tabhead", "Raid-Partitions" );
		siprtt( "tabhead", "Blocks" );
		siprtt( "tabhead", "Chunks" );
		siprtt( "tabhead", "Algorithm" );
		siprt( "endrow" );
		open( IN1, "</proc/mdstat" ) || return ();
		chomp( $UNAMER );
		my ( $counter1, $counter2 ) = 0;
		if (       ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.4.*/ )
			|| ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\.6.*/ ) ) {
			#CODE for kernel-2.4 software-raid
			while ( <IN1> ) {
				$counter1++;
				$counter2 = 0;
				if ( m/^(md\d+)\s:\sactive\s(raid\d)\s(.*)$/g ) {
					my $raiddev    = $1;
					my $level      = $2;
					my %md         = ();
					my @partitions = split( ' ', $3 );
					$md{ level }      = $level;
					$md{ partitions } = "@partitions";
					open( IN2, "</tmp/mdstat" ) || last;
					while ( <IN2> ) {
						$counter2++;
						my $counter1plus1 = 0;
						$counter1plus1 = ( $counter1 + 1 );
						if ( $counter2 == $counter1plus1 ) {
							my @md_options = split( ' ', $_ );
							if ( $level eq 'raid0' ) {
								$md{ blocks }    = $md_options[ 0 ];
								$md{ chunks }    = $md_options[ 2 ];
								$md{ algorithm } = " ";
							}
							if ( $level eq 'raid1' ) {
								$md{ blocks }    = $md_options[ 0 ];
								$md{ chunks }    = " ";
								$md{ algorithm } = " ";
							}
							if ( $level eq 'raid5' ) {
								$md{ blocks }    = $md_options[ 0 ];
								$md{ chunks }    = $md_options[ 4 ];
								$md{ algorithm } = $md_options[ 7 ];
							}
						}
					}
					close( IN2 );
					#hier der code zur html-ausgabe
					siprt( "tabrow" );
					siprtt( "cell", $raiddev );
					siprtt( "cell", $md{ level } );
					siprtt( "cell", @md{ partitions } );
					siprtt( "cell", $md{ blocks } );
					siprtt( "cell", $md{ chunks } );
					siprtt( "cell", $md{ algorithm } );
					siprt( "endrow" );
					unless ( -e ( ( $RAIDTAB ) || ( "/etc/raid0.conf" ) || ( "/etc/raid1.conf" ) || ( "/etc/raid5.conf" ) ) ) {
						siprtt( "h4", "There seems to be no /etc/raidtab or similar.\n" );
					}
				}
			}
			} elsif ( ( -r $MDSTAT ) && ( $UNAMER =~ m/^2\..*/ ) ) {
			#CODE for kernel-2.2 software-raid
			while ( <IN1> ) {
				$counter1++;
				$counter2 = 0;
				if ( m/^(md\d+)\s:\sactive\s(raid\d)\s([h|s].*)\s(\d+)\s(block.*)$/g ) {
					my $raiddev    = $1;
					my $level      = $2;
					my %md         = ();
					my @partitions = split( ' ', $3 );
					$md{ level }      = $level;
					$md{ partitions } = "@partitions";
					$md{ blocks }     = $4;
					$md{ chunks }     = "";
					$md{ algorithm }  = "";
					if ( $5 =~ m/^blocks\s\w+\s\d,\s(\d+k)\s\w+,\s\w+\s(\d+)\s.*$/g ) {
						$md{ chunks }    = $1;
						$md{ algorithm } = $2;
					} elsif ( $5 =~ m/^blocks\s(\d+k)\s.*$/g ) {
						$md{ chunks }    = $1;
						$md{ algorithm } = " ";
					}
					siprt( "tabrow" );
					siprtt( "cell", $raiddev );
					siprtt( "cell", $md{ level } );
					siprtt( "cell", @md{ partitions } );
					siprtt( "cell", $md{ blocks } );
					siprtt( "cell", $md{ chunks } );
					siprtt( "cell", $md{ algorithm } );
					siprt( "endrow" );
					unless ( -e ( ( $RAIDTAB ) || ( "/etc/raid0.conf" ) || ( "/etc/raid1.conf" ) || ( "/etc/raid5.conf" ) ) ) {
						siprtt( "h4", "There seems to be no /etc/raidtab or similar.\n" );
					}
				}
			}
		}
		siprt( "endtab" );
		unlink "/tmp/mdstat";
		close( IN1 );
	}
}

sub si_pnp() {
	if ( ( -x "$CMD_LSPNP" ) && ( -r "/proc/bus/pnp" ) ) {
		open( IN, "$CMD_LSPNP | " );
		siprtt( "h2", "PNP Devices" );
		siprtttt( "tabborder", "lll", "PNP Devices", 3 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Node Number" );
		siprtt( "tabhead", "Product Ident." );
		siprtt( "tabhead", "Description" );
		siprt( "endrow" );
		my @attr;
		while ( <IN> ) {
			@attr = split /\s+/, $_, 3;
			siprt( "tabrow" );
			siprtt( "cell", $attr[ 0 ] );
			siprtt( "cell", $attr[ 1 ] );
			siprtt( "cell", $attr[ 2 ] );
			siprt( "endrow" );
		}
		siprt( "endtab" );
		close( IN );
	}
}

sub si_proc_modules () {
	if ( -r "/proc/modules" ) {
		siprtt( "h2", "Kernel Modules" );
		siprtttt( "tabborder", "llll", "Kernel Modules", 4 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Module" );
		siprtt( "tabhead", "Use Count" );
		siprtt( "tabhead", "Referring Modules" );
		siprtt( "tabhead", "Needs/Uses" );
		siprt( "endrow" );
		my @attr;
		open( IN, "/proc/modules" );
		while ( <IN> ) {
			@attr = split /\s+/, $_, 4;
			siprt( "tabrow" );
			siprtt( "cell", $attr[ 0 ] );
			siprtt( "cell", $attr[ 1 ] );
			siprtt( "cell", $attr[ 2 ] );
			siprtt( "cell", $attr[ 3 ] );
			siprt( "endrow" );
		}
		close( IN );
		siprt( "endtab" );
	}
}

sub si_pci() {
	if ( -e "/proc/pci" ) {
		open( IN, "/proc/pci" );
		siprtt( "h2", "PCI Devices" );
		siprtttt( "tabborder", "lllll", "PCI Devices", 5 );
		siprt( "tabrow" );
		siprtt( "tabhead", "Type" );
		siprtt( "tabhead", "Vendor/Name" );
		siprtt( "tabhead", "Bus" );
		siprtt( "tabhead", "Device" );
		siprtt( "tabhead", "Function" );
		siprt( "endrow" );
		my @attr;
		while ( <IN> ) {
			if ( m/:$/g ) {
				# s/^\s+Bus\s+(\d+),\s+device\s+(\d+),\s+function\s+(\d+):$/$1:$2:$3/gx;
				m/^\s+Bus\s+(\d+),\s+device\s+(\d+),\s+function\s+(\d+)/;
				@attr = ( $1, $2, $3 );
			} elsif ( m/:/g ) {
				m/^(.*):(.*)/;
				siprt( "tabrow" );
				siprtt( "cell", $1 );
				siprtt( "cell", $2 );
				siprtt( "cell", $attr[ 0 ] );
				siprtt( "cell", $attr[ 1 ] );
				siprtt( "cell", $attr[ 2 ] );
				siprt( "endrow" );
			}
		}
		siprt( "endtab" );
		close( IN );
	} elsif ( -x "$CMD_LSHAL" ) {
		push @lines, $_;
		siprtt( "h2", "Hardware Abstraction Layer (HAL)" );
		siprt( "pre" );
		open( CONFIG, "$CMD_LSHAL --long |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
	} elsif ( -x "$CMD_LSPCI" ) {
		siprtt( "h2", "PCI Devices" );
		siprtttt( "tabborder", "lp{0.15\\textwidth}p{0.15\\textwidth}p{0.15\\textwidth}p{0.15\\textwidth}p{0.15\\textwidth}l", "PCI Devices", 7 );
		siprt( "tabrow" );
		for $TT qw ( PCI Device Class Vendor SVendor SDevice Rev ) {
			siprtt( "tabhead", $TT );
		}
		siprt( "endrow" );
		my %lspcidevices_h = {};
		my $MyDevice       = "";
		my $takenew        = 1;
		open( LSPCI, "$CMD_LSPCI -vm | " );
		while ( <LSPCI> ) {
			if ( $_ eq "\n" ) {
				$takenew = 1;
			} else {
				( $KK, $VV ) = split /:/, $_, 2;
				chomp $KK;
				chomp $VV;
				if ( ( $KK eq "Device" ) && ( $takenew == 1 ) ) {
					# begin new record
					$MyDevice                               = $VV;
					$lspcidevices_h{ "$MyDevice" }          = ();
					$lspcidevices_h{ "$MyDevice" }{ "PCI" } = $VV;
					$takenew                                = 0;
				} else {
					# add to record
					$lspcidevices_h{ "$MyDevice" }{ "$KK" } = $VV;
				}
			}
		}
		close LSPCI;
		foreach $NN ( sort keys %lspcidevices_h ) {
			siprt( "tabrow" );
			for $TT qw ( PCI Device Class Vendor SVendor SDevice Rev ) {
				$tt = $lspcidevices_h{ "$NN" }{ "$TT" };
				chomp $tt;
				if ( $tt eq "" ) {
					siprtt( "cell", "" );
				} else {
					my $ttt = $lspcidevices_h{ "$NN" }{ "$TT" };
					chomp $ttt;
					siprtt( "cell", $ttt );
				}
			}
			siprt( "endrow" );
		}
		siprt( "endtab" );
	}
}

sub si_lsdev() {
	#	lsdev.pl
	#	Created by Sander van Malssen <svm@ava.kozmix.cistron.nl>
	#	Date:        1996-01-22 19:06:22
	#	Last Change: 1998-05-31 15:26:58
	my %device_h = ();
	use vars qw($device_h @line $line @tmp $tmp0 $name %port $abc $hddev);
	my %dma = ();
	my %irq = ();
	open( IRQ, "/proc/interrupts" ) || return ();
	while ( <IRQ> ) {
		next if /^[ \t]*[A-Z]/;
		chop;
		my $n;
		if ( /PIC/ ) {
			$n = ( @line = split() );
		} else {
			$n = ( @line = split( ' [ +] ' ) );
		}
		my $name = $line[ $n - 1 ];
		$device_h{ $name } = $name;
		@tmp          = split( ':', $line[ 0 ] );
		$tmp0         = int( $tmp[ 0 ] );
		$irq{ $name } = "$irq{$name} $tmp0";
	}
	close( IRQ );
	open( DMA, "/proc/dma" ) || return ();
	while ( <DMA> ) {
		chop;
		@line = split( ': ' );
		if ( $DIST_DISTRIBUTION eq "redhat" ) {
			$name = $line[ 1 ];
		} else {
			@tmp = split( /[ \(]/, $line[ 1 ] );
			$name = $tmp[ 0 ];
		}
		$device_h{ $name } = $name;
		$dma{ $name }      = "$dma{$name}$line[0]";
	}
	close( DMA );
	open( IOPORTS, "</proc/ioports" ) || return ();
	while ( <IOPORTS> ) {
		chop;
		@line = split( ' : ' );
		if ( $DIST_DISTRIBUTION eq "redhat" ) {
			$name = $line[ 1 ];
		} else {
			@tmp = split( /[ \(]/, $line[ 1 ] );
			$name = $tmp[ 0 ];
		}
		$device_h{ $name } = $name;
		$port{ $name }     = "$port{$name} $line[0]";
	}
	close( IOPORTS );
	siprtt( "h1", "Devices" );
	siprtttt( "tabborder", "llll", "Devices", 4 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Device" );
	siprtt( "tabhead", "DMA" );
	siprtt( "tabhead", "IRQ" );
	siprtt( "tabhead", "I/O Ports" );
	siprt( "endrow" );
	foreach $name ( sort { uc( $a ) cmp uc( $b ) } keys %device_h ) {
		siprt( "tabrow" );
		siprtt( "cell", $name );
		siprtt( "cell", $dma{ $name } );
		siprtt( "cell", $irq{ $name } );
		siprtt( "cell", $port{ $name } );
		siprt( "endrow" );
	}
	siprt( "endtab" );
}

sub si_ide() {
	my $exists_ide = 0;
	for $abc ( "a" .. "i" ) {
		if ( -r "/proc/ide/hd$abc" ) { $exists_ide = 1; }
	}
	if ( $exists_ide ) {
		if ( $UNAMER lt "2.1.0" ) {
			siprtt( "h1", "IDE-Analysis: Kernel-Release $UNAMER not supported, sorry :-(\n" );
		} else {
			siprtt( "h1", "IDE" );
			siprtttt( "tabborder", "lllllllll", "IDE", 9 );
			siprt( "tabrow" );
			siprtt( "tabhead", "Device" );
			siprtt( "tabhead", "Type" );
			siprtt( "tabhead", "Model" );
			siprtt( "tabhead", "Driver" );
			siprtt( "tabhead", "Geo., phys." );
			siprtt( "tabhead", "Geo., log." );
			siprtt( "tabhead", "Size(blks)" );
			siprtt( "tabhead", "Firmware" );
			siprtt( "tabhead", "Serial" );
			siprt( "endrow" );
			for $abc ( "a" .. "d" ) {
				if ( -r "/proc/ide/hd$abc" ) {
					$hddev = "/dev/hd$abc";
					chomp( $media  = `$CMD_CAT /proc/ide/hd${abc}/media` );
					chomp( $driver = `$CMD_CAT /proc/ide/hd${abc}/driver` );
					chomp( $model  = `$CMD_CAT /proc/ide/hd${abc}/model` );
					siprt( "tabrow" );
					siprtt( "cell", "/dev/hd$abc" );
					siprtt( "cell", $media );
					siprtt( "cell", $model );
					siprtt( "cell", $driver );
					if ( $media eq "disk" ) {
						# $capa   = `$CMD_CAT /proc/ide/hd${abc}/capacity`;
						# $cache  = `$CMD_CAT /proc/ide/hd${abc}/cache`;
						open( GEO, "/proc/ide/hd${abc}/geometry " );
						while ( <GEO> ) {
							if ( m/^logical/g ) {
								s/^logical\s+(.*)$/$1/gs;
								$geol = $_;
							}
							if ( m/^physical/g ) {
								s/^physical\s+(.*)$/$1/gs;
								$geop = $_;
							}
						}
						close( GEO );
						siprtt( "cell", $geop );
						siprtt( "cell", $geol );
						siprtt( "cell", $capa );
						# siprtt("cell",$fw_rev);
						# siprtt("cell",$serial)
						siprtt( "cell", "-" );
						siprtt( "cell", "-" );
					} else {
						siprttt( "headcol", "", "5" );
					}
					siprt( "endrow" );
				}
			}
			siprt( "endtab" );
		}
	}
}

sub si_dac960() {
	if ( -r "/proc/rd" ) {
		siprtt( "h1", "Mylex ('DAC 960') RAID" );
		for ( $i = 0 ; $i < 8 ; $i++ ) {
			if ( -r "/proc/rd/c$i" ) {
				siprtt( "h2", "Controller $i" );
				open( MYLEX, "/proc/rd/c$i/initial_status" );
				siprtttt( "tabborder", "lllllll", "Mylex ('DAC 960') RAID Controller $i", 7 );
				my $status;
				my %physicals = ();
				my $onephysical;
				my $first = 1;
				my $open  = 0;
				while ( <MYLEX> ) {
					# print $_;
					if ( m/^Configuring/ ) {
						$status = "config";
					} elsif ( $status eq "config" && m/^\s\sPhysical/ ) {
						siprt( "endtab" );
						$status = "physical";
						siprtttt( "tabborder", "lllllll", "physical", 7 );
						siprt( "tabrow" );
						siprtt( "tabhead", "id:lun" );
						siprtt( "tabhead", "Vendor" );
						siprtt( "tabhead", "Model" );
						siprtt( "tabhead", "Revision" );
						siprtt( "tabhead", "Serial" );
						siprtt( "tabhead", "Status" );
						siprtt( "tabhead", "Size" );
						siprt( "endrow" );
					} elsif ( $status eq "physical" && m/^\s\sLogical/ ) {
						siprt( "endrow" );
						siprt( "endtab" );
						$status = "logical";
						siprtttt( "tabborder", "lllll", "logical", 5 );
						siprt( "tabrow" );
						siprtt( "tabhead", "Device" );
						siprtt( "tabhead", "Raid-Level" );
						siprtt( "tabhead", "Status" );
						siprtt( "tabhead", "Size" );
						siprtt( "tabhead", "Options" );
						siprt( "endrow" );
					} elsif ( $status eq "config" && m/^\s\s\w/ ) {
						chomp( @fs = split /:|,/ );
						if ( $fs[ 1 ] ne "" ) {
							siprt( "tabrow" );
							siprtt( "tabhead", $fs[ 0 ] );
							siprtt( "cell",    $fs[ 1 ] );
							siprt( "endrow" );
						}
						if ( $fs[ 3 ] ne "" ) {
							siprt( "tabrow" );
							siprtt( "tabhead", $fs[ 2 ] );
							siprtt( "cell",    $fs[ 3 ] );
							siprt( "endrow" );
						}
						if ( $fs[ 5 ] ne "" ) {
							siprt( "tabrow" );
							siprtt( "tabhead", $fs[ 4 ] );
							siprtt( "cell",    $fs[ 5 ] );
							siprt( "endrow" );
						}
					} elsif ( $status eq "physical" && m/Vendor/ ) {
						chomp;
						m/^\s+(\w+):(\w+)\s+Vendor:(.*)Model:(.*)Revision:(.*)$/gs;
						if ( $first ) { $first = 0; }
						else { siprt( "endrow" ); }
						siprt( "tabrow" );
						siprtt( "cell", "$1:$2" );
						siprtt( "cell", $3 );
						siprtt( "cell", $4 );
						siprtt( "cell", $5 );
					} elsif ( $status eq "physical" && m/Serial/ ) {
						chomp( my ( $ttt, $serial ) = split /:|,/ );
						siprtt( "cell", $serial );
					} elsif ( $status eq "physical" && m/Disk/ ) {
						chomp( my ( $ttt, $state, $blocks ) = split /:|,/ );
						siprtt( "cell", $state );
						siprtt( "cell", $blocks );
					} elsif ( $status eq "logical" ) {
						chomp( my ( $dev, $raid, $state, $blocks, $opt ) = split /:|,/ );
						siprt( "tabrow" );
						siprtt( "cell", $dev );
						siprtt( "cell", $raid );
						siprtt( "cell", $state );
						siprtt( "cell", $blocks );
						siprtt( "cell", $opt );
						siprt( "endrow" );
					}
				}
				siprt( "endtab" );
				close( MYLEX );
			}
		}
	}
}

sub si_compaq_smart() {
	my $cparray = "/proc/array";
	if ( -r $cparray ) {
		siprtt( "h1", "COMPAQ Smart Array" );
		for ( $i = 0 ; $i < 10 ; $i++ ) {
			my $cpa_mode = 1;
			if ( -r "$cparray/ida$i" ) {
				siprtt( "h2", "Controller $i" );
				siprtttt( "tabborder", "ll", "COMPAQ Smart Array Controller $i", 2 );
				open( SMART, "$cparray/ida$i" );
				while ( <SMART> ) {
					if ( m/^ida\d/ && $cpa_mode == 1 ) {
						@ff = split /:/;
						siprt( "tabrow" );
						siprtt( "cell", "Typ ($ff[0])" );
						siprtt( "cell", $ff[ 1 ] );
						siprt( "endrow" );
					} elsif ( m/:/i && !m/^Logical Drive Info:/i && $cpa_mode == 1 ) {
						@ff = split /:/;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprtt( "cell", $ff[ 1 ] );
						siprt( "endrow" );
					} elsif ( m/^ida\// && $cpa_mode == 2 ) {
						@ff = split / |=|:/;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprtt( "cell", $ff[ 3 ] );
						siprtt( "cell", $ff[ 5 ] );
						siprt( "endrow" );
					} elsif ( m/^nr_/ && $cpa_mode == 2 ) {
						@ff = split /=/;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprttt( "cellspan", $ff[ 1 ], 2 );
						siprt( "endrow" );
					} elsif ( m/^Logical Drive Info:/ ) {
						siprt( "endtab" );
						siprtt( "h2", "Logical Drive Info" );
						siprtttt( "tabborder", "lll", "COMPAQ Smart Array Logical Drive Info", 3 );
						siprt( "tabrow" );
						siprtt( "tabhead", "Drive" );
						siprtt( "tabhead", "Blocksize" );
						siprtt( "tabhead", "BlockNum" );
						siprt( "endrow" );
						$cpa_mode = 2;
					} else {
					}
				}
				close( SMART );
				siprt( "endtab" );
			}
		}
	}
}

sub si_gdth() {
	if ( -r "/proc/scsi/gdth" ) {
		siprtt( "h1", "ICP Vortex RAID" );
		for ( $i = 0 ; $i < 16 ; $i++ ) {
			if ( -r "/proc/scsi/gdth/$i" ) {
				siprtt( "h2", "Controller $i" );
				siprtttt( "tabborder", "llll", "ICP Vortex RAID Controller $i", 4 );
				open( GDTH, "/proc/scsi/gdth/$i" );
				while ( <GDTH> ) {
					if ( !m/^\s+/ ) {
						siprt( "tabrow" );
						siprttt( "headcol", $_, 4 );
						siprt( "endrow" );
					} else {
						@ff = split /\t/, $_, 4;
						siprt( "tabrow" );
						siprtt( "cell", $ff[ 0 ] );
						siprtt( "cell", $ff[ 1 ] );
						siprtt( "cell", $ff[ 2 ] );
						siprtt( "cell", $ff[ 3 ] );
						siprt( "endrow" );
					}
				}
				close( GDTH );
				siprt( "endtab" );
			}
		}
	}
}

sub si_ips() {
	if ( -r "/proc/scsi/ips" ) {
		siprtt( "h1", "IBM ServeRaid" );
		for ( $i = 0 ; $i < 16 ; $i++ ) {
			if ( -r "/proc/scsi/ips/$i" ) {
				siprtt( "h2", "Controller $i" );
				siprtttt( "tabborder", "ll", "IBM ServeRaid Controller $i", 2 );
				open( IPS, "/proc/scsi/ips/$i" );
				while ( <IPS> ) {
					if ( ( m/^\s+/ ) && ( !m/^$/ ) ) {
						my ( $key, $val ) = split /:/;
						siprt( "tabrow" );
						siprtt( "cell", $key );
						siprtt( "cell", $val );
						siprt( "endrow" );
					}
				}
				close( IPS );
				siprt( "endtab" );
			}
		}
	}
}

sub si_scsi() {
	my $header = 0;
	if ( -r "/proc/scsi/scsi" ) {
		open( SCSIINFO, "/proc/scsi/scsi" );
		while ( <SCSIINFO> ) {
			if ( m/^Host:\s+(.*)Channel:\s+(.*)Id:\s+(.*)Lun:\s+(.*)$/gs ) {
				$host    = $1;
				$channel = $2;
				$id      = $3;
				$lun     = $4;
				if ( !$header ) {
					siprtt( "h1", "SCSI" );
					siprtttt( "tabborder", "lllllllll", "SCSI", 9 );
					siprt( "tabrow" );
					siprtt( "tabhead", "Host" );
					siprtt( "tabhead", "Channel" );
					siprtt( "tabhead", "Id" );
					siprtt( "tabhead", "Lun" );
					siprtt( "tabhead", "Vendor" );
					siprtt( "tabhead", "Model" );
					siprtt( "tabhead", "Revision" );
					siprtt( "tabhead", "Type" );
					siprtt( "tabhead", "SCSI Rev." );
					siprt( "endrow" );
					$header = 1;
				}
			} elsif ( m/^\s+Vendor:\s+(.*)\s+Model:\s+(.*)\s+Rev:\s+(.*)$/gs ) {
				$vendor = $1;
				$model  = $2;
				$rev    = $3;
			} elsif ( m/^\s+Type:\s+(.*)\s+ANSI SCSI revision:\s+(.*)$/gs ) {
				$ttype   = $1;
				$ansirev = $2;
				siprt( "tabrow" );
				siprtt( "cell", $host );
				siprtt( "cell", $channel );
				siprtt( "cell", $id );
				siprtt( "cell", $lun );
				siprtt( "cell", $vendor );
				siprtt( "cell", $model );
				siprtt( "cell", $rev );
				siprtt( "cell", $ttype );
				siprtt( "cell", $ansirev );
				siprt( "endrow" );
			} else {
			}
		}
		close( SCSIINFO );
	}
	if ( $header ) {
		siprt( "endtab" );
	}
}

sub si_df() {
	my %rule    = ();
	my $isbegin = 1;
	open( DF, "$CMD_DF |" );
	siprtt( "h1", "Filesystem Disk Space Usage" );
	siprtttt( "tabborder", "llllllll", "Filesystem Disk Space Usage", 8 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Filesystem" );
	siprtt( "tabhead", "1k-blocks" );
	siprtt( "tabhead", "Used" );
	siprtt( "tabhead", "Available" );
	siprtt( "tabhead", "Use%" );
	siprtt( "tabhead", "Mounted on" );
	siprt( "endrow" );
	while ( <DF> ) {
		#if(m/^\d/){
		if ( m/^\/dev/ ) {
			my ( $filesys, $blocks, $used, $avail, $useperc, $mounted ) = split /\s+/;
			siprt( "tabrow" );
			siprtt( "cell", $filesys );
			siprtt( "cell", $blocks );
			siprtt( "cell", $used );
			siprtt( "cell", $avail );
			siprtt( "cell", $useperc );
			siprtt( "cell", $mounted );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
	close( DF );
}

sub si_mount() {
	%fsystem   = ();
	%mountp    = ();
	%blocks    = ();
	%resblocks = ();
	%ftype     = ();
	%fbegin    = ();
	%fend      = ();
	%mountopts = ();
	@sarray    = ();
	open( MOUNT, "$CMD_MOUNT |" );
	while ( <MOUNT> ) {
		if ( m/^\/dev/g ) {
			@params                    = split /\s+/;
			$fsystem{ $params[ 0 ] }   = $params[ 4 ];
			$mountp{ $params[ 0 ] }    = $params[ 2 ];
			$mountopts{ $params[ 0 ] } = $params[ 5 ];
		}
	}
	close( MOUNT );
	open( FDISK, "$CMD_fdisk -l |" );
	while ( <FDISK> ) {
		s/\*//gs;
		if ( m/^\/dev/g ) {
			@fparams = split /\s+/, $_, 6;
			$blocks{ $fparams[ 0 ] } = $fparams[ 3 ];
			chomp( $ftype{ $fparams[ 0 ] } = $fparams[ 5 ] );
			$fbegin{ $fparams[ 0 ] }   = $fparams[ 1 ];
			$fend{ $fparams[ 0 ] }     = $fparams[ 2 ];
			$ftypenum{ $fparams[ 0 ] } = $fparams[ 4 ];
			if ( $ftypenum{ $fparams[ 0 ] } eq "8e" ) {
				$ftype{ $fparams[ 0 ] } = "LVM-PV";
			}
			if ( $ftypenum{ $fparams[ 0 ] } eq "fe" ) {
				$ftype{ $fparams[ 0 ] } = "old LVM";
			}
		}
	}
	close( FDISK );
	open( DFK, "$CMD_DF -PPk |" );
	while ( <DFK> ) {
		if ( m/^\/dev/g ) {
			@dfkparams = split /\s+/, $_, 6;
			# $blocks{$dfkparams[0]} = $dfkparams[3];
			$dfkblocks{ $dfkparams[ 0 ] }  = $dfkparams[ 1 ];
			$dfkused{ $dfkparams[ 0 ] }    = $dfkparams[ 2 ];
			$dfkavail{ $dfkparams[ 0 ] }   = $dfkparams[ 3 ];
			$dfkpercent{ $dfkparams[ 0 ] } = $dfkparams[ 4 ];
			$dfkmountp{ $dfkparams[ 0 ] }  = $dfkmountp[ 4 ];
		}
	}
	close( DFK );
	open( LVM, "/proc/lvm |" );
	while ( <LVM> ) {
		if ( m/^LVM/g )        { }
		if ( m/^Total/g )      { }
		if ( m/^Global/g )     { }
		if ( m/^VG/g )         { }
		if ( m/^\s\sPV/g )     { }
		if ( m/^\s\s\s\sLV/g ) { }
		if ( m/^\/dev/g )      {
			#@dfkparams = split /\s+/,$_, 6;
			## $blocks{$dfkparams[0]} = $dfkparams[3];
			#$dfkblocks{$dfkparams[0]}  = $dfkparams[1];
			#$dfkused{$dfkparams[0]}    = $dfkparams[2];
			#$dfkavail{$dfkparams[0]}   = $dfkparams[3];
			#$dfkpercent{$dfkparams[0]} = $dfkparams[4];
		}
	}
	close( LVM );
	siprtt( "h1", "Partitions, Mounts, LVM" );
	siprtt( "h2", "Overview" );
	siprtttt( "tabborder", "llllllllllllllll", "Partitions, Mounts, LVM", 16 );
	@tarray = sort keys %mountp;
	push @tarray, sort keys %blocks;
	$oldtt = "";
	for $tt ( sort @tarray ) {
		if ( $oldtt ne $tt ) { push @sarray, $tt; }
		$oldtt = $tt;
	}
	# for $tt (sort keys %mountp) {
	siprt( "tabrow" );
	siprtt( "tabhead", "Partition" );
	siprtt( "tabhead", "PType" );
	siprtt( "tabhead", "\#" );
	siprtt( "tabhead", "Begin" );
	siprtt( "tabhead", "End" );
	siprtt( "tabhead", "Raw size" );
	siprtt( "tabhead", "Mountpoint" );
	siprtt( "tabhead", "Filesys." );
	siprtt( "tabhead", "res." );
	siprtt( "tabhead", "BlkSize" );
	siprtt( "tabhead", "I.Dens." );
	siprtt( "tabhead", "MaxMnt" );
	siprtt( "tabhead", "Blocks" );
	siprtt( "tabhead", "Used" );
	siprtt( "tabhead", "Avail." );
	siprtt( "tabhead", "%" );
	siprt( "endrow" );
	open( SAVEERR, ">&STDERR" );
	open( STDERR,  ">/dev/null" );
	for $tt ( sort @sarray ) {
		open( TUNE, "$CMD_TUNEFS -l $tt |" );
		while ( <TUNE> ) {
			if ( m/^Reserved block count:\s*(\w+)\s*$/g ) {
				$resblocks{ $tt } = $1;
			}
			if ( m/^Block size:\s*(\w+)\s*$/g )          { $blocksize{ $tt }  = $1; }
			if ( m/^Inode count:\s*(\w+)\s*$/g )         { $inodecount{ $tt } = $1; }
			if ( m/^Block count:\s*(\w+)\s*$/g )         { $blockcount{ $tt } = $1; }
			if ( m/^Maximum mount count:\s*(\w+)\s*$/g ) { $maxmount{ $tt }   = $1; }
		}
		close( TUNE );
		if ( ( $inodecount{ $tt } != 0 ) && ( $blockcount{ $tt } != 0 ) && ( $blocksize{ $tt } != 0 ) ) {
			$inodedensity{ $tt } = ( 2**int( log( $blockcount{ $tt } / $inodecount{ $tt } ) / log( 2 ) + 0.5 ) ) * $blocksize{ $tt };
		} else {
			$inodedensity{ $tt } = "-";
		}
	}
	open( STDERR, ">&SAVEERR" );
	for $tt ( sort @sarray ) {
		siprt( "tabrow" );
		siprtt( "cell", $tt );
		siprtt( "cell", $ftype{ $tt } );
		siprtt( "cell", $ftypenum{ $tt } );
		siprtt( "cell", $fbegin{ $tt } );
		siprtt( "cell", $fend{ $tt } );
		siprtt( "cell", $blocks{ $tt } );
		siprtt( "cell", $mountp{ $tt } );
		siprtt( "cell", $fsystem{ $tt } );
		siprtt( "cell", $resblocks{ $tt } );
		siprtt( "cell", $blocksize{ $tt } );
		siprtt( "cell", $inodedensity{ $tt } );
		siprtt( "cell", $maxmount{ $tt } );
		siprtt( "cell", $dfkblocks{ $tt } );
		siprtt( "cell", $dfkused{ $tt } );
		siprtt( "cell", $dfkavail{ $tt } );
		siprtt( "cell", $dfkpercent{ $tt } );
		siprt( "endrow" );
	}
	siprt( "endtab" );
	#
	# open(PART, ">sitar-$HOSTNAME.part");
	# for $tt (sort @sarray) {
	#  print PART "";
	#  $tt, $ftype{$tt}, "</td>",
	#  "<td>", $ftypenum{$tt}, "</td>",
	#  "<td>", $fbegin{$tt}, "</td>",
	#  "<td>", $fend{$tt}, "</td>",
	#  "<td>", $blocks{$tt}, "</td>",
	#  "<td>", $mountp{$tt}, "</td>",
	#  "<td>", $fsystem{$tt}, "</td>",
	#  "<td>", $resblocks{$tt}, "</td>",
	#  "<td>", $blocksize{$tt}, "</td>",
	#  "<td>", $inodedensity{$tt}, "</td>",
	#  "<td>", $maxmount{$tt}, "</td>",
	#  "<td>", $dfkblocks{$tt}, "</td>",
	#  "<td>", $dfkused{$tt}, "</td>",
	#  "<td>", $dfkavail{$tt}, "</td>",
	#  "<td>", $dfkpercent{$tt}, "</td>",
	#  "\n</tr>\n";
	# }
	# close(PART);
	siprtt( "h2", "Configuration Files (fstab, lvm)" );
	si_conf( "/etc/fstab",        "/etc/fstab",        "\#" );
	si_conf( "/etc/lvm/lvm.conf", "/etc/lvm/lvm.conf", "\#" );
	si_conf( "/etc/lvm/.cache",   "/etc/lvm/.cache",   "\#" );
	if ( -d "/etc/lvm/backup" ) {
		for $NN ( sort `$CMD_FIND /etc/lvm/backup/ -type f` ) {
			chomp $NN;
			si_conf( $NN, $NN, "\#" );
		}
	}
	if ( -x "$CMD_EVMS_INFO" ) {
		siprtt( "h2", "EVMS Information" );
		siprt( "pre" );
		# 'evms_gather_info' searches for 'evms' internally, ...
		$ENV{ PATH } = '/sbin:/bin:/usr/bin:/usr/sbin';
		open( EVMSINFO, "$CMD_EVMS_INFO |" );
		while ( <EVMSINFO> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( EVMSINFO );
		$ENV{ PATH } = '';
		# cleanup behind 'evms_gather_info'
		if ( -r "gather_info.qry" ) {
			unlink "gather_info.qry";
		}
		siprt( "endpre" );
	}
	if ( -x "$CMD_MULTIPATH" ) {
		siprtt( "h2", "Multipathing (dm based)" );
		si_conf( $multipath_conf, $multipath_conf, "\#" );
		siprtt( "h3", "$CMD_MULTIPATH -ll" );
		siprt( "pre" );
		open( CONFIG, "$CMD_MULTIPATH -ll |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
	}
}

sub si_ifconfig() {
	my %rule    = ();
	my $isbegin = 1;
	open( IFCONFIG, "$CMD_IFCONF -v |" );
	siprtt( "h1", "Networking Interfaces" );
	siprt( "pre" );
	siprtt( "verb", "skipping IPv6 Options" );
	siprt( "endpre" );
	siprtttt( "tabborder", "lllllllll", "Networking Interfaces", 9 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Device" );
	siprtt( "tabhead", "Link Encap" );
	siprtt( "tabhead", "HW-Address" );
	siprtt( "tabhead", "IP" );
	siprtt( "tabhead", "Broadcast" );
	siprtt( "tabhead", "Mask" );
	siprtt( "tabhead", "Options" );
	siprtt( "tabhead", "MTU" );
	siprtt( "tabhead", "Metric" );
	siprt( "endrow" );
	while ( <IFCONFIG> ) {
		if ( m/^\S/g ) {
			siprt( "tabrow" );
			s/^([\w:]+)\s+Link\sencap:(\w+)\s+((HWaddr\s(.*))|(Loopback))\s*$/$1::$2::$5$6/ix;
			my ( $t1, $t2, $t3 ) = split /::/;
			siprtt( "cell", $t1 );
			siprtt( "cell", $t2 );
			siprtt( "cell", $t3 );
		} elsif ( m/.*inet6.*/g ) {
		} elsif ( m/.*inet.*/g )  {
			s/\s*inet\saddr:([\w|.]+)\s+((Bcast:([\w|.]+)\s+)|(\s+))Mask:([\w|.]+)\s*/$1::$4::$6/ix;
			my ( $t1, $t2, $t3 ) = split /::/;
			siprtt( "cell", $t1 );
			siprtt( "cell", $t2 );
			siprtt( "cell", $t3 );
		} elsif ( m/.*Metric.*/g ) {
			s/\s*([\w+\s]*)\s+MTU:([\w|.]+)\s+Metric:([\w|.]+)\s*/$1::$2::$3/ix;
			my ( $t1, $t2, $t3 ) = split /::/;
			siprtt( "cell", $t1 );
			siprtt( "cell", $t2 );
			siprtt( "cell", $t3 );
			siprt( "endrow" );
		} else {
		}
	}
	siprt( "endtab" );
	close( IFCONFIG );
}

sub si_route() {
	my %rule    = ();
	my $isbegin = 1;
	open( ROUTE, "$CMD_ROUTE -n |" );
	siprtt( "h1", "Routing" );
	siprtttt( "tabborder", "llllllll", "Routing", 8 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Destination" );
	siprtt( "tabhead", "Gateway" );
	siprtt( "tabhead", "Genmask" );
	siprtt( "tabhead", "Flags" );
	siprtt( "tabhead", "Metric" );
	siprtt( "tabhead", "Ref" );
	siprtt( "tabhead", "Use" );
	siprtt( "tabhead", "IFace" );
	siprt( "endrow" );
	while ( <ROUTE> ) {
		if ( m/^\d/ ) {
			my ( $dest, $gate, $genmask, $flags, $metric, $ref, $use, $iface ) = split /\s+/;
			siprt( "tabrow" );
			siprtt( "cell", $dest );
			siprtt( "cell", $gate );
			siprtt( "cell", $genmask );

			sub si_usercrontab() {
				# Crontab
				siprtt( "h1", "Crontab" );
				if ( -r "/etc/crontab" ) {
					open( CRONTAB, "/etc/crontab" );
					siprtt( "h2", "/etc/crontab" );
					siprtttt( "tabborder", "llllllll", "/etc/crontab", 8 );
					siprt( "tabrow" );
					siprtt( "tabhead", "Minute" );
					siprtt( "tabhead", "Hour" );
					siprtt( "tabhead", "Day of month" );
					siprtt( "tabhead", "Month" );
					siprtt( "tabhead", "Day of week" );
					siprtt( "tabhead", "User" );
					siprtt( "tabhead", "Command" );
					siprt( "endrow" );
					while ( <CRONTAB> ) {
						if ( m/^\d/ ) {
							my ( $minute, $hour, $dayofmonth, $month, $dayofweek, $user, @command ) = split /\s+/;
							siprt( "tabrow" );
							siprtt( "cell", $minute );
							siprtt( "cell", $hour );
							siprtt( "cell", $dayofmonth );
							siprtt( "cell", $month );
							siprtt( "cell", $dayofweek );
							siprtt( "cell", $user );
							siprtt( "cell", "@command" );
							siprt( "endrow" );
						}
					}
					siprt( "endtab" );
					close( CRONTAB );
				}
				if ( -r "/var/spool/cron" ) {
					for $NN ( `$CMD_FIND /var/spool/cron -type f` ) {
						chomp $NN;
						my %rule    = ();
						my $isbegin = 1;
						open( CRONTAB, $NN );
						siprtt( "h2", "$NN" );
						siprtttt( "tabborder", "llllllll", "$NN", 8 );
						siprt( "tabrow" );
						siprtt( "tabhead", "Minute" );
						siprtt( "tabhead", "Hour" );
						siprtt( "tabhead", "Day of month" );
						siprtt( "tabhead", "Month" );
						siprtt( "tabhead", "Day of week" );
						siprtt( "tabhead", "Command" );
						siprt( "endrow" );
						while ( <CRONTAB> ) {
							if ( m/^\d/ ) {
								my ( $minute, $hour, $dayofmonth, $month, $dayofweek, @command ) = split /\s+/;
								siprt( "tabrow" );
								siprtt( "cell", $minute );
								siprtt( "cell", $hour );
								siprtt( "cell", $dayofmonth );
								siprtt( "cell", $month );
								siprtt( "cell", $dayofweek );
								siprtt( "cell", "@command" );
								siprt( "endrow" );
							}
						}
						siprt( "endtab" );
						close( CRONTAB );
					}
				}
			}
			siprtt( "cell", $flags );
			siprtt( "cell", $metric );
			siprtt( "cell", $ref );
			siprtt( "cell", $use );
			siprtt( "cell", $iface );
			siprt( "endrow" );
		}
	}
	siprt( "endtab" );
	close( ROUTE );
}

sub si_ipvs () {
}

sub si_ipfwadm() {
	siprt( "pre" );
	siprtt( "verb", "ipfwadm is not supported." );
	siprt( "endpre" );
}

sub si_ipchains () {
	my @protocols = ();
	open( PROTO, "/etc/protocols" );
	while ( <PROTO> ) {
		if ( !m/^#/ ) {
			m/^(\w+)\s+(\w+)\s+(\w+)\s*/g;
			$protocols[ $2 ] = $1;
		}
	}
	close( PROTO );
	open( CHAIN, "/proc/net/ip_fwchains" );
	$no_header = 1;
	while ( <CHAIN> ) {
		( $empty, $chainname, $sourcedest, $ifname, $fw_flg, $fw_invflg, $proto, $packa, $packb, $bytea, $byteb, $portsrc, $portdest, $tos, $xor, $redir, $fw_mark, $outsize, $target ) = split /\s+/;
		$sourcedest =~ m/(\w\w)(\w\w)(\w\w)(\w\w)\/(\w\w)(\w\w)(\w\w)(\w\w)->(\w\w)(\w\w)(\w\w)(\w\w)\/(\w\w)(\w\w)(\w\w)(\w\w)/g;
		$source = join "", hex( $1 ), ".", hex( $2 ),  ".", hex( $3 ),  ".", hex( $4 ),  "/", hex( $5 ),  ".", hex( $6 ),  ".", hex( $7 ),  ".", hex( $8 );
		$dest   = join "", hex( $9 ), ".", hex( $10 ), ".", hex( $11 ), ".", hex( $12 ), "/", hex( $13 ), ".", hex( $14 ), ".", hex( $15 ), ".", hex( $16 );
		if ( $no_header ) {
			if ( $chainname ne "" ) {
				siprtt( "h2", "Filter Rules" );
				siprtttt( "tabborder", "lllllllllllllllll", "Filter Rules", 17 );
				siprt( "tabrow" );
				siprtt( "tabhead", "Name" );
				siprtt( "tabhead", "Target" );
				siprtt( "tabhead", "I.face" );
				siprtt( "tabhead", "Proto" );
				siprtt( "tabhead", "Src" );
				siprtt( "tabhead", "Port" );
				siprtt( "tabhead", "Dest" );
				siprtt( "tabhead", "Port" );
				siprtt( "tabhead", "Flag" );
				siprtt( "tabhead", "Inv" );
				siprtt( "tabhead", "TOS" );
				siprtt( "tabhead", "XOR" );
				siprtt( "tabhead", "RdPort" );
				siprtt( "tabhead", "FWMark" );
				# siprtt("tabhead","OutputSize");
				# siprtt("tabhead","Packets");
				# siprtt("tabhead","Bytes");
				siprt( "endrow" );
				$no_header = 0;
			}
		}
		@PORT = split '-', $portsrc;
		if ( $PORT[ 0 ] == $PORT[ 1 ] ) { $portsrc = $PORT[ 0 ]; }
		@PORT = split '-', $portdest;
		siprt( "tabrow" );
		siprtt( "cell", $chainname );
		siprtt( "cell", $target );
		siprtt( "cell", $ifname );
		siprtt( "cell", ( ( $proto eq "0" ) ? "-" : $protocols[ $proto ] ) );
		siprtt( "cell", $source );
		siprtt( "cell", $portsrc );
		siprtt( "cell", $dest );
		siprtt( "cell", $portdest );
		siprtt( "cell", $fw_flg );
		siprtt( "cell", $fw_invflg );
		siprtt( "cell", $tos );
		siprtt( "cell", $xor );
		siprtt( "cell", $redir );
		siprtt( "cell", $fw_mark );
		# siprtt("cell",$outsize);
		# siprtt("cell","$packa,$packb");
		# siprtt("cell","$bytea,$byteb");
		siprt( "endrow" );
	}
	close( CHAIN );
	if ( $no_header ) {
		## siprtt("h2","No Filter Rules active");
	} else {
		siprt( "endtab" );
	}
	$no_header = 1;
	open( NAMES, "/proc/net/ip_fwnames" );
	while ( <NAMES> ) {
		( $chainname, $policy, $refcount ) = split /\s+/;
		if ( $no_header ) {
			siprtt( "h2", "Filter Policy" );
			siprtttt( "tabborder", "lll", "Filter Policy", 3 );
			siprt( "tabrow" );
			siprtt( "tabhead", "Name" );
			siprtt( "tabhead", "Policy" );
			siprtt( "tabhead", "RefCount" );
			siprt( "endrow" );
			$no_header = 0;
		}
		siprt( "tabrow" );
		siprtt( "cell", $chainname );
		siprtt( "cell", $policy );
		siprtt( "cell", $refcount );
		siprt( "endrow" );
	}
	if ( $no_header == 0 ) {
		siprt( "endtab" );
	}
	close( NAMES );
}

sub si_chkconfig () {
	if ( -x "$CMD_CHKCONF" ) {
		push @lines, $_;
		siprtt( "h1", "Automatic Startup (chkconfig -l)" );
		siprt( "pre" );
		open( CONFIG, "$CMD_CHKCONF --list |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
	}
}

sub si_iptables () {
	if ( -x "$CMD_IPTABLES" ) {
		push @lines, $_;
		open( TABLES, "/proc/net/ip_tables_names" );
		while ( $tabname = <TABLES> ) {
			chomp( $tabname );
			push @tables, $tabname;
		}
		close( TABLES );
		foreach $tabname ( @tables ) {
			chomp();
			siprtt( "h2", "Table $tabname" );
			siprt( "pre" );
			open( CONFIG, "$CMD_IPTABLES -v -L -n -t $tabname |" );
			while ( <CONFIG> ) {
				chomp();
				siprtt( "verb", "$_\n" );
			}
			close( CONFIG );
			siprt( "endpre" );
		}
	}
}

sub si_packetfilter() {
	if ( -r "/proc/net/ip_input" ) {
		siprtt( "h1", "Packet Filter (ipfwadm)" );
		si_ipfwadm();
	} elsif ( -r "/proc/net/ip_fwnames" ) {
		siprtt( "h1", "Packet Filter (ipchains)" );
		si_ipchains();
	} elsif ( -r "/proc/net/ip_tables_names" ) {
		siprtt( "h1", "Packet Filter (iptables)" );
		si_iptables();
	} else {
		siprtt( "h1", "Packet Filter" );
		siprt( "pre" );
		siprtt( "verb", "No packet filter installed." );
		siprt( "endpre" );
	}
}

sub si_conf_filename_stat($$$) {
	my ( $filename, $comment, $call_stat ) = @_;
	if ( $call_stat == 1 ) {
		( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $filename );
	}
	siprtttt( "tabborder", "ll", "stat:$filename", 2 );
	siprt( "tabrow" );
	siprtt( "cell", "uid gid" );
	siprtt( "cell", "$ff_uid $ff_gid" );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "mode" );
	siprtt( "cell", sprintf "%lo", ( $ff_mode & 07777 ) );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "size" );
	siprtt( "cell", $ff_size );
	siprt( "endrow" );
	siprt( "tabrow" );
	siprtt( "cell", "mtime" );
	siprtt( "cell", localtime( $ff_mtime ) );
	siprt( "endrow" );
	if ( $comment ne "" ) {
		siprt( "tabrow" );
		siprtt( "cell", "line comment char" );
		siprtt( "cell", $comment );
		siprt( "endrow" );
	}
	siprt( "endtab" );
}

sub si_conf_secure($$$) {
	my ( $filename, $comment, $blankout ) = @_;
	( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $filename );
	if ( $NN !~ /(\w*\.orig$)|(\w*\.org$)|(\w*\.ori$)|(\w*\.bak$)|(\w*\.bac$)|(\w*\~)|(\#\w*)/ ) {
		siprtt( "h3", $filename );
		# print STDERR $filename, ": ", $comment, "\n";
		si_conf_filename_stat( $filename, $comment, 0 );
		siprt( "pre" );
		if ( $comment eq "/**/" ) {
			open( CONFIG, $filename );
			my $old_recsep = $/;
			undef $/;
			$ttt = <CONFIG>;
			$ttt =~ s#/\*.*?\*/##gs;
			$ttt =~ s#//.*##g;
			$ttt =~ s/\n\s*\n/\n/gs;
			close( CONFIG );
			siprtt( "verb", $ttt );
			$/ = $old_recsep;
		} else {
			open( CONFIG, "<$filename" );
			while ( <CONFIG> ) {
				chomp();
				if ( !m/^\s*($comment)|^\s*$|^$/ ) {
					if ( m/$blankout/ ) {
						s/($blankout.*=)(.*)/$1### sensitive data blanked out ###/;
					}
					siprtt( "verb", "$_\n" );
				}
			}
			close( CONFIG );
		}
		siprt( "endpre" );
	}
}

sub si_conf($$$) {
	my ( $title, $filename, $comment ) = @_;
	( $ff_dev, $ff_ino, $ff_mode, $ff_nlink, $ff_uid, $ff_gid, $ff_rdev, $ff_size, $ff_atime, $ff_mtime, $ff_ctime, $ff_blksize, $ff_blocks ) = stat( $filename );
	if ( $NN !~ /(\w*\.orig$)|(\w*\.org$)|(\w*\.ori$)|(\w*\.bak$)|(\w*\.bac$)|(\w*\~)|(\#\w*)/ ) {
		$SITAR_OPT_LVMARCHIVE =~ tr/A-Z/a-z/;
		$SITAR_OPT_GCONF      =~ tr/A-Z/a-z/;
		if ( exists( $ignoreconfigfiles{ $filename } ) ) {
			# debug
		} elsif ( ( $SITAR_OPT_LVMARCHIVE eq "no" ) && ( $filename =~ /etc\/lvm\/archive/ ) ) {
			# print "file below /etc/lvm/archive/ found; skipped $fname\n";
		} elsif ( ( $SITAR_OPT_GCONF eq "no" ) && ( $filename =~ /etc\/opt\/gnome/ ) ) {
			# print "GCONF below /etc/opt/gnome/gconf/ found; skipped $fname\n";
		} elsif ( ( $SITAR_OPT_LIMIT > 0 ) && ( $ff_size > $SITAR_OPT_LIMIT ) ) {
			# print "LIMIT exceed; skipped $fname\n";
		} else {
			if ( $title eq $filename ) {
				siprtt( "h3", "$filename" );
			} else {
				siprtt( "h3", "$title - $filename" );
			}
			si_conf_filename_stat( $filename, $comment, 0 );
			# print STDERR $filename, ": ", $comment, "\n";
			siprt( "pre" );
			if ( $comment eq "/**/" ) {
				open( CONFIG, $filename );
				my $old_recsep = $/;
				undef $/;
				$ttt = <CONFIG>;
				$ttt =~ s#/\*.*?\*/##gs;
				$ttt =~ s#//.*##g;
				$ttt =~ s/\n\s*\n/\n/gs;
				close( CONFIG );
				siprtt( "verb", $ttt );
				$/ = $old_recsep;
			} elsif ( $comment eq "" ) {
				open( CONFIG, "<$filename" );
				while ( <CONFIG> ) {
					chomp();
					siprtt( "verb", "$_\n" );
				}
				close( CONFIG );
			} else {
				open( CONFIG, "<$filename" );
				while ( <CONFIG> ) {
					chomp();
					if ( !m/^\s*($comment)|^\s*$|^$/ ) {
						siprtt( "verb", "$_\n" );
					}
				}
				close( CONFIG );
			}
			siprt( "endpre" );
		}
	}
}

sub si_build_proc_description() {
	open( PROCTXT, "<$SITAR_PREFIX/share/sitar/proc.txt" );
	#if ( -r "/usr/src/linux/Documentation/proc.txt" ) {
	#	open( PROCTXT, "</usr/src/linux/Documentation/proc.txt" );
	#} elsif ( -r "/usr/src/linux/Documentation/filesystems/proc.txt" ) {
	#	open( PROCTXT, "</usr/src/linux/Documentation/filesystems/proc.txt" );
	#} else {
	#}
	$old_slash = $/;
	undef $/;
	$_ = <PROCTXT>;
	my @proc_a = split /\n\n/;
	close( PROCTXT );
	$/ = $old_slash;
	for $NN ( @proc_a ) {
		my @mypair = split /\n/, $NN, 2;
		my $newkey = $mypair[ 0 ];
		my $newval = $mypair[ 1 ];
		$proc_h{ $newkey } = $newval;
	}
}

sub si_proc_sys_net () {
	my $value;
	siprtt( "h2", "/proc/sys/net" );
	my @nettypes = qw(802 appletalk ax25 rose x25 bridge core decnet ethernet ipv4 ipv6 irda ipx net-rom token-ring unix);
	for $NET ( @nettypes ) {
		if ( ( -d "/proc/sys/net/$NET" ) ) {
			opendir( DIR, "/proc/sys/net/$NET" );
			@curr_dir = readdir( DIR );
			if ( $#curr_dir > 1 ) {
				siprtt( "h3", "/proc/sys/net/$NET" );
				siprtttt( "tabborder", "llp{.5\\textwidth}", "/proc/sys/net/$NET", 3 );
				open( SAVEERR, ">&STDERR" );
				open( STDERR,  ">/dev/null" );
				for $NN ( sort `$CMD_FIND /proc/sys/net/$NET/ -type f` ) {
					chomp $NN;
					$value = `$CMD_CAT $NN`;
					if ( $value ne "" ) {
						my $MM = $NN;
						$MM =~ s/\/proc\/sys\/net\/$NET\///;
						$OO = $MM;
						$OO =~ s/(\w+\/)*(\w+)$/$+/;
						chomp $OO;
						siprt( "tabrow" );
						siprtt( "cell",     $MM );
						siprtt( "cell",     $value );
						siprtt( "cellwrap", $proc_h{ $OO } );
						siprt( "endrow" );
					}
				}
				open( STDERR, ">&SAVEERR" );
				siprt( "endtab" );
			}
		}
	}
}

sub si_immunix_apparmor () {
	if ( ( -d "$apparmor_kernel_path" ) && ( -d "$apparmor_profiles_path" ) ) {
		siprtt( "h1", $apparmor_verbose_name );
		siprtt( "h2", "Current Configuration" );
		siprtttt( "tabborder", "lll", "Configuration", 3 );
		open( SAVEERR, ">&STDERR" );
		open( STDERR,  ">/dev/null" );
		for $NN ( sort `$CMD_FIND $apparmor_kernel_path/ -type f` ) {
			chomp $NN;
			$value = `$CMD_CAT $NN`;
			if ( $value ne "" ) {
				my $MM = $NN;
				$MM =~ s/$apparmor_kernel_path\///;
				$OO = $MM;
				$OO =~ s/(\w+\/)*(\w+)$/$+/;
				chomp $OO;
				if ( $OO eq "profiles" ) {
					siprt( "tabrow" );
					siprtt( "cell", $OO );
					siprt( "emptycell" );
					siprt( "emptycell" );
					siprt( "endrow" );
					for $TT ( split( /\)/, $value ) ) {
						my ( $tname, $tenforce ) = split( /\(/, $TT );
						siprt( "tabrow" );
						siprt( "emptycell" );
						siprtt( "cell", $tname );
						siprtt( "cell", $tenforce );
						siprt( "endrow" );
					}
				} else {
					siprt( "tabrow" );
					siprtt( "cell", $OO );
					siprtt( "cell", $value );
					siprt( "emptycell" );
					siprt( "endrow" );
				}
			}
		}
		open( STDERR, ">&SAVEERR" );
		siprt( "endtab" );
		if ( -f "$apparmor_config_path" ) {
			si_conf( $apparmor_config_path, $apparmor_config_path, "\#" );
		}
		if ( -d "$apparmor_config_directory" ) {
			for $NN ( `$CMD_FIND $apparmor_config_directory -type f` ) {
				chomp $NN;
				si_conf( $NN, $NN, "\#" );
			}
		}
		$SITAR_OPT_ALLSUBDOMAIN =~ tr/A-Z/a-z/;
		if (       ( $SITAR_OPT_ALLSUBDOMAIN eq "on" )
			|| ( ( !-f "$SITAR_CONFIG_DIR/$SITAR_CONSIST_FN" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_UNPACKED_FN" ) && ( $SITAR_OPT_ALLSUBDOMAIN eq "auto" ) ) ) {
			siprtt( "h2", "Profiles" );
			for $NN ( `$CMD_FIND $apparmor_profiles_path -type f` ) {
				chomp $NN;
				si_conf( $NN, $NN, "" );
			}
		}
	}
}

sub si_proc () {
	si_build_proc_description();
	siprtt( "h1", "/proc" );
	si_proc_sys_net();
	si_proc_modules();
}

sub si_etc() {
	siprtt( "h1", "Configuration" );
	siprtt( "h2", "Common" );
	# SSH/OpenSSH
	my @sshconf = qw ( /etc/ssh/sshd_config /etc/sshd_config );
	foreach $file ( @sshconf ) {
		if ( -r $file ) { si_conf( "SSH/OpenSSH", $file, "\#" ); }
	}
	# DNS - Bind
	my @namedconf = qw ( /etc/named.conf /etc/bind/named.conf );
	foreach $file ( @namedconf ) {
		if ( -r $file ) {
			si_conf( "DNS/Bind", $file, "/**/" );
			open( FILE, $file );
			while ( <FILE> ) {
				if ( $_ =~ m/.*file\s*"(.*)".*/ ) {
					if ( -r "/var/named/" . $1 ) {
						si_conf( "Zones/DB", "/var/named/" . $1, "\#|;" );
					}
				}
			}
			close FILE;
		}
	}
	# Samba
	my @smbconf = qw ( /etc/smb.conf /etc/samba/smb.conf );
	foreach $file ( @smbconf ) {
		if ( -r $file ) { si_conf( "Samba", $file, "\#|;" ); }
	}
	# OpenLDAP
	my @slapdconf = qw ( /etc/openldap/slapd.conf /etc/ldap/slapd.conf /etc/slapd.conf );
	foreach $file ( @slapdconf ) {
		if ( -r $file ) { si_conf( "OpenLDAP Server", $file, "\#" ); }
	}
	my @ldapconf = qw ( /etc/openldap/ldap.conf /etc/ldap/ldap.conf  /etc/ldap.conf );
	foreach $file ( @ldapconf ) {
		if ( -r $file ) { si_conf( "OpenLDAP Client", $file, "\#" ); }
	}
	# Postfix
	if ( ( -d "/etc/postfix/" ) && ( -x "$CMD_POSTCONF" ) ) {
		siprtt( "h2", "Postfix (postconf -n)" );
		siprt( "pre" );
		open( CONFIG, "$CMD_POSTCONF -n |" );
		while ( <CONFIG> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( CONFIG );
		siprt( "endpre" );
		if ( -r "/etc/aliases" ) { si_conf( "/etc/aliases", "/etc/aliases", "\#" ); }
	}
	# some more services/programs
	$SITAR_OPT_ALLCONFIGFILES =~ tr/A-Z/a-z/;
	if (       ( $SITAR_OPT_ALLCONFIGFILES eq "on" )
		|| ( ( !-f "$SITAR_CONFIG_DIR/$SITAR_CONSIST_FN" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_UNPACKED_FN" ) && ( $SITAR_OPT_ALLCONFIGFILES eq "auto" ) ) ) {
		my %myfiles = ();
		foreach ( @allconfigfiless ) {
			$myfiles{ $_ } = 0;
		}
		foreach $mm ( sort keys %myfiles ) {
			if ( $mm !~ /proc/ ) {
				if ( ( $mm eq "/etc/pppoed.conf" ) || ( $mm eq "/etc/grub.conf" ) || ( $mm eq "/boot/grub/menu.lst" ) || ( $mm eq "/etc/lilo.conf" ) ) {
					if ( -r $mm ) { si_conf_secure( $mm, "\#", "[Pp]assword" ); }
				} else {
					if ( -r $mm ) { si_conf( $mm, $mm, "\#" ); }
				}
			}
		}
	}
	#
	# some more services/programs
	#
	if ( -d $SITAR_CONFIG_DIR ) {
		for $NN ( `$CMD_FIND $SITAR_CONFIG_DIR -iname "*.include" -type f` ) {
			chomp $NN;
			%myfiles = ();
			do "$NN";
			foreach ( @files ) {
				$myfiles{ $_ } = 0;
			}
			$OO = $NN;
			$OO =~ s+$SITAR_CONFIG_DIR++g;
			$OO =~ s+^/++g;
			$OO = substr( $OO, 0, rindex( $OO, ".include" ) );
			siprtt( "h2", ucfirst( $OO ) . " ($NN)" );
			si_conf_filename_stat( $NN, "", 1 );
			foreach $mm ( sort keys %myfiles ) {
				if ( $mm !~ /proc/ ) {
					if ( ( $mm eq "/etc/pppoed.conf" ) || ( $mm eq "/etc/grub.conf" ) || ( $mm eq "/boot/grub/menu.lst" ) || ( $mm eq "/etc/lilo.conf" ) ) {
						if ( -r $mm ) { si_conf_secure( $mm, "\#", "[Pp]assword" ); }
					} else {
						if ( -r $mm ) { si_conf( $mm, $mm, "\#" ); }
					}
				}
			}
		}
	}
}

sub si_etc_debian() {
	# special function for debian specific configuration
	#siprtt( "h1", "Configuration" );
}

sub si_etc_redhat() {
	si_usercrontab();
	# Sysconfig
	if ( -r "/etc/sysconfig" ) {
		siprtt( "h2", "Sysconfig" );
		for $NN ( `$CMD_FIND /etc/sysconfig -type f` ) {
			chomp $NN;
			if ( `$CMD_FILE -b $NN | $CMD_GREP -i -e text` ) {
				si_conf( $NN, $NN, "\#" );
			}
		}
	}
}

sub si_etc_united() {
	$SITAR_OPT_ALLSYSCONFIG =~ tr/A-Z/a-z/;
	if (       ( $SITAR_OPT_ALLSYSCONFIG eq "on" )
		|| ( ( !-f "$SITAR_CONFIG_DIR/$SITAR_CONSIST_FN" ) && ( !-f "$SITAR_CONFIG_DIR/$SITAR_UNPACKED_FN" ) && ( $SITAR_OPT_ALLSYSCONFIG eq "auto" ) ) ) {
		if ( -r "/etc/sysconfig" ) {
			siprtt( "h2", "Sysconfig" );
			for $NN ( `$CMD_FIND /etc/sysconfig -type f` ) {
				chomp $NN;
				if ( `$CMD_FILE -b $NN | $CMD_GREP -i -e text | $CMD_GREP -i -v "shell script"` ) {
					si_conf( $NN, $NN, "\#" );
				}
			}
		}
	}
	# SuSE proxy suite
	if ( -r "/etc/proxy-suite" ) {
		siprtt( "h2", "SuSE Proxy Suite" );
		for $NN ( `$CMD_FIND /etc/proxy-suite -name "*.conf"` ) {
			chomp $NN;
			si_conf( $NN, $NN, "\#" );
		}
	}
}

sub si_etc_suse() {
	# special function for suse specific configuration
	if ( -d "/etc/rc.config.d" || -r "/etc/rc.config" ) {
		siprtt( "h2", "/etc/rc.config*" );
		si_conf( "/etc/rc.config", "/etc/rc.config", "\#" );
		if ( -r "/etc/rc.config.d" ) {
			for $NN ( `$CMD_FIND /etc/rc.config.d -name "*.config"` ) {
				chomp $NN;
				si_conf( $NN, $NN, "\#" );
			}
		}
	}
}

sub si_kernel_config() {
	my $comment = "\#";
	my $config  = "/boot/config-$UNAMER";
	siprtt( "h1", "Kernel Configuration" );
	siprt( "multipre" );
	open( CONFIG, "<$config" );
	while ( <CONFIG> ) {
		chomp();
		if ( !m/^($comment)|^$/ ) {
			siprtt( "verb", "$_\n" );
		}
	}
	close( CONFIG );
	siprt( "endmultipre" );
}

sub si_proc_config() {
	my $comment = "\#";
	if ( ( -r "/proc/config.gz" ) && ( -x "$CMD_GZIP" ) ) {
		siprtt( "h1", "Kernel Configuration" );
		siprt( "multipre" );
		open( CONFIG, "$CMD_GZIP -dc /proc/config.gz |" );
		while ( <CONFIG> ) {
			chomp();
			if ( !m/^($comment)|^$/ ) {
				siprtt( "verb", "$_\n" );
			}
		}
		close( CONFIG );
		siprt( "endmultipre" );
	}
}

sub si_installed_deb() {
	siprtt( "h1", "Installed Packages" );
	siprtttt( "tabborder", "llllp{.5\\textwidth}", "Installed Packages", 5 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Name" );
	siprtt( "tabhead", "Status" );
	siprtt( "tabhead", "Version" );
	siprtt( "tabhead", "Size" );
	siprtt( "tabhead", "Short Description" );
	siprt( "endrow" );
	my $total = 0;
	my $num   = 0;
	my @debs;
	my $mark = "--sitar-mark-$now_string_g--";
	sysopen( STATUS, "$CMD_STATUS", O_RDONLY ) || die "can't open '$CMD_STATUS'";
	$pos[ 0 ] = 0;
	while ( <STATUS> ) { $pos[ $#pos + 1 ] = tell if /^$/; }
	for ( $i = 0 ; $i < $#pos ; $i++ ) {
		seek( STATUS, $pos[ $i ], seek_set ) || die "can't seek!";
		while ( <STATUS> ) { last if /^$/; $debs[ $i ] .= $_; }
	}
	close STATUS;
	for ( $i = 0 ; $i < $#debs + 1 ; $i++ ) {
		if ( $debs[ $i ] =~ /^Status:.* installed$/im ) {
			$debs[ $i ] =~ s/^Package:(.*)$(\n.*)*^Status:(.*)$(\n.*)*^Installed-Size:(.*)$(\n.*)*^Version:(.*)$(\n.*)*^Description:(.*)$(\n.*)*/$1$mark$3$mark$5$mark$7$mark$9/m;
			my ( $name, $status, $size, $version, $description ) = split( /$mark/, $debs[ $i ] );
			$total += $size;
			$num++;
			siprt( "tabrow" );
			siprtt( "cell",     $name );
			siprtt( "cell",     $status );
			siprtt( "cell",     $version );
			siprtt( "cell",     $size );
			siprtt( "cellwrap", $description );
			siprt( "endrow" );
		}
	}
	siprt( "tabrow" );
	siprtt( "tabhead", "Total" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", int( $total / 1024 ) . " MBytes" );
	siprtt( "tabhead", $num . " packets" );
	siprt( "endrow" );
	siprt( "endtab" );
}

sub si_installed_sles() {
	siprtt( "h1", "Installed Packages" );
	if ( -x $CMD_INSTSRC ) {
		siprtt( "h2", "Installation Sources" );
		siprt( "pre" );
		open( INSTSRC, "$CMD_INSTSRC -s |" );
		while ( <INSTSRC> ) {
			chomp();
			siprtt( "verb", "$_\n" );
		}
		close( INSTSRC );
		siprt( "endpre" );
	}
	my $total = 0;
	my $num   = 0;
	my @packagers;
	open( PACKS, "$CMD_RPM -qa --queryformat '%{DISTRIBUTION}::%{PACKAGER}\n' | $CMD_SORT | $CMD_UNIQ |" );
	while ( <PACKS> ) { push @packagers, $_; }
	close( PACKS );
	my @rpms;
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{VERSION}-%{RELEASE}::%{SIZE}::%{SUMMARY}::%{DISTRIBUTION}::%{PACKAGER}::a\n' |" );
	while ( <RPMS> ) { push @rpms, $_; }
	close( RPMS );
	for $pack ( sort @packagers ) {
		chomp $pack;
		my ( $mydist, $mypack ) = split /::/, $pack;
		chomp $mydist;
		chomp $mypack;
		# $mypack =~ s/\&/\&amp;/g;
		# $mypack =~ s/</\&lt;/g;
		# $mypack =~ s/>/\&gt;/g;
		if ( $mypack eq $ULPACK_RAW_NAME ) {
			siprtt( "h2", "$mydist" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mydist", 4 );
		} elsif ( $mypack eq $SUSEPACK_RAW_NAME ) {
			siprtt( "h2", "$mydist" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mydist", 4 );
		} elsif ( $mydist eq "(none)" ) {
			siprtt( "h2", "Packages by $mypack" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mypack", 4 );
		} else {
			siprtt( "h2", "$mydist ($mypack)" );
			siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: $mydist ($mypack)", 4 );
		}
		siprt( "tabrow" );
		siprtt( "tabhead", "Name" );
		siprtt( "tabhead", "Version" );
		siprtt( "tabhead", "Size" );
		siprtt( "tabhead", "Short Description" );
		siprt( "endrow" );
		my $packtotal = 0;
		my $packnum   = 0;
		for $rpm ( sort @rpms ) {
			my ( $name, $ver, $size, $summary, $distrib, $packager, $aa ) = split /::/, $rpm;
			#	print STDERR "|$rpm|\n\t\t"."|$pack|"."\n\t\t\t".$distrib."::".$packager."\n";
			if ( ( $pack ) eq ( $distrib . "::" . $packager ) ) {
				$total += $size;
				$num++;
				$packtotal += $size;
				$packnum++;
				siprt( "tabrow" );
				siprtt( "cell",     $name );
				siprtt( "cell",     $ver );
				siprtt( "cell",     $size );
				siprtt( "cellwrap", $summary );
				siprt( "endrow" );
			}
		}
		siprt( "tabrow" );
		siprtt( "tabhead", "Total" );
		siprtt( "tabhead", "" );
		siprtt( "tabhead", int( $packtotal / 1024 ) . " KBytes" );
		siprtt( "tabhead", $packnum . " packets" );
		siprt( "endrow" );
		siprt( "endtab" );
	}
	siprtt( "h2", "Summary" );
	siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages: Summary", 4 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Total" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", int( $total / 1024 ) . " KBytes" );
	siprtt( "tabhead", $num . " packets" );
	siprt( "endrow" );
	siprt( "endtab" );
}

sub si_installed_rpm() {
	siprtt( "h1", "Installed Packages" );
	siprtttt( "tabborder", "lllp{.5\\textwidth}", "Installed Packages", 4 );
	siprt( "tabrow" );
	siprtt( "tabhead", "Name" );
	siprtt( "tabhead", "Version" );
	siprtt( "tabhead", "Size" );
	siprtt( "tabhead", "Short Description" );
	siprt( "endrow" );
	my $total = 0;
	my $num   = 0;
	my @rpms;
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{VERSION}::%{SIZE}::%{SUMMARY}\n' |" );
	while ( <RPMS> ) { push @rpms, $_; }
	close( RPMS );
	for $rpm ( sort @rpms ) {
		my ( $name, $ver, $size, $summary ) = split /::/, $rpm;
		$total += $size;
		$num++;
		siprt( "tabrow" );
		siprtt( "cell",     $name );
		siprtt( "cell",     $ver );
		siprtt( "cell",     $size );
		siprtt( "cellwrap", $summary );
		siprt( "endrow" );
	}
	close( RPMS );
	siprt( "tabrow" );
	siprtt( "tabhead", "Total" );
	siprtt( "tabhead", "" );
	siprtt( "tabhead", int( $total / 1024 ) . " KBytes" );
	siprtt( "tabhead", $num . " packets" );
	siprt( "endrow" );
	siprt( "endtab" );
}

sub si_selection_deb() {
	my $deb_sel = "sitar-$HOSTNAME-deb-selections";
	sysopen( DEBSEL, "$deb_sel", O_CREAT | O_EXCL | O_WRONLY ) || die "can't create '$deb_sel'!";
	open( IN, "$CMD_DPKG --get-selections |" );
	while ( <IN> ) {
		print DEBSEL $_;
	}
	close IN;
	close DEBSEL;
}

sub si_selection_rpm() {
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{SIZE}\n' |" );
	my $total = 0;
	my $num   = 0;
	my @rpms  = ();
	while ( <RPMS> ) {
		my ( $name, $size ) = split /::/;
		push @rpms, $name;
		$total += $size;
		$num++;
	}
	close( RPMS );
	print "\# SuSE-Linux Configuration : ", int( $total / 1024 ), " : ", $num, "\n", "Description: $HOSTNAME $now_string_g\n", "Info:\n", "Ofni:\n", "Toinstall:\n";
	for $rr ( sort @rpms ) { print $rr, "\n"; }
	print "Llatsniot:\n";
}

sub si_selection_yast2( ) {
	my %total = ( ul => 0, sles => 0, addon => 0, suse => 0 );
	my %num   = ( ul => 0, sles => 0, addon => 0, suse => 0 );
	my %rpms = ( ul => (), sles => (), addon => (), suse => () );
	my %ords = ( ul => 1, sles => 2, addon => 4, suse => 3 );
	my @alltypes = qw ( addon sles suse ul );
	open( RPMS, "$CMD_RPM -qa --queryformat '%{NAME}::%{SIZE}::%{PACKAGER}::%{DISTRIBUTION}\n' |" );
	while ( <RPMS> ) {
		my ( $name, $size, $mypack, $distri ) = split /::/;
		chomp $mypack;
		chomp $distri;
		if ( $mypack eq $ULPACK_RAW_NAME ) {
			push @{ $rpms{ 'ul' } }, $name;
			$total{ 'ul' } += $size;
			$num{ 'ul' }++;
		} elsif ( $mypack eq $SUSEPACK_RAW_NAME ) {
			if ( $distri =~ "SLES" ) {
				push @{ $rpms{ 'sles' } }, $name;
				$total{ 'sles' } += $size;
				$num{ 'sles' }++;
			} else {
				push @{ $rpms{ 'suse' } }, $name;
				$total{ 'suse' } += $size;
				$num{ 'suse' }++;
			}
		} else {
			push @{ $rpms{ 'addon' } }, $name;
			$total{ 'addon' } += $size;
			$num{ 'addon' }++;
		}
	}
	close( RPMS );
	foreach $mytype ( @alltypes ) {
		if ( $num{ $mytype } > 0 ) {
			$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$mytype-$HOSTNAME-yast2.sel";
			if ( $SITAR_OPT_OUTFILE ne "" ) {
				open( STDOUT, ">$SITAR_OPT_OUTFILE" );
			}
			print "\# SuSE Linux Package Selection 3.0 (c) 2002 SUSE LINUX AG\n";
			print "\# generated on ", $now_string_g, " by SITAR ", $SITAR_RELEASE, "\n\n";
			print "=Ver: 3.0\n\n";
			print "=Sel: ", $mytype, "-sitar-", $HOSTNAME, " ", $SITAR_RELEASE, "\n\n";
			print "=Siz: ", $total{ $mytype }, " ", $total{ $mytype }, "\n\n";
			print "=Sum: ",    $mytype, " selection of '", $HOSTNAME, "'; by SITAR on ", $now_string_g, "\n";
			print "=Sum.de: ", $mytype, " Auswahl für '", $HOSTNAME, "'; SITAR am ",    $now_string_g, "\n";
			my @alllanguages = qw ( cs el_GR en es fr gl hu it ja lt nl pt pt_BR sl_SI sv tr);
			foreach $ll ( sort @alllanguages ) {
				print "=Sum.", $ll, ": SITAR '", $HOSTNAME, "', ", $now_string_g, "\n";
			}
			if ( $mytype eq "ul" ) {
				print "\n=Cat: baseconf\n\n";
			} else {
				print "\n=Cat: addon\n\n";
			}
			print "=Ord: 01", $ords{ $mytype }, "\n\n";
			print "=Vis: true\n\n";
			print "+Ins:\n";
			for $rr ( sort @{ $rpms{ $mytype } } ) { print $rr, "\n"; }
			print "-Ins:\n\n";
		}
	}
}

sub si_getopts($) {
}

sub si_check_consistency($$$) {
	chomp( my ( $consconfdir, $consfile, $consdebug ) = @_ );
	my %configfiles = ();
	if ( !$consdebug ) {
		open( SAVEERR, ">&STDERR" );
		open( STDERR,  ">/dev/null" );
	}
	open( CONFIGFILES, "$CMD_RPM -qca |" );
	while ( <CONFIGFILES> ) {
		chomp();
		my $ccc = $_;
		if ( $ccc =~ /^\// ) {
			open( ONERPM, "$CMD_RPM -Vf --nodeps --noscript $ccc |" );
			while ( <ONERPM> ) {
				chomp();
				if ( $_ && ( $_ !~ /^missing/ ) ) {
					$ddd = substr( $_, index( $_, "/" ) );
					if ( $ddd eq $ccc ) {
						$configfiles{ $ddd } = 1;
					}
				}
			}
			close( ONERPM );
		}
	}
	close( CONFIGFILES );
	if ( !-d "$consconfdir" ) {
		mkdir $consconfdir;
	}
	open( CONSISTENCY, ">$consconfdir/$consfile" );
	print CONSISTENCY "\n\@files = (\n";
	foreach my $kkk ( sort keys %configfiles ) {
		print CONSISTENCY "\"", $kkk, "\",\n";
	}
	print CONSISTENCY ");\n\n";
	close( CONSISTENCY );
	if ( !$consdebug ) {
		open( STDERR, ">&SAVEERR" );
	}
}

sub si_find_unpacked($$$$) {
	chomp( my ( $funpconfdir, $funpfile, $ddd, $ignore_binary ) = @_ );
	my %configfiles = ();
	for $NN ( `$CMD_FIND $ddd -type f` ) {
		chomp $NN;
		chomp( my $res = `$CMD_RPM -qf $NN` );
		if ( $res =~ /is not owned by any package$/ ) {
			if ( ( $NN !~ /~$/ ) && ( -r $NN ) ) {
				chomp( $type = `$CMD_FILE -p -b $NN` );
				if ( $ignore_binary && ( ( $type =~ /^Berkeley DB/ ) || ( $type =~ /data/ ) ) ) {
					si_debug( sprintf "---\t", $type, "\t", $NN );
				} else {
					si_debug( sprintf "\t", $type, "\t", $NN );
					$configfiles{ $NN } = 1;
				}
			}
		}
	}
	if ( !-d "$funpconfdir" ) {
		mkdir $funpconfdir;
	}
	open( FINDUNPACKED, ">$funpconfdir/$funpfile" );
	print FINDUNPACKED "\n\@files = (\n";
	foreach my $kkk ( sort keys %configfiles ) {
		print FINDUNPACKED "\"", $kkk, "\",\n";
	}
	print FINDUNPACKED ");\n\n";
	close( FINDUNPACKED );
}

sub si_print_version () {
	print "SITAR -\tSystem InformaTion At Runtime - Release ", $SITAR_RELEASE, "-", $SITAR_SVNVERSION, "\nCopyright (C) ", $SITAR_COPYRIGHT, "\n";
}

sub si_print_help () {
	print "Options available:
\t--format=<format>\tFormats: html, tex, sdocbook, yast1, yast2
\t--outfile=<file|dir>\toutput filename (without: stdout)
\t\t\t\tfor format 'yast2' outfile must be a directory
\t--check-consistency
\t--find-unpacked
\t--help\t\t\tthis page
\t--version\t\tprintout SITAR version";
}

sub si_run_sitar() {
	$SITAR_OPT_FORMAT =~ tr/A-Z/a-z/;
	if ( $SITAR_OPT_FORMAT ne "yast2" ) {
		open( TESTFILE, ">$SITAR_OPT_OUTFILE" )
		  || die "ERROR:\tThe output-file:\n\t$SITAR_OPT_OUTFILE\n\tcan not be opened for writing. Probably the parent-directory\n\tdoes not exist. - Exiting ...";
		close( TESTFILE );
	}
	if ( $SITAR_OPT_FORMAT eq "html" || $SITAR_OPT_FORMAT eq "tex" || $SITAR_OPT_FORMAT eq "sdocbook" ) {
		open( SAVEOUT, ">&STDOUT" );
		if ( $SITAR_OPT_OUTFILE ne "" ) {
			open( STDOUT, ">$SITAR_OPT_OUTFILE" );
		}
		siprt( "header" );
		si_general_sys();
		si_cpuinfo();
		si_proc_kernel();
		si_lsdev();
		si_pci();
		si_pnp();
		if ( $mm eq "tex" ) {
			print "\n\\par\\begingroup\\tiny\\par\n";
		}
		# si_df();
		si_software_raid();
		si_mount();
		si_ide();
		si_scsi();
		si_gdth();
		si_ips();
		si_compaq_smart();
		si_dac960();
		si_ifconfig();
		si_route();
		si_packetfilter();
		if ( $mm eq "tex" ) {
			print "\n\\par\\endgroup\\par\n";
		}
		si_immunix_apparmor();
		si_proc();
		if ( $DIST_DISTRIBUTION eq "unitedlinux" ) {
			si_chkconfig();
			si_etc();
			si_etc_united();
			si_installed_sles();
			si_proc_config();
		} elsif ( $DIST_DISTRIBUTION eq "suse" || $DIST_DISTRIBUTION eq "sles" ) {
			si_chkconfig();
			si_etc();
			si_etc_united();
			si_etc_suse();
			si_installed_sles();
			si_proc_config();
		} elsif ( $DIST_DISTRIBUTION eq "redhat" ) {
			si_chkconfig();
			si_etc();
			si_etc_redhat();
			si_installed_rpm();
		} elsif ( $DIST_DISTRIBUTION eq "debian" ) {
			si_etc();
			si_etc_debian();
			si_installed_deb();
			si_kernel_config();
			#si_selection_deb ();
		} else {
			si_etc();
		}
		siprt( "toc" );
		siprt( "body" );
		siprt( "footer" );
		open( STDOUT, ">&SAVEOUT" );
	} elsif ( $SITAR_OPT_FORMAT eq "yast1" ) {
		open( SAVEOUT, ">&STDOUT" );
		if ( $SITAR_OPT_OUTFILE ne "" ) {
			open( STDOUT, ">$SITAR_OPT_OUTFILE" );
		}
		si_selection_rpm();
		open( STDOUT, ">&SAVEOUT" );
	} elsif ( $SITAR_OPT_FORMAT eq "yast2" ) {
		open( SAVEOUT, ">&STDOUT" );
		si_selection_yast2();
		open( STDOUT, ">&SAVEOUT" );
	} elsif ( $SITAR_OPT_FORMAT eq "pci" ) {
		# open (STDOUT,  ">/tmp/sitar-$HOSTNAME.pci");
		# si_lspci();
		# open (STDOUT,  ">&SAVEOUT");
		# print "\t/tmp/sitar-$HOSTNAME.pci\n";
	}
}
