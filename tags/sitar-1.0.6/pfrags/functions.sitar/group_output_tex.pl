#
#	output-TeX
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
