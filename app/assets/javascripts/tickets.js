$(document).ready(function() {
  $('select#ticket-quantity-select').change(function() {
    var quantitier = $(this);
    var selected = quantitier.find("option:selected").attr("value");
    var newPrice = quantitier.data('price') * selected;
    $("#ticket-total").text(newPrice);
    $("#hidden-quantity").val(selected);
  });
});
