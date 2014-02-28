$( function( ) {
	$( ":radio" ).radio( );

	$( "#step-selection a:first" ).tab( "show" );

	$( "#step-selection a" ).click( function( e ) {
		e.preventDefault( );
		$( this ).tab( "show" )
	});

	$( "form input.form-control" ).blur( function( ) {
		var completedInputs = 0;

		$( "form input.form-control" ).each( function( ) {
			if( $( this ).val( ) !== "" ) {
				completedInputs++;
		  	}
		});

		$( "#pb" ).css({ "width" : ( completedInputs / $( "form input.form-control" ).length * 100 ) - 1 + "%" })
	});

	$('#next-btn').click(function(){
		$('.nav-tabs > .active').next('li').find('a').trigger( 'click' )
	});
	$('#prev-btn').click(function(){
		$('.nav-tabs > .active').prev('li').find('a').trigger( 'click' )
	});

	var btn       = $( "#num-verify-btn" ),
		inp       = $( "#num-verify-inp" ),
		statusBox = $( "#verify-status" );

	var progressBar = statusBox.html( );

	var statusClass;
	var statusMsg = $( document.createElement( "p" ));
	var possibleErrorList;

	btn.click( function( ) {
		statusBox.removeClass( ).html( progressBar ).addClass( "show" );
		$.ajax({
			url: "charities/verify",
		  	data: "charity_number=" + inp.val( )
		}).done( function( resp ) {

			statusBox.removeClass( ).addClass( "show-full" );

		  	if( resp.status === "okay" ) {
				ajaxSuccess( resp );
			} else if( resp.status === "no-list" ) {
				ajaxWarning( );
		  	} else {
				ajaxError( );
		  	}

			changeInputStatus( );

		}).error( function( xhr, textStatus, errorThrown ) {

			statusBox.removeClass( ).addClass( "show-full" );

			ajaxError( xhr, errorThrown );

			changeInputStatus( );
		});
	});

	function ajaxSuccess( resp ) {
		$( "#num-verified-inp" ).val( "true" );

		statusClass = "success"; 
		statusMsg.html( "Success! Our system recognises this as a valid charity." );

		var infoTable = $( "<table class=\"table\"><thead><tr><th>#</th><th>Charity</th><th>Address</th></tr></thead>" );
		infoTable.append( "<tbody><tr><td>" + resp.id + "</td><td>" + resp.org_name + "</td><td>" + resp.address + "</td></tr></tbody></table>" ).appendTo( statusMsg );

		$( "<small><em>According to Authorised Resident Charities <a href=\"http://www.revenue.ie/en/business/authorised-charities-resident.html\" target=\"_blank\">www.revenue.ie</a></em></small>" ).appendTo( statusMsg );
	}

	function ajaxWarning( ) {
		statusClass = "warning";
		statusMsg.html( "Oh dear. It seems we cannot verify your charity number. You may continue but we will need to double-check the number before approving your request.</br><br />" )
				 .append( "<strong>Here are some possible explanations for this: </strong>" );

		possibleErrorList = $( document.createElement( "ul" ))
		.append( $( "<li>The charity number was entered incorrectly. You typed: <strong>" + inp.val( ) + ".</strong></li>" ))
		.append( $( "<li>The ID on <a href=\"http://www.revenue.ie/en/business/authorised-charities-resident.html\">www.revenue.ie</a> was entered incorrectly.</li>" )).appendTo( statusMsg );
	}

	function ajaxError( xhr, errorThrown ) {
		statusClass = "error";
		statusMsg.html( "<em>Ouch!</em> Something went wrong that prevented us from verifying your charity.<br /><br />" )
			.append( "<strong>Here are some of the possible reasons why this happened: " );

		possibleErrorList = $( document.createElement( "ul" ))
			.append( $( "<li>Your internet connection may be down.</li>" ))
		  	.append( $( "<li><a href=\"http://www.revenue.ie\">www.revenue.ie</a> may be down.</li>" ))
		  	.append( $( "<li>An internal error on our part. <em>Whoops!</em></li>" ))
		  	.append( $( "<li>If none of the above, these are the error details: <code>" + xhr.status + ": " + errorThrown + "</code></li>" )).appendTo( statusMsg );

		$( "<p>No worries, continue filling out the form and our system administrator will verify the charity number manually.</p>" ).appendTo( statusMsg );
	}

	function changeInputStatus( ) {
		inp.parent( ).removeClass( ).addClass( "form-group has-" + statusClass );
		statusBox.html( statusMsg ).addClass( "show " + statusClass );
	}
});