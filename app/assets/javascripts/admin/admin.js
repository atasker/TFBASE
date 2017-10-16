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

function initCocoonAddedItem(evnt, insertedItem) {
  // dublicate info from the previous item (if exist)
  var sourcer = insertedItem.prev();
  while (sourcer.length > 0 && !sourcer.hasClass('nested-fields')) {
    sourcer = sourcer.prev();
  }
  if (sourcer.length) {
    var sourcerDateSelects = sourcer.find("td[data-field-name='start_time'] select");
    var insertederDateSelects = insertedItem.find("td[data-field-name='start_time'] select");
    for (var i = 0; i < 5; i++) {
      $(insertederDateSelects[i]).val($(sourcerDateSelects[i]).val());
    }

    var sourcerCatCatSelects = sourcer.find("td[data-field-name='category_and_competition'] select");
    var insertederCatCatSelects = insertedItem.find("td[data-field-name='category_and_competition'] select");
    for (var i = 0; i < 2; i++) {
      $(insertederCatCatSelects[i]).val($(sourcerCatCatSelects[i]).val());
    }

    var sourcerSportPriorCb = sourcer.find("td[data-field-name='sports_and_priority'] input[type='checkbox']");
    var insertederSportPriorCb = insertedItem.find("td[data-field-name='sports_and_priority'] input[type='checkbox']");
    for (var i = 0; i < 2; i++) {
      $(insertederSportPriorCb[i]).prop('checked', $(sourcerSportPriorCb[i]).prop('checked'));
    }

    insertedItem.find("td[data-field-name='players'] select").val(
      sourcer.find("td[data-field-name='players'] select").val());
  }

  // init chosen
  insertedItem.find('.chzn-select').chosen();
}

$(document).on('ready turbolinks:load', function() {

  $('.chzn-select').chosen();

  $("tbody.event_items").off('cocoon:after-insert', initCocoonAddedItem);
  $("tbody.event_items").on('cocoon:after-insert', initCocoonAddedItem);

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
