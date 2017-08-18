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
//= require chosen.jquery
// do not require_tree .

$(document).on('ready turbolinks:load', function() {

  $('.chzn-select').chosen();

  $("tbody.event_items").on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('.chzn-select').chosen();
  });

  if ($(".form-switcher").length) {
    $(".form-switcher input").change(function(evnt) {
      var switcher = $(this);
      var activePanelId = switcher.data('panel-id');
      switcher.closest(".form-switcher").find("input").each(function(indx) {
        var panelid = $(this).data('panel-id');
        $("#" + panelid).toggle(panelid == activePanelId);
      });
      $("#" + activePanelId + " .hidden-chzn-select").chosen();
    });
    $("#" + $(".form-switcher input:checked").data('panel-id') + " .hidden-chzn-select").chosen();
  }

});
