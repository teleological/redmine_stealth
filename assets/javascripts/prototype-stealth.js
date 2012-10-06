(function(root) {

  root.RedmineStealth = {

    cloak: function(label) {
      $('stealth_toggle').update(label).
        writeAttribute('data-params-toggle', "false");
      $$('body')[0].removeClassName('stealth_off').
        addClassName('stealth_on');
    },

    decloak: function(label) {
      $('stealth_toggle').update(label).
        writeAttribute('data-params-toggle', "true");
      $$('body')[0].removeClassName('stealth_on').
        addClassName('stealth_off');
    },

    notifyFailure: function() {
      alert($('stealth_toggle').readAttribute('data-failure-message'));
    }

  };

}).call({}, this);
