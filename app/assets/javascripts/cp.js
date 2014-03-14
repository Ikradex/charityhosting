$( document ).ready( function( ) {
    var s = $( "#admin-panel" ); // Replace #DIV_TO_BE_FIXED with the division you want to fix.
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
});