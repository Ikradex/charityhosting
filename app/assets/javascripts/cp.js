var ready = function( ) {
    var s = $( "#admin-panel" );
    if( s.length ) {
        var pos = s.position( );
        var height = s.height( );               
        $( window ).scroll( function( ) {
            var windowpos = $( window ).scrollTop( );
            if( windowpos >= pos.top + height ) {
                s.addClass( "fixed" );
            } else {
                s.removeClass( "fixed" );
            }
        });
    }
}

// this is a turbolinks fix as the ready event is not called on ajax requests
$( document ).ready( ready );
$( document ).on( 'page:load', ready );