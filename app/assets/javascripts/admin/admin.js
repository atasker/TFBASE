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
//= require popper
//= require bootstrap
//= require summernote/summernote-bs4.min
// do not require_tree .

function toggleEventStartTimeDisability() {
  var tbcHere = $("#event_tbc").prop('checked');
  for (var i = 1; i < 6; i++) {
    $("#event_start_time_" + i + "i").prop('disabled', tbcHere);
  }
}
function toggleEventRowStartTimeDisability() {
  var tbcCheckbox = $(this);
  var tbcHere = tbcCheckbox.prop('checked');
  tbcCheckbox.parent().children("select").prop('disabled', tbcHere);
}
function listenTBCCheckboxInEventRow(container) {
  var tbcCheckbox = container.find("td[data-field-name='start_time'] > input[type='checkbox']");
  tbcCheckbox.on('change', toggleEventRowStartTimeDisability);
  toggleEventRowStartTimeDisability.call(tbcCheckbox[0]);
}
function initCocoonAddedEventOfVenue(evnt, insertedItem) {
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

  // lister TBC change
  listenTBCCheckboxInEventRow(insertedItem);

  // init chosen
  insertedItem.find('.chzn-select').chosen();
}
function initEventFieldsActions() {
  var eventItems = $("tbody.event_items");
  if (eventItems.length) {
    $("tbody.event_items").off('cocoon:after-insert', initCocoonAddedEventOfVenue);
    $("tbody.event_items").on('cocoon:after-insert', initCocoonAddedEventOfVenue);
    $("tbody.event_items > tr").each(function(indx) {
      listenTBCCheckboxInEventRow($(this));
    });
  }

  var eventTBC = $("#event_tbc");
  if (eventTBC.length) {
    eventTBC.change(toggleEventStartTimeDisability);
    toggleEventStartTimeDisability();
  }
}

// - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - =

function toggleVisibilityOfTicketField() {
  var enquireOn = $("#ticket_enquire").prop('checked');
  $("#ticket_price").closest("p").toggle(!enquireOn);
  $("#ticket_fee_percent").closest("p").toggle(!enquireOn);
  $("#ticket_quantity").closest("p").toggle(!enquireOn);
  $("#ticket_pairs_only").closest("p").toggle(!enquireOn);
  $("#ticket_currency").closest("p").toggle(!enquireOn);
}
function toggleVisibilityOfTicketCells(ticketRow) {
  var enquireOn = ticketRow.find(".event-ticket-cell-enquire > input[type='checkbox']").prop('checked');
  ticketRow.find(".event-ticket-cell-price > input").toggle(!enquireOn);
  ticketRow.find(".event-ticket-cell-fee-percent > input").toggle(!enquireOn);
  ticketRow.find(".event-ticket-cell-quantity > input").toggle(!enquireOn);
  ticketRow.find(".event-ticket-cell-pairs-only > input[type='checkbox']").toggle(!enquireOn);
  ticketRow.find(".event-ticket-cell-currency > select").toggle(!enquireOn);
}
function handleEnquireInCellChange(evnt) {
  toggleVisibilityOfTicketCells($(this).parent().parent());
}
function initCocoonAddedTicketOfEvent(evnt, insertedItem) {
  insertedItem.find(".event-ticket-cell-enquire > input[type='checkbox']").on('change', handleEnquireInCellChange);
  toggleVisibilityOfTicketCells(insertedItem);
}
function initTicketFieldsVisibility() {
  var enquireCbox = $("#ticket_enquire");
  if (enquireCbox.length) {
    enquireCbox.off('change', toggleVisibilityOfTicketField);
    enquireCbox.on('change', toggleVisibilityOfTicketField);
    toggleVisibilityOfTicketField();
  }
  var enquireCells = $(".event-ticket-cell-enquire");
  if (enquireCells.length) {
    $(".event-ticket-cell-enquire > input[type='checkbox']").off('change', handleEnquireInCellChange);
    $(".event-ticket-cell-enquire > input[type='checkbox']").on('change', handleEnquireInCellChange);
    enquireCells.each(function(indx) {
      toggleVisibilityOfTicketCells($(this).parent());
    });
  }
  $("tbody.ticket_items").off('cocoon:after-insert', initCocoonAddedTicketOfEvent);
  $("tbody.ticket_items").on('cocoon:after-insert', initCocoonAddedTicketOfEvent);
}

// - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - =

function makeEffectOfCheckedSelector() {
  var jqDestroyButton = $("#event-table-destroy-all-button");
  var jqCheckedSelectors = $(".event-table-selector:checked");

  var needToDisable = !jqCheckedSelectors.length;
  if (needToDisable) {
    jqDestroyButton.attr('disabled', 'disabled');
  } else {
    jqDestroyButton.removeAttr('disabled');
  }

  var baseHref = jqDestroyButton.attr('href').split('?')[0];
  var eventIds = [];
  jqCheckedSelectors.each(function() {
    eventIds.push($(this).data('event-id'));
  });
  if (eventIds.length) {
    jqDestroyButton.attr('href', baseHref + '?ids=' + eventIds.join(','));
  } else {
    jqDestroyButton.attr('href', baseHref);
  }
}
function makeDisabilityBlock(evnt) {
  if ($(this).attr('disabled')) {
    event.preventDefault();
    return false;
  }
  return true;
}
function initEventsDestroyManyFeature() {
  $(".event-table-selector").off('change', makeEffectOfCheckedSelector);
  $(".event-table-selector").on('change', makeEffectOfCheckedSelector);
  $("#event-table-destroy-all-button").off('click', makeDisabilityBlock);
  $("#event-table-destroy-all-button").on('click', makeDisabilityBlock);
}

function integratingSummernte(){
  $('[data-provider="summernote"]').each(function(){
    $(this).summernote({
      height: 300,
      fontSizes: ['10', '11', '12', '14', '18', '20', '22', '24', '26', '28', '30', '34', '36', '48'],
      toolbar: [
        ['fontname', ['fontname']],
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['height', ['height']],
        ['insert', ['picture', 'myvideo', 'link', 'table', 'hr']],
        ['misc', ['fullscreen', 'undo', 'redo']]
      ]
    });
  });
}
// - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - = - =

$(document).on('ready turbolinks:load', function() {

  $('.chzn-select').chosen();

  initEventFieldsActions();

  initTicketFieldsVisibility();

  initEventsDestroyManyFeature();

  integratingSummernte();

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

  $('#info-blocks').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
    integratingSummernte();
  });

  $('#info-tabs').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
    integratingSummernte();
  });
});
