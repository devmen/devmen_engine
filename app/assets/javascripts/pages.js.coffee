# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

`$(document).ready(function() {
  $("textarea.markitup").markItUp(mySettings);

  $(document).on("ajax:success", function() {
    // Reset the markItUp editor for textarea after ajax page reload
    $("textarea.markitup").markItUpRemove().markItUp(mySettings);
  });
});`
