// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require twitter/bootstrap
//= require markitup
//= require markitup-html
//= require fancybox
//= require_directory .

$(function() {
  // Empty message box after delay
  $('#messages').emptyFadeOut();

  $("a[rel^=photo_group]").fancybox({
    titlePosition: "over",
    titleFormat: function(title, currentArray, currentIndex, currentOps) {
      var title_tag = title.length ? '<div class="title">' + title + '</div>' : '';
      var couter_tag = '<div class="counter">' + (currentIndex + 1) + " из " + currentArray.length + '</div>';
      return '<div id="fancybox-title-over" class="clearfix">' + title_tag + couter_tag + '</div>';
    }
  });
});
