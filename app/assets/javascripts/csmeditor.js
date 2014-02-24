(function( window, $, undefined ) {
	var self 	 = null,
		initText = null,
		formName = null;

	defaults = {
		"width" : 'auto',
		"height": 400,
		"btns"	: [
			"bold",
			"italic",
			"underline",
			"link",
			"unordered list",
			"ordered list",
			"image",
			"align left",
			"align center",
			"align right"
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

			self.CSMEditor( "_buildToolBar" )
				.CSMEditor( "_addEventListeners" )
				.CSMEditor( "_setCaretEl", self );
		},

		insertList: function( isOrdered ) {
			var listType = ( isOrdered ) ? "ol" : "ul",
				list 	 = $( document.createElement( listType )),
				listItem = $( document.createElement( "li" ));

			self.append( list ).append( listItem );

			return self;
		},

		_exec: function( action, content ) {
			document.execCommand( action, false, content );
		},

		_btnActive: function( btn ) {
			var btnClass = "btn-active";
			if( btn.hasClass( btnClass )) {
				btn.removeClass( btnClass );
			} else {
				btn.addClass( btnClass );
			}
		},

		_buildToolBar: function( ) {
			var el = $( document.createElement( "div" )).addClass( "btn-group" ).attr( "id", "csmeditor-toolbar" );

			$.each( defaults.btns, function( index, btnVal ) {
				var validBtn = true,
					btn  	 = $( document.createElement( "button" )).addClass( "btn btn-primary" ).attr( "type", "button" ),
					icon 	 = $( document.createElement( "span" )).addClass( "glyphicon" ).attr( "title", btnVal );

				switch( btnVal ) { // welp I have those bad-practice tingles writing this
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
					case "unordered list" :
						icon.addClass( "glyphicon-list" );
					break;
					case "ordered list" :
						icon.addClass( "glyphicon-list-alt" );
					break
					case "image" :
						icon.addClass( "glyphicon-picture" );
					break;
					case "align left" :
						icon.addClass( "glyphicon-align-left" );
					break;
					case "align center" :
						icon.addClass( "glyphicon-align-center" );
					break;
					case "align right" :
						icon.addClass( "glyphicon-align-right" );
					break;
					default:
						validBtn = false;
				}

				if( validBtn ) btn.append( icon ).appendTo( el );
			});
			el.insertBefore( self );
		},

		_addEventListeners: function( ) {
			self.keydown( function( e ) {
			    // trap the return key being pressed
			    if( ! e.shiftKey && e.which == 13 ) {
				    self.find( "div" ).replaceWith( function( ) {
					    return $( document.createElement( "p" )).html( $( this ).html( ));
					});   
			    }
			});

			$( "#csmeditor-toolbar button.btn" ).click( function( e ) {
				var index = $( this ).index( );
				
				switch( index ) { // goddamn more worrying switch statements
					case 0:
						self.CSMEditor( "_exec", "bold" );
					break;
					case 1:
						self.CSMEditor( "_exec", "italic" );
					break;
					case 2:
						self.CSMEditor( "_exec", "underline" );
					break;
					case 4:
						self.CSMEditor( "insertList", false );
					break;
				}
			});

			$( "form" ).submit( function( ) {
				$( document.createElement( "input" )).attr({ "type" : "hidden", "name" : formName, "value" : self.html( ) }).appendTo( $( this ));
			});
		},

		// solution provided by Tim Down @ StackOverflow http://stackoverflow.com/questions/4233265/
		// edited for plugin compatibility

		_setCaretEl: function( el ) {
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