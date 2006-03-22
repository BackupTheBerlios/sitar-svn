#
# si_readfile( filename )
#
sub si_readfile( $ ) {
        my ( $filename ) = shift( @_ );
	my $content;
	my $readsize;
	if( $SITAR_OPT_LIMIT > 0 ) { 
		$readsize = $SITAR_OPT_LIMIT;
	} else {
		$readsize = $SITAR_MAX_LIMIT;
	}
	if( -r $filename ) {
		if( open( $HANDLE , "< $filename" ) ) {
			read( $HANDLE, $content, $readsize );
			close( $HANDLE );
		}
	}
	return( $content );
}

=pod

# testing

{
	print "--- si_readfile ---\n";
	my $ttt=si_readfile( "/etc/passwd" );
	print $ttt;
	print "--- cat -----------\n";
	my $sss=` cat /etc/passwd`;
	print $sss;
	print "-------------------\n";
}

=cut

