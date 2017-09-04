$(document).ready(function() {
  if ($(".tickets__top").length) {

    function ticketItems(jqInTopElement) {
      return jqInTopElement.closest(".tickets__top").next(".tickets__list").children(".tickets__item");
    }

    $(".tickets__top form").submit(function(evnt) { evnt.preventDefault(); return false; });

    var fastSearchInputs = $(".tickets__search input[type='text']");
    fastSearchInputs.on("change keyup", function(evnt) {
      var filterInput = $(this),
          itext = $(this).val().toString().toLowerCase();
      if (itext) {
        ticketItems(filterInput).each(function(indx) {
          var titem = $(this),
              titemName = titem.data('item-name').toString().toLowerCase();
          titem.toggle(titemName.indexOf(itext) > -1);
        });
      }
      else {
        ticketItems(filterInput).show();
      }
    });
    fastSearchInputs.on('paste cut', function(evnt) {
      var filterInput = $(this);
      setTimeout(function() { filterInput.trigger('change'); }, 100);
    });

    $(".tickets__filter select").change(function(evnt) {
      var filterSelect = $(this),
          choosenLocationId = filterSelect.val();
      if (choosenLocationId == "All locations") {
        ticketItems(filterSelect).show();
      }
      else {
        ticketItems(filterSelect).each(function(indx) {
          var titem = $(this),
              titemLocs = titem.data('location-ids').toString().split(',');
          titem.toggle(titemLocs.indexOf(choosenLocationId) > -1);
        });
      }
    });

  }
});
