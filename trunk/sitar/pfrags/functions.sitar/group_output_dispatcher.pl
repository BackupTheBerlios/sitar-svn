#
# Table of contents and output
#
my %toc_seccnt_g         = ();
my %toc_subseccnt_g      = ();
my %toc_subsubseccnt_g   = ();
my %toc_last_toc_level_g = ();
my %toc_last_sec_level_g = ();
my %toc_buffer_g         = ();
my %output_is_verbatim_g = ();
my %output_buffer_g      = ();
my $output_format_g	 = "";

sub mysprint {
	# SLOW #
	$output_buffer_g{ $output_format_g } = join "", $output_buffer_g{ $output_format_g }, @_;

}

sub addtoc($$$) {
	my ( $level, $ancor, $value ) = @_;
	if ( $level > $toc_last_toc_level_g{ $output_format_g } ) {
		$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "<ul class=\"toc\">\n";
	} elsif ( $level < $toc_last_toc_level_g{ $output_format_g } ) {
		for ( $ll = $toc_last_toc_level_g{ $output_format_g } ; $ll > $level ; $ll-- ) {
			$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</li>\n</ul>\n\n";
		}
		$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</li>\n";
	} elsif ( $toc_last_toc_level_g{ $output_format_g } != 0 ) {
		$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</li>\n";
	} else {
	}
	$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "<li><a href=\"#", $ancor, "\">", $value, "</a>\n";
	$toc_last_toc_level_g{ $output_format_g } = $level;
}

sub addtoc_sdocbook($$$) {
	my ( $level, $ancor, $value ) = @_;
	if ( $level > $toc_last_toc_level_g{ $output_format_g } ) {
		$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "<itemizedlist>\n";
	} elsif ( $level < $toc_last_toc_level_g{ $output_format_g } ) {
		for ( $ll = $toc_last_toc_level_g{ $output_format_g } ; $ll > $level ; $ll-- ) {
			$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</listitem>\n</itemizedlist>\n\n";
		}
		$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</listitem>\n";
	} elsif ( $toc_last_toc_level_g{ $output_format_g } != 0 ) {
		$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</listitem>\n";
	} else {
	}
	$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "<listitem><para><xref linkend=\"sec$ancor\"/>$value</para>\n";
	$toc_last_toc_level_g{ $output_format_g } = $level;
}

