#
#	output-HTML
#
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

