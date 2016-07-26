$(document).ready(function() {
  $('#add_event').click(function() {
    event.preventDefault();
    alert("HEY");
    $('.events_attributes').last().clone().appendTo($('.form-table'));
  });
});