sub siprint_single( $$$$ ) {
	my ( $m, $value, $attr, $colsnum ) = @_;
	if ( $output_format_g eq "html" ) {
		$value =~ s/\&/\&amp;/g;
		$value =~ s/</\&lt;/g;
		$value =~ s/>/\&gt;/g;
		if ( $m eq "h1" ) {
			$toc_seccnt_g{ $output_format_g }++;
			mysprint "<h1><a name=\"", $toc_seccnt_g{ $output_format_g }, "\"\n>", $toc_seccnt_g{ $output_format_g }, ".&nbsp;", $value, "</a></h1>";
			addtoc( 1, "$toc_seccnt_g{ $output_format_g }", "$toc_seccnt_g{ $output_format_g }.&nbsp;$value" );
			$toc_subseccnt_g{ $output_format_g } = 0;
		}
		if ( $m eq "h2" ) {
			$toc_subseccnt_g{ $output_format_g }++;
			mysprint "<h2><a name=\"", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, "\"\n>", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, "&nbsp;", $value, "</a></h2>";
			addtoc( 2, "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }", "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }&nbsp;$value" );
			$toc_subsubseccnt_g{ $output_format_g } = 0;
		}
		if ( $m eq "h3" ) {
			$toc_subsubseccnt_g{ $output_format_g }++;
			mysprint "<h3><a name=\"", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, ".", $toc_subsubseccnt_g{ $output_format_g }, "\"\n>", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, ".", $toc_subsubseccnt_g{ $output_format_g }, "&nbsp;", $value, "</a></h3>";
			addtoc( 3, "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }.$toc_subsubseccnt_g{ $output_format_g }", "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }.$toc_subsubseccnt_g{ $output_format_g }&nbsp;$value" );
		}
		if ( $m eq "tabborder" ) {
			mysprint "<table summary=\"", $attr, "\"\n border=\"1\">";
		}
		if ( $m eq "tab" )         { mysprint "<table summary=\"\"\n border=\"0\">"; }
		if ( $m eq "endtab" )      { mysprint "</table>\n"; }
		if ( $m eq "tabrow" )      { mysprint "<tr\n>"; }
		if ( $m eq "endrow" )      { mysprint "</tr>\n"; }
		if ( $m eq "pre" )         { mysprint "<pre>"; $output_is_verbatim_g{ $output_format_g } = 1; }
		if ( $m eq "endpre" )      { mysprint "</pre>\n"; $output_is_verbatim_g{ $output_format_g } = 0; }
		if ( $m eq "multipre" )    { mysprint "<pre>"; $output_is_verbatim_g{ $output_format_g } = 1; }
		if ( $m eq "endmultipre" ) { mysprint "</pre>\n"; $output_is_verbatim_g{ $output_format_g } = 0; }
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
			for ( $ii = $toc_last_toc_level_g{ $output_format_g } ; $ii > 0 ; $ii-- ) {
				$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</li>\n</ul>\n";
			}
			print "<h1>Table of Contents</h1>\n", $toc_buffer_g{ $output_format_g };
			print "\n<hr />\n";
		}
		if ( $m eq "body" )   { print $output_buffer_g{ $output_format_g }; }
		if ( $m eq "footer" ) { print $html_footer; }
	} elsif ( $output_format_g eq "tex" || $output_format_g eq "latex" ) {
		if ( $output_is_verbatim_g{ $output_format_g } == 0 ) {
			$value =~ s/\_/\\_/g;
			$value =~ s/\#/\\\#/g;
			$value =~ s/%/\\%/g;
			$value =~ s/\&/\\\&/g;
			$value =~ s/</\$<\$/g;
			$value =~ s/>/\$>\$/g;
		}
		## s/(\")(\w)/\"\`$2/g; s/(\w)(\")/$1\"\'/g; s/([.,;?!])(\")/$1\"\'/g;
		if ( $m eq "h1" ) { mysprint "\\section\{",       $value, "\}\n"; }
		if ( $m eq "h2" ) { mysprint "\\subsection\{",    $value, "\}\n"; }
		if ( $m eq "h3" ) { mysprint "\\subsubsection\{", $value, "\}\n"; }
		if ( $m eq "tabborder" ) {
			mysprint "\\begingroup\\tiny\\par", "\\noindent\\begin\{longtable\}[l]\{\@\{\}", $value, "l\@\{\}\}\n";
		}
		if ( $m eq "tab" ) {
			mysprint "\\begingroup\\tiny\\par", "\\noindent\\begin\{longtable\}[l]\{\@\{\}", $value, "l\@\{\}\}\n";
		}
		if ( $m eq "endtab" )   { mysprint "\\end\{longtable\}\\par\\endgroup\n"; }
		if ( $m eq "tabrow" )   { }
		if ( $m eq "endrow" )   { mysprint "\\\\\n"; }
		if ( $m eq "pre" )      { mysprint "\\begin\{verbatim\}"; $output_is_verbatim_g{ $output_format_g } = 1; }
		if ( $m eq "endpre" )   { mysprint "\\end\{verbatim\}\n"; $output_is_verbatim_g{ $output_format_g } = 0; }
		if ( $m eq "multipre" ) {
			mysprint "\n\\par\\begingroup\\tiny\\par\n";
			mysprint "\\begin\{multicols\}\{2\}\n\\begin\{verbatim\}\n";
			$output_is_verbatim_g{ $output_format_g } = 1;
		}
		if ( $m eq "endmultipre" ) {
			mysprint "\\end\{verbatim\}\n";
			mysprint "\\end\{multicols\}\\par\\endgroup\\par\n";
			$output_is_verbatim_g{ $output_format_g } = 0;
		}
		if ( $m eq "cellspan" )  { mysprint $value, "\&"; }
		if ( $m eq "emptycell" ) { mysprint "\&"; }
		if ( $m eq "cell" )      { mysprint $value, "\&"; }
		if ( $m eq "cellwrap" )  { mysprint $value, "\&"; }
		if ( $m eq "cellcolor" ) { mysprint $value, "\&"; }
		if ( $m eq "headcolor" ) { mysprint $value, "\&"; }
		if ( $m eq "tabhead" )   { mysprint $value, "\&"; }
		if ( $m eq "verb" )      { mysprint $value; }
		if ( $m eq "header" )    { print $tex_header; }
		if ( $m eq "body" )      { print $output_buffer_g{ $output_format_g }; }
		if ( $m eq "footer" )    { print $tex_footer; }
		if ( $m eq "toc" )       { ; }
	} elsif ( $output_format_g eq "sdocbook" ) {
		$value =~ s/\&/\&amp;/g;
		$value =~ s/</\&lt;/g;
		$value =~ s/>/\&gt;/g;
		$attr  =~ s/\&/\&amp;/g;
		$attr  =~ s/</\&lt;/g;
		$attr  =~ s/>/\&gt;/g;
		if ( $m eq "h1" ) {
			while ( $toc_last_sec_level_g{ $output_format_g } > 0 ) {
				mysprint "\n</section>\n";
				$toc_last_sec_level_g{ $output_format_g }--;
			}
			$toc_seccnt_g{ $output_format_g }++;
			mysprint "<section label=\"sec", $toc_seccnt_g{ $output_format_g }, "\" id=\"sec", $toc_seccnt_g{ $output_format_g }, "\"\n><title>", $value, "</title><para />\n";
			addtoc_sdocbook( 1, "$toc_seccnt_g{ $output_format_g }", "$toc_seccnt_g{ $output_format_g }.$value" );
			$toc_subseccnt_g{ $output_format_g }      = 0;
			$toc_last_sec_level_g{ $output_format_g } = 1;
		}
		if ( $m eq "h2" ) {
			while ( $toc_last_sec_level_g{ $output_format_g } > 1 ) {
				mysprint "\n</section>\n";
				$toc_last_sec_level_g{ $output_format_g }--;
			}
			$toc_subseccnt_g{ $output_format_g }++;
			mysprint "<section label=\"sec", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, "\" id=\"sec", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, "\"\n><title>", $value, "</title><para />\n";
			addtoc_sdocbook( 2, "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }", "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }&nbsp;$value" );
			$toc_subsubseccnt_g{ $output_format_g }   = 0;
			$toc_last_sec_level_g{ $output_format_g } = 2;
		}
		if ( $m eq "h3" ) {
			if ( $toc_last_sec_level_g{ $output_format_g } > 2 ) {
				mysprint "\n</section>\n";
			}
			$toc_subsubseccnt_g{ $output_format_g }++;
			mysprint "<section label=\"sec", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, ".", $toc_subsubseccnt_g{ $output_format_g }, "\" id=\"sec", $toc_seccnt_g{ $output_format_g }, ".", $toc_subseccnt_g{ $output_format_g }, ".", $toc_subsubseccnt_g{ $output_format_g }, "\"\n><title>", $value, "</title><para />\n";
			addtoc_sdocbook( 3, "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }.$toc_subsubseccnt_g{ $output_format_g }", "$toc_seccnt_g{ $output_format_g }.$toc_subseccnt_g{ $output_format_g }.$toc_subsubseccnt_g{ $output_format_g }&nbsp;$value" );
			$toc_last_sec_level_g{ $output_format_g } = 3;
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
			$output_is_verbatim_g{ $output_format_g } = 1;
		}
		if ( $m eq "endpre" ) {
			mysprint "\n]]>\n</programlisting>\n";
			$output_is_verbatim_g{ $output_format_g } = 0;
		}
		if ( $m eq "multipre" ) {
			mysprint "<programlisting>\n<![CDATA[\n";
			$output_is_verbatim_g{ $output_format_g } = 1;
		}
		if ( $m eq "endmultipre" ) {
			mysprint "\n]]>\n</programlisting>\n";
			$output_is_verbatim_g{ $output_format_g } = 0;
		}
		if ( $m eq "verb" )   { mysprint $value; }
		if ( $m eq "header" ) { print $sdocbook_header; }
		if ( $m eq "body" )   {
			while ( $toc_last_sec_level_g{ $output_format_g } > 0 ) {
				mysprint "\n</section>\n";
				$toc_last_sec_level_g{ $output_format_g }--;
			}
			print $output_buffer_g{ $output_format_g };
		}
		if ( $m eq "footer" ) { print $sdocbook_footer; }
		if ( $m eq "toc" )    {
			for ( $ii = $toc_last_toc_level_g{ $output_format_g } ; $ii > 0 ; $ii-- ) {
				$toc_buffer_g{ $output_format_g } = join "", $toc_buffer_g{ $output_format_g }, "</listitem>\n</itemizedlist>\n";
			}
			print "<section id=\"TOC\" label=\"TOC\"><title>Table of Contents</title><para />\n", $toc_buffer_g{ $output_format_g }, "</section>\n";
		}
	} elsif ( $output_format_g eq "sql" ) {
	}
}

