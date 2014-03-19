var ready = function( ) {
	var $slider = $( "#slider" ), slider3ValueMultiplier = 1, donateAmount = 200;

	if( $slider.length > 0 ) {
	  	$slider.slider({
		    min: 1,
		    max: 50,
		    value: 2,
		    orientation: "horizontal",
		    range: "min",
		    slide: function( event, ui ) {
		    	var offset = $( ui.handle ).offset( );
		    	$slider.find( ".ui-slider-value:first" ).text( "€" + ui.value * slider3ValueMultiplier + ".00" );
		    	donateAmount = ui.value * 100;
			}
		});
	}
}

// this is a turbolinks fix as the ready event is not called on ajax requests
$( document ).ready( ready );
$( document ).on( 'page:load', ready );