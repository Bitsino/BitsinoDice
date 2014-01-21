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
      amount: +parseFloat(this.$el.find('#bet_amount').val()).toPrecision(8),
      chance: +parseFloat(this.$el.find('#bet_chance').val()).toPrecision(5),
      multiplier: +parseFloat(this.$el.find('#bet_multiplier').val()).toPrecision(5),
    });

    if (this.model.isValid()) {
      this.enableForm();
    } else {
      this.disableForm();
    }
  },

  updateAmount: function() {
    this.$el.find('#bet_amount').val(this.model.get('amount'));
  },

  updateChance: function() {
    this.$el.find('#bet_chance').val(this.model.get('chance'));
  },

  updateProfit: function() {
    this.$el.find('#bet_profit').val(this.model.get('profit'));
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

          App.user.set('balance', balance);
          console.log(model.toJSON());
          console.log(response);
          ws.send(JSON.stringify(model.toJSON()));

          App.trigger('updateBalance');

          self.reset();
        }
      }
    );
  },

  reset: function() {
    this.model = new App.Models.Bet();
    this.setValues();

    this.enableForm();

    this.$el.find('#bet_amount').val('0.00000000');
    this.$el.find('#bet_profit').val('0.00000000');
    this.$el.find('#bet_chance').val('49.50');
    this.$el.find('#bet_multiplier').val('2.0000');
    this.$el.find('#rolltype input[value="under"]').prop('checked', true);

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