window.App.Views.BetForm = Backbone.View.extend({
  
  el: '#betForm',

  events: {
    'change input': 'setValues',
    'change :radio': 'setValues',
    'submit': 'process'
  },

  initialize: function() {
    App.on('login', this.enableForm, this);

    this.model = new App.Models.Bet();
    this.setValues();
    this.addEventHandlers();
  },

  addEventHandlers: function() {
    this.model.on('change:amount', this.updateAmount, this);
    this.model.on('change:profit', this.updateProfit, this);
    this.model.on('change:chance', this.updateMultiplier, this);
    this.model.on('change:multiplier', this.updateChance, this);
    this.model.on('change:game', this.updateGame, this);

    this.model.on('invalid', this.showValidationNotice, this);
  },

  setValues: function() {
    this.model.set({
      balance: +parseFloat($('#balance').val()),
      rolltype: this.$el.find('#rolltype :checked').val(),
      amount: +parseFloat(this.$el.find('#bet_amount').val()).toFixed(8),
      chance: +parseFloat(this.$el.find('#bet_chance').val()).toFixed(5),
      multiplier: +parseFloat(this.$el.find('#bet_multiplier').val()).toFixed(5),
    });

    if (this.model.isValid()) {
      this.enableForm();
    } else {
      this.disableForm();
    }
  },

  updateAmount: function() {
    this.$el.find('#bet_amount').val(parseFloat(this.model.get('amount')).toFixed(8));
  },

  updateChance: function() {
    this.$el.find('#bet_chance').val(this.model.get('chance'));
  },

  updateProfit: function() {
    this.$el.find('#bet_profit').val(parseFloat(this.model.get('profit')).toFixed(8));
  },

  updateMultiplier: function() {
    this.$el.find('#bet_multiplier').val(this.model.get('multiplier'));
  },

  updateGame: function() {
    this.$el.find('#bet_game').val(this.model.get('game'));
  },

  process: function(e) {
    e.preventDefault();

    this.disableForm();

    this.model.set('client_seed', $('#client-seed').val());

    var self = this;

    this.model.save(
      {},
      {
        success: function(model, response, options) {
          var balance;

          if (model.get('win_or_lose') === 'win') {
            balance = (+App.user.get('balance') + +model.get('profit'));
          } else {
            balance = (+App.user.get('balance') - +model.get('amount'));
          }
          console.log(balance);
          App.user.set('balance', balance);
          
          ws.send(JSON.stringify(response));

          self.reset();
        }
      }
    );
  },

  reset: function() {
    this.model = new App.Models.Bet();

    this.enableForm();

    // this.$el.find('#bet_amount').val(0.00000000.toFixed(8));
    // this.$el.find('#bet_profit').val(0.00000000.toFixed(8));
    // this.$el.find('#bet_chance').val(49.50.toFixed(2));
    // this.$el.find('#bet_multiplier').val(2.0000.toFixed(4));
    // this.$el.find('#bet_game').val(49.50.toFixed(2));
    // this.$el.find('#rolltype input[value="under"]').prop('checked', true);

    this.setValues();
    this.addEventHandlers();

    App.trigger('refreshClientSeed');
    App.trigger('refreshServerSeed');
  },

  disableForm: function() {
    this.$el.find('input[type="submit"]').attr('disabled', 'disabled');
  },

  enableForm: function() {
    this.$el.find('input[type="submit"]').removeAttr('disabled');
  },

  showValidationNotice: function(model, error) {
    this.$el.prepend('<div class="alert alert-danger"><p>' + error + '</p></div>');

    setTimeout(function() {
      $('.alert').fadeOut(function() {
        $(this).remove();
      });
    }, 1500);
  }

});