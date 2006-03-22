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

