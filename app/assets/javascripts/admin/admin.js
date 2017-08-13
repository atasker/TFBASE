// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require cocoon
// do not require_tree .

$(document).on('ready turbolinks:load', function() {

  var home_slide_manual_switchers = $("#home_slide_manual_input_false, #home_slide_manual_input_true");
  if (home_slide_manual_switchers.length) {
    home_slide_manual_switchers.change(function(evnt) {
      var switcher = $(this);
      $("#home-slide-manual-input-off-fields").toggle(switcher.val() == 'false');
      $("#home-slide-manual-input-on-fields").toggle(switcher.val() == 'true');
    });
  }

});
