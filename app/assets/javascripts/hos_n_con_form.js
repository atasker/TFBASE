$(document).ready(function() {

  var form = $("#hos-n-con-form");

  var disableForm = function() {
    form.find("input").prop('disabled', true);
  };
  var enableForm = function() {
    form.find("input").prop('disabled', false);
  };

  form.on('ajax:beforeSend', function(evnt, xhr, settings) {
    disableForm();
  });

  form.on('ajax:success', function(evnt, data, status, xhr) {
    console.log("AS");
    if (data.status == 'success') {
      console.log("DS");
      form.hide();
      form.after('<p class="success_message">Thank you! Your message has been successfully sent. We will contact you very soon.</p>');
    }
    else {
      // Can nothing to do.
      enableForm();
    }
  });

  form.on('ajax:error', function(evnt, xhr, status, error) {
    // just release submit button giving another try
    enableForm();
  });

});