sub siprint($$$$) {
	my ( $m, $value, $attr, $colsnum ) = @_;
	if( $SITAR_OPT_FORMAT eq "all" ) {
		for $ff ( @SITAR_STRUCTURED ) {
			$output_format_g = $ff;
			siprint_single( $m, $value, $attr, $colsnum );
		}
	} else {
		$output_format_g = $SITAR_OPT_FORMAT;
		siprint_single( $m, $value, $attr, $colsnum );
	}
}

sub siprt($) { my ( $t1 ) = shift( @_ ); siprint( $t1, "", "", 0 ); }
sub siprtt($$) { my ( $t1, $t2 ) = @_; siprint( $t1, $t2, "", 0 ); }
sub siprttt($$$) { my ( $t1, $t2, $t3 ) = @_; siprint( $t1, $t2, $t3, 0 ); }
sub siprtttt($$$$) { my ( $t1, $t2, $t3, $t4 ) = @_; siprint( $t1, $t2, $t3, $t4 ); }

sub si_shipout_single( ) {
	if ( $output_format_g eq "latex" ) {
		$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME.tex";
	} elsif ( $output_format_g eq "sdocbook" ) {
		$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME.sdocbook.xml";
	} else {
		$SITAR_OPT_OUTFILE = join "", $SITAR_OPT_OUTDIR, "/sitar-$HOSTNAME.$output_format_g";
	}
	open( SAVEOUT, ">&STDOUT" );
	print( STDERR "Generating $SITAR_OPT_OUTFILE...\n" );
	open( STDOUT, ">$SITAR_OPT_OUTFILE" );
	siprt( "header" );
	siprt( "toc" );
	siprt( "body" );
	siprt( "footer" );
	open( STDOUT, ">&SAVEOUT" );
}

