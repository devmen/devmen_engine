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
//= require ./markitup/textile
//= require_directory ./elfinder
//= require_directory .

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

// Set the markItUp editor for a textareas with markitup class
jQuery.markitup_init = function () {
  // Extend default markitupSettings with elfinder settings
  function elfinderMarkitupSettings(settings, type) {
    settings = $.extend({}, settings);
    type = type || 'html';
    var folders = ['Images', 'Files'];

    function editorCallback(folder, type) {    
      return function (url) {
        var filename = url.split('/').pop().replace(/\.\w+$/, '');
        var options
        switch (type) {
          case 'html':
            if (folder == 'Images')
              options = { replaceWith: '<img src="'+url+'" alt="'+filename+'" />' };
            else if (folder == 'Files')
              options = {
                openWith: '<a href="'+url+'" title="'+filename+'">',
                closeWith: '</a>',
                placeHolder: filename
              };
            break;
          case 'textile':    
            if (folder == 'Images')
              options = { replaceWith: '!'+url+'('+filename+')!' };
            else if (folder == 'Files')
              options = {
                openWith: '"',
                closeWith: '('+filename+')":'+url,
                placeHolder: filename
              };
            break;
        };
        
        $.markItUp(options);
      };
    };

    function beforeInsert(folder, type) {
      return function(h) {
        // Initialize elfinder      
        $('<div id="elfinder" />').elfinder({
          url: '/admin/elfinder?folder=' + folder,
          lang: 'ru',        
          dialog: { width: 700, modal: true, title: folder }, // open in dialog window
          closeOnEditorCallback: true, // close after file select
          editorCallback: editorCallback(folder, type)
        });
      }
    };

    for (var i = 0; i < settings.markupSet.length; i++)
      if ($.inArray(settings.markupSet[i]['name'], folders) != -1)
        settings.markupSet[i]['beforeInsert'] = beforeInsert(settings.markupSet[i]['name'], type);

    return settings;
  };
  
  var settings = elfinderMarkitupSettings(mySettings, 'textile');
  $('.markitup').each(function() {
    if (!$(this).data('markitup')) {
      $(this).data('markitup', true);
      $(this).markItUp(settings);
    }
  });  
};

// Empty dom element after fade out
jQuery.fn.emptyFadeOut = function(duration, delay) {
  duration = duration || 1000;
  delay = delay || 5000;
  $(this).delay(delay).fadeOut(duration, function() {
    $(this).empty();
  });
};

// Dom ready initializer
$(function() {
  // Show message block if there is some messages
  $('#messages:has(:first-child)').show().emptyFadeOut();  
});