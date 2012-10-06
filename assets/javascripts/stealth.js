
jQuery(function($) {

  window.RedmineStealth = {

    cloak: function(label) {
      $('#stealth_toggle').text(label).
        data({ params : { toggle : 'false' } });
      $('body').removeClass('stealth_off').
        addClass('stealth_on');
    },

    decloak: function(label) {
      $('#stealth_toggle').text(label).
        data({ params : { toggle : 'true' } });
      $('body').removeClass('stealth_on').
        addClass('stealth_off');
    },

    notifyFailure: function() {
      alert($('#stealth_toggle').data('failure-message'));
    }

  };

  $('#stealth_toggle').bind('ajax:error', RedmineStealth.notifyFailure);

});