sub si_shipout() {
	( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime( time );
	$SITAR_OPT_OUTDIR = join "", "/tmp/sitar-", $HOSTNAME, "-", $year + 1900, sprintf( "%02d", $mon + 1 ), sprintf( "%02d", $mday ), sprintf( "%02d", $hour );
	mkdir $SITAR_OPT_OUTDIR;
	chdir $SITAR_OPT_OUTDIR;
	if( $SITAR_OPT_FORMAT eq "all" ) {
		for $mm ( @SITAR_STRUCTURED ) {
			$output_format_g = $mm;
			si_shipout_single();
		}
	} else {
		$output_format_g = $SITAR_OPT_FORMAT;
		si_shipout_single( );
	}
	chdir $CWD;
}

sub si_output_start () {
	if( $SITAR_OPT_FORMAT eq "all" ) {
		for $mm ( @SITAR_STRUCTURED ) {
			$output_buffer_g{ $mm }            = "";
			$toc_buffer_g{ $mm }               = "";
			$toc_last_toc_level_g{ $mm }       = 0;
		}
	} else {
		$output_buffer_g{ $SITAR_OPT_FORMAT }      = "";
		$toc_buffer_g{ $SITAR_OPT_FORMAT }         = "";
		$toc_last_toc_level_g{ $SITAR_OPT_FORMAT } = 0;
	}
}

