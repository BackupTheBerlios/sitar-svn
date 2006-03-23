#
# si_readfile( filename )
#
# read small(!) files below /proc, ...
#
sub si_readfile( $ ) {
        my ( $filename ) = shift( @_ );
	my $content;
	if( -r $filename ) {
		if( open( $HANDLE , "< $filename" ) ) {
			read( $HANDLE, $content, $SITAR_READFILE_LIMIT );
			close( $HANDLE );
		}
	}
	return( $content );
}

