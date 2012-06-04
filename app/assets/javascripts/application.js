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
//= require jquery_ujs
//= require twitter/bootstrap
//= require markitup
//= require markitup-html
//= require_tree .

// Set header Accept: text/javascript for all ajax requests in application
// jQuery.ajaxSetup({
//   'beforeSend': function(xhr) {
//     xhr.setRequestHeader('Accept', 'text/javascript');
//   }
// });

// jQuery function for submitting forms with ajax
jQuery.fn.ajaxSubmit = function() {
  $(this).submit(function(e) {
    e.preventDefault();
    $.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      dataType: 'script'
    });
    return false;
  });
};

jQuery.fn.emptyFadeOut = function(duration, delay) {
  duration = duration || 500;
  delay = delay || 500;
  $(this).delay(delay).fadeOut(duration, function() {
    $(this).empty();
  });
};