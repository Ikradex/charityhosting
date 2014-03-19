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

	var handler = StripeCheckout.configure({
		    key: 'pk_test_rcnc3BbcNcX0Q5NI1RQjofu0',
		    token: function( token, args ) {
		      // Use the token to create the charge with a server-side script.
		      // You can access the token ID with `token.id`

		      console.log( args )

		      $( "#donate_form" ).replaceWith( $( "<div class=\"well\"><h3 class=\"text-primary\">Thank you!</h3><span class=\"text-info\">Transaction successful.</span><p>Your donations keep these charities alive to further their cause and we thank you for your gift.</p></div>" ));
			}
		});

	$( "#donate_form" ).submit( function( e ) {
		handler.open({
	      name: "Charity Hosting",
	      description: "Donate €" + ( donateAmount / 100 ) + ".00 to " + $( "#charity_name" ).val( ),
	      currency: "EUR",
	      amount: ( $( "#custom_amount_field" ).val( ) != "" ) ? $( "#custom_amount_field" ).val( ) / 100 :  donateAmount
	    });

	    e.preventDefault( );
	});
}

// this is a turbolinks fix as the ready event is not called on ajax requests
$( document ).ready( ready );
$( document ).on( 'page:load', ready );