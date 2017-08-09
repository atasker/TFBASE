$(document).ready(function() {

  var form = $("#popup-feedback-form");

  var disableForm = function() {
    form.find("input, textarea").prop('disabled', true);
  };
  var enableForm = function() {
    form.find("input, textarea").prop('disabled', false);
  };

  var clearWrapErrorState = function(inputWrap) {
    inputWrap.removeClass('input-wrap--error');
    inputWrap.find(".error-msg").remove();
  };
  var clearInputErrorState = function(jqInput) {
    var inputWrap = jqInput.closest(".input-wrap");
    if (inputWrap.hasClass('input-wrap--error')) {
      clearWrapErrorState(inputWrap);
    }
  };
  var setInputErrorState = function(jqInput, msg) {
    var inputWrap = jqInput.closest(".input-wrap");
    inputWrap.addClass('input-wrap--error');
    inputWrap.append('<span class="error-msg">' + msg + '</span>');
  };

  form.find('input').change(function() {
    clearInputErrorState($(this));
  });
  form.find('input').on('keyup', function() {
    clearInputErrorState($(this));
  });

  form.on('ajax:beforeSend', function(evnt, xhr, settings) {
    disableForm();
  });

  form.on('ajax:success', function(evnt, data, status, xhr) {
    if (data.status == 'success') {
      form.find(".popup-send__success-msg").show();
      setTimeout(function() { $.magnificPopup.close(); }, 1600);
    }
    else {
      var misfit, errmsgs;
      form.find(".input-wrap--error").each(function() {
        clearWrapErrorState($(this));
      });
      for (var key in data.errors){
        if ((misfit = form.find("#message_" + key)).length) {
          errmsgs = '';
          for (var i = 0; i < data.errors[key].length; i++) {
            if (errmsgs !== '') { errmsgs = errmsgs + ', '; }
            errmsgs = errmsgs + data.errors[key][i];
          }
          setInputErrorState(misfit, errmsgs);
        }
      }
      enableForm();
    }
  });

  form.on('ajax:error', function(evnt, xhr, status, error) {
    // just release submit button giving another try
    enableForm();
  });

});
