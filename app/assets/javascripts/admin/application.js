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
//= require markitup/textile
//= require fancybox
//= require elfinder
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

// Add Hover effect to dropdown menus
function dropdown_hover_add(all) {
  var menu_selector = all ? '.dropdown-menu' : '.dropdown-hover .dropdown-menu';
  var toggle_selector = all ? '.dropdown-toggle' : '.dropdown-hover .dropdown-toggle';

  $(document).on('mouseenter', toggle_selector, function() {
    $(this).siblings(menu_selector).stop(true, true).delay(200).fadeIn(200, function() {
      $(this).closest('.btn-group').addClass('open');
    });
  }).on('mouseleave', toggle_selector, function(event) {
    var $ddm = $(this).siblings(menu_selector);
    var $target = $(event.relatedTarget);
    if (!$ddm.length ||
      $target[0] != $ddm[0] &&
      $target.closest(menu_selector)[0] != $ddm[0]
    )
      $ddm.stop(true, true).delay(200).fadeOut(200, function() {
        $(this).closest('.btn-group.open').removeClass('open');
      });
  });

  $(document).on('mouseleave', menu_selector, function(event) {
    var $ddt = $(this).siblings(toggle_selector);
    var $target = $(event.relatedTarget);
    if (!$ddt.length ||
      $target[0] != $ddt[0] &&
      $target.closest(toggle_selector)[0] != $ddt[0]
    )
      $(this).stop(true, true).delay(200).fadeOut(200, function() {
        $(this).closest('.btn-group.open').removeClass('open');
      });  
  });
};

// Show teaser content (data-content) in popover window when sidebar item hovered
function sidebar_popover_init() {
  $('.sidebar').on('mouseenter', '.sidebar-link', function() {
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
  }).on('mouseleave click keydown', '.sidebar-link', function(event) {
    var $this = $(this);
    if ($this.hasClass('current'))
      return;
    $this.stop('fx', true, true).popover('hide');
  });
};

// Dom ready initializer
$(function() {
  // Show message block if there is some messages
  $('#messages:has(:first-child)').show().emptyFadeOut();

  dropdown_hover_add(true);
  sidebar_popover_init(); 

  $("a[rel=photo_group]").fancybox({
    titlePosition: "over",
    titleFormat: function(title, currentArray, currentIndex, currentOps) {
      var title_tag = title.length ? '<div class="title">' + title + '</div>' : '';
      var couter_tag = '<div class="counter">' + (currentIndex + 1) + " из " + currentArray.length + '</div>';
      return '<div id="fancybox-title-over" class="clearfix">' + title_tag + couter_tag + '</div>';
    }
  });

});
