$(document).ready(function() {
  $('select#ticket-quantity-select').change(function() {
    var selected = $(this).find("option:selected").attr("value");
    var newPrice = $("#ticket-price").text() * selected;
    $("#ticket-total").text(newPrice);
    $("#hidden-quantity").val(selected);
  });
});
