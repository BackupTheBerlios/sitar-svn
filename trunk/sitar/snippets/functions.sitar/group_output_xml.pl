#
#	output-xml
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

