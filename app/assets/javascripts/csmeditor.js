(function( window, $, undefined ) {
	var self 	 = null,
		initText = null,
		formName = null;

	defaults = {
		"width" : 'auto',
		"height": 400,
		"btns"	: [
			"header",
			"font-size",
			"bold",
			"italic",
			"underline",
			"link",
			"unordered-list",
			"ordered-list",
			"align-left",
			"align-center",
			"align-right"
		]
	},

	methods = {
		init: function( config ) {
			self 	 = $( this );
			formName = self.attr( "name" );
			initText = "Write your content here!"; 

			if( config ) defaults = $.extend( defaults, config );

			self.removeClass( );

			var editorDiv = $( document.createElement( "div" ));
			
			editorDiv.attr( "contenteditable", true )
				.addClass( "csmeditor editor content" )
			
			if( $.trim( self.val( )) == "" ) {
				editorDiv.html( "<h1>" + initText + "</h1>" );
			} else {
				editorDiv.html( self.val( ))
			}

			editorDiv.css({
				"position"	: "relative",
				"width" 	: defaults.width,
				"min-height": defaults.height
			});

			self.replaceWith( editorDiv );
			self = editorDiv;

			self.CSMEditor( "buildToolBar" )
				.CSMEditor( "addEventListeners" )
				.CSMEditor( "setCaretEl", self );
		},

		exec: function( action, content ) {
			document.execCommand( action, false, content );
		},

		btnActive: function( btn ) {
			var btnClass = "btn-active";
			if( btn.hasClass( btnClass )) {
				btn.removeClass( btnClass );
			} else {
				btn.addClass( btnClass );
			}
		},

		buildToolBar: function( ) {
			var el = $( document.createElement( "div" )).addClass( "btn-group" ).attr( "id", "csmeditor-toolbar" );

			$.each( defaults.btns, function( index, btnVal ) {
				var validBtn = true,
					btn  	 = $( document.createElement( "button" )).addClass( "btn btn-primary" ).attr( "type", "button" ),
					icon 	 = $( document.createElement( "span" )).addClass( "glyphicon" ).attr( "title", btnVal );

				switch( btnVal ) { // welp I have those bad-practice tingles writing this
					case "header":
						btn.html( "<span class=\"glyphicon glyphicon-header\"></span>" )
							.addClass( "dropdown-toggle" )
							.attr( "data-toggle", "dropdown" )
							.append( $( "<span class=\"caret\"></span>" ))
						icon = null;
						btn = $( document.createElement( "div" )).addClass( "btn-group" )
							.append( btn );

						var dropdown = $( document.createElement( "ul" )).addClass( "dropdown-menu" );
							
						for( var i = 1; i <= 6; i++ ) {
							var li = $( "<li><a href=\"javascript:void(0)\">H" + i + "</a></li>" );
							li.click( function( ) {
								self.CSMEditor( "exec", "formatBlock", "<H" + ( $( this ).index( ) + 1 ) + ">" );
							});
							li.appendTo( dropdown );
						}

						btn.append( dropdown ).appendTo( el );
					break;
					case "font-size" :
						btn.html( "<span class=\"glyphicon glyphicon-text-height\"></span>" )
							.addClass( "dropdown-toggle" )
							.attr( "data-toggle", "dropdown" )
							.append( $( "<span class=\"caret\"></span>" ));
						icon = null;
						btn = $( document.createElement( "div" )).addClass( "btn-group" )
							.append( btn );

						var dropdown = $( document.createElement( "ul" )).addClass( "dropdown-menu" );
							
						for( var i = 1; i <= 7; i++ ) {
							var li = $( "<li><a href=\"javascript:void(0)\"><font size=\"" + i + "\">Some text.</font></a></li>" );
							li.click( function( ) {
								self.CSMEditor( "exec", "fontSize", $( this ).index( ) + 1 );
							});
							li.appendTo( dropdown );
						}

						btn.append( dropdown ).appendTo( el );
					break;
					case "bold" :
						icon.html( $( "<strong>B</strong>" ));
					break;
					case "italic" :
						icon.addClass( "glyphicon-italic" );
					break;
					case "underline" :
						icon.html( $( "<u>U</u>" ));
					break;
					case "link" :
						icon.addClass( "glyphicon-link" );
					break;
					case "unordered-list" :
						icon.addClass( "glyphicon-list" );
					break;
					case "ordered-list" :
						icon.addClass( "glyphicon-list-alt" );
					break
					case "image" :
						icon.addClass( "glyphicon-picture" );
					break;
					case "align-left" :
						icon.addClass( "glyphicon-align-left" );
					break;
					case "align-center" :
						icon.addClass( "glyphicon-align-center" );
					break;
					case "align-right" :
						icon.addClass( "glyphicon-align-right" );
					break;
					default:
						validBtn = false;
				}

				if( validBtn ) btn.append( icon ).appendTo( el );
			});
			el.insertBefore( self );
		},

		

		addEventListeners: function( ) {
			self.keydown( function( e ) {
			    // trap the return key being pressed
			    if( ! e.shiftKey && e.which == 13 ) {
			    	e.preventDefault( );
				    $( this ).CSMEditor( "exec", "insertParagraph" );
			    }
			});

			$( "#csmeditor-toolbar button.btn" ).click( function( e ) {
				var index = $( this ).index( );
				
				switch( index ) { // goddamn more worrying switch statements
					case 1:
						self.CSMEditor( "exec", "bold" );
					break;
					case 2:
						self.CSMEditor( "exec", "italic" );
					break;
					case 3:
						self.CSMEditor( "exec", "underline" );
					break;
					case 5:
						self.CSMEditor( "exec", "insertUnorderedList" );  
					break;
					case 6:
						self.CSMEditor( "exec", "insertOrderedList" );
					break;
					case 8: 
						self.CSMEditor( "exec", "justifyLeft" );
					break;
					case 9:
						self.CSMEditor( "exec", "justifyCenter" );
					break;
					case 10:
						self.CSMEditor( "exec", "justifyRight" );
					break;
				}
			});

			$( "form" ).submit( function( ) {
				//self.CSMEditor( "validateInput" );
				$( document.createElement( "input" )).attr({ "type" : "hidden", "name" : formName, "value" : self.html( ) }).appendTo( $( this ));
			});
		},

		validateInput: function( ) {
			self.find( "div" ).replaceWith( function( ) {
			    return $( document.createElement( "p" )).html( $( this ).html( ));
			});
		},

		// solution provided by Tim Down @ StackOverflow http://stackoverflow.com/questions/4233265/
		// edited for plugin compatibility

		setCaretEl: function( el ) {
			var that = el.get( 0 );
			that.focus( );

			if( typeof window.getSelection != "undefined" && typeof document.createRange != "undefined" ) {
				var range = document.createRange( );
				range.selectNodeContents( that );
				range.collapse( false );

				var sel = window.getSelection( );
				sel.removeAllRanges( );
				sel.addRange( range );
			} else if( typeof document.body.createTextRange != "undefined" ) {
				var textRange = document.body.createTextRange( );
				textRange.moveToElementText( that );
				textRange.collapse( false );
				textRange.select( );
			}

			return that;
		}
	};

	$.fn.CSMEditor = function( method ) {
        var args  = arguments,
            $this = this;

        return this.each( function( ) {
            if( methods[ method ] ) {
                return methods[ method ].apply( $this, Array.prototype.slice.call( args, 1 ));
            } else if( typeof method === 'object' || ! method ) {
                return methods.init.apply( $this, Array.prototype.slice.call( args, 0 ) );
            } else {
                $.error( 'Method ' +  method + ' does not exist on jQuery.plugin' );
            }  
        });
    }
})( window, jQuery );