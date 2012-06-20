# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

`
$(document).ready(function() {
  $.markitup_init();

  // Show actions and info when page link has hovered
  $('#page_links').on('mouseenter', '.page_link', function() {
    var $this = $(this);
    if ($this.hasClass('current'))
      return;
    if (!$this.data('popover')) {
      $this.popover({
        trigger: 'manual',        
        placement: 'right',        
        delay: 0        
      });
    };
    $this.delay(1000, 'fx').queue('fx', function() { $(this).popover('show'); $(this).dequeue(); });
  }).on('mouseleave click keydown', '.page_link', function(event) {
    var $this = $(this);
    if ($this.hasClass('current'))
      return;
    $this.stop('fx', true, true).popover('hide');
  });
});
`