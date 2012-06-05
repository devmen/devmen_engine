# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

`
$.fn.show1 = function(delay) {
  if (delay === undefined)
    delay = 500;
  $(this).stop(true, true).delay(delay).fadeIn();
};

$.fn.hide1 = function() {
  $(this).stop(true, true).hide();
}

$(document).ready(function() {
  $.markitup_init();

  // Show actions and info when page link has hovered
  $('#page_links').on('mouseenter mouseleave', '.page_link', function(event) {
    var current = $(this).hasClass('current') ? this : $(this).siblings('.current')[0];
    if (event.type == 'mouseenter') {
      if (current && this != current)
        $('.page_link_insider', current).hide1();
      $('.page_link_insider', this).show1();      
    } else if (!$(event.relatedTarget).closest(this).length) {
      if (!current || this != current)
        $('.page_link_insider', this).hide1();  
      if (current 
          && !$(event.relatedTarget).hasClass('page_link')
          && !$(event.relatedTarget).closest('.page_link').length
      )
        $('.page_link_insider', current).show1(0); 
    }
  });
});
`