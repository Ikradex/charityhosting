$( function( ) {
	var btn       = $( "#num-verify-btn" ),
		statusBox = $( "#verify-status" );

	var progressBar = statusBox.html( );

	var statusClass;
	var statusMsg = $( document.createElement( "p" ));
	var possibleErrorList;

	var revenueLink = "<a href=\"http://www.revenue.ie/en/business/authorised-charities-resident.html\" target=\"_blank\">www.revenue.ie</a>";

	var typingTimer,
		typingInterval = 2000,
		domainInp = $( "#request_domain" );

	init( );

	function init( ) {
		$( ":radio" ).radio( );
		$( ":radio:first" ).radio( "check" );

		$( "#step-selection a:first" ).tab( "show" );

		$( ".tab-content .tab-pane:first" ).addClass( "in active" );

		$( "#step-selection a" ).click( function( e ) {
			$( this ).tab( "show" );
			return false;
		});

		$( "#next-btn" ).click( function( ) {
			$( ".nav-tabs > li.active" ).next( "li" ).find( "a" ).trigger( "click" );
		});

		$( "#prev-btn" ).click( function( ) {
			$( ".nav-tabs > li.active" ).prev( "li" ).find( "a" ).trigger( "click" );
		});

		$( "form input.form-control" ).change( function( ) {
			var val = $( this ).val( ),
				validated = false;

			var classToRemove = "",
				classToAdd 	  = "",
				validClass	  = "validated";

			if( val.trim( ) == "" && $( this ).attr( "required" ) != "required" ) {
				validated = true;
				classToAdd = "has-success";
				classToRemove = "has-error has-warning";
			} else {
				var len = val.length,
					minAttr = $( this ).attr( "minlength" ),
					maxAttr = $( this ).attr( "maxlength" ),
					minLen  = ( typeof minAttr !== "undefined" && minAttr !== false ) ? minAttr : 0,
					maxLen = ( typeof maxAttr !== "undefined" && maxAttr !== false ) ? maxAttr : len;


				if( len >= minLen && len <= maxLen ) {
					validated = true;
					classToAdd = "has-success";
					classToRemove = "has-error";
				} else {
					classToAdd = "has-error";
					classToRemove = "has-success";
				}

				var counterpart = $( "#request-form" ).find( "#" + $( this ).attr( "id" ) + "_confirmation" );

				if( ! counterpart.length && $( this ).attr( "id" ).indexOf( "_confirmation" ) > 0 ) {
					counterpart = $( "#request-form" ).find( "#" + $( this ).attr( "id" ).replace( "_confirmation", "" ));
				}

				if( counterpart.length ) {
					if( counterpart.val( ) != "" ) {
						if( counterpart.val( ) == val ) {
							validated = true;
							classToAdd = "has-success";
							classToRemove = "has-error has-warning";
							validClass = "validated"
						} else {
							validated = false;
							classToAdd = "has-error";
							classToRemove = "has-success has-warning";
							validClass = "";
						}
					} else {
						validated = false;
						classToAdd = "has-warning";
						classToRemove = "has-success has-error";
						validClass = "";
					}

					counterpart.removeClass( "validated" ).addClass( validClass ).parent( ).removeClass( classToRemove ).addClass( classToAdd );
				}
			}

			if( validated ) {
				$( this ).addClass( "validated" ).parent( ).removeClass( classToRemove ).addClass( classToAdd );
			} else {
				$( this ).removeClass( "validated" ).parent( ).removeClass( classToRemove ).addClass( classToAdd );
			}

			updateProgress( );
		});

		$( "#request_org_name" ).on( "keyup change", function( ) {
			var regex = /\bthe\b|\band\b|\bor\b|\bof\b|\ba\b|&/ig;
			domainInp.val( $( this ).val( ).replace( regex, "" ).replace( /\s/g, "" ).toLowerCase( ))
				.parent( ).removeClass( ).addClass( "form-group" );

			clearTimeout( typingTimer );
			typingTimer = setTimeout( triggerDomainInputChange, typingInterval );
		});

		$( "#request_org_name" ).on( "keydown keypress", function( ) {
			clearTimeout( typingTimer );
		});

		$( "#num-verify-btn" ).click( function( ) {
			if( $( "#request_charity_number" ).val( ).trim( ) !== "" ) {
				statusBox.removeClass( ).addClass( "show" ).html( progressBar );
				$.ajax({
					url: "charities/verify",
				  	data: "charity_number=" + $( "#request_charity_number" ).val( )
				}).done( function( resp ) {
					statusBox.addClass( "show-full" );

					switch( resp.status ) {
						case "okay":
							verifySuccess( resp );
						break;
						case "no-list":
							verifyWarning( );
						break;
						case "taken":
							verifyTaken( resp )
						break;
						default:
							verifyError( resp, resp.error );
						break
					}

					changeInputStatus( );

				}).error( function( xhr, textStatus, errorThrown ) {
					statusBox.addClass( "show-full" );
					ajaxError( xhr, errorThrown );
					changeInputStatus( );
				});
			}
		});

		$( "#request_domain" ).off( "change" ).on( "change", function( ) {
			var that = $( this ),
				classes = "form-group ",
				domain = that.val( );			

			$.ajax({
				url: "charities/domain_check",
			  	data: "domain=" + domain
			}).done( function( resp ) {
				if( resp.status == "okay" && resp.rows == 0 ) {
					classes += "has-success";
				} else {
					classes += "has-error";
				}

				that.parent( ).removeClass( ).addClass( classes );
			}).error( function( xhr, textStatus, errorThrown ) {
				// handle error
			});
		});
	}

	function updateProgress( ) {
		var completedInputs = 0;
		var percentageComplete = 0;

		$( "form input[type=\"text\"].form-control" ).each( function( ) {
			if( $( this ).hasClass( "validated" )) {
				completedInputs++;
		  	}
		});

		percentageComplete = ( completedInputs / $( "form input.form-control" ).length * 100 );

		$( "#pb" ).css({ "width" : percentageComplete - 1 + "%" });
	}

	function triggerDomainInputChange( ) {
		if( domainInp.val( ).length > 3 ) {
			domainInp.trigger( "change" );
		}
	}

	function verifySuccess( resp ) {
		$( "#request_charity_number_verified" ).val( "true" );

		statusClass = "success"; 
		statusMsg.html( "<span class=\"help-block\">Success! Our system recognises this as a valid charity.</span>" );

		var infoTable = $( "<table class=\"table\"><thead><tr><th>#</th><th>Charity</th><th>Address</th></tr></thead>" );
		infoTable.append( "<tbody><tr><td>" + resp.id + "</td><td>" + resp.org_name + "</td><td>" + resp.address + "</td></tr></tbody></table>" ).appendTo( statusMsg );

		$( "<small><em>According to Authorised Resident Charities " + revenueLink + "</em></small>" ).appendTo( statusMsg );

		$( "#request_org_name" ).val( resp.org_name ).trigger( "change" );
		$( "#request_org_address" ).val( resp.address ).trigger( "change" );
	}

	function verifyWarning( ) {
		statusClass = "warning";
		statusMsg.html( "<span class=\"help-block\">Oh dear. It seems we cannot verify your charity number. You may continue but we will need to double-check the number before approving your request.</span></br>" )
				 .append( "<strong>Here are some possible explanations for this: </strong>" );

		possibleErrorList = $( document.createElement( "ul" ))
		.append( $( "<li>The charity number was entered incorrectly. You typed: <strong>" + $( "#request_charity_number" ).val( ) + ".</strong></li>" ))
		.append( $( "<li>The ID on " + revenueLink + " was entered incorrectly.</li>" )).appendTo( statusMsg );

		$( "#request_org_name, #request_org_address" ).val( "" ).trigger( "change" );
	}

	function verifyTaken( resp ) {
		statusClass = "error";
		statusMsg.html( "<span class=\"help-block\">The charity <strong>&ldquo;" + resp.org_name + "&rdquo;</strong> exists however it has already been registered on our system.</span><strong>If you believe this is in error or have an issue please contact the <a href=\"mailto:admin@charityhosting.ie?Subject=Issue:%20Charity%20number%20verification\">system administrator.</strong>" )
	
		$( "#request_org_name, #request_org_address" ).val( "" ).trigger( "change" );
	}

	function verifyError( xhr, errorThrown ) {
		statusClass = "error";
		statusMsg.html( "<span class=\"help-block\"><em>Ouch!</em> Something went wrong that prevented us from verifying your charity.</span><br />" )
			.append( "<strong>Here are some of the possible reasons why this happened: " );

		possibleErrorList = $( document.createElement( "ul" ))
			.append( $( "<li>Your internet connection may be down.</li>" ))
		  	.append( $( "<li>" + revenueLink + " may be down.</li>" ))
		  	.append( $( "<li>An internal error on our part. <em>Whoops!</em></li>" ))
		  	.append( $( "<li>If none of the above, these are the error details: <code>" + xhr.status + ": " + errorThrown + "</code></li>" )).appendTo( statusMsg );

		$( "<p>No worries, continue filling out the form and our system administrator will verify the charity number manually.</p>" ).appendTo( statusMsg );
	}

	function changeInputStatus( ) {
		$( "#request_charity_number" ).parent( ).removeClass( ).addClass( "form-group has-" + statusClass );
		statusBox.html( statusMsg ).addClass( "show " + statusClass );
	}
});