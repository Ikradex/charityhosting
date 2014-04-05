var ready = function() {
  	$('#my-slideshow').bjqs({
        'height' : 450,
        'width' : 800,
        'responsive' : true,
        'automatic' : false,
        'showmarkers' : false,
        'keyboardnav' : true,
        'animtype' : 'slide'
    });
};
 
$(document).ready( ready );
$(document).on('page:load', ready);