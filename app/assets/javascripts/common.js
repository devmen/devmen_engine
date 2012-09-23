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