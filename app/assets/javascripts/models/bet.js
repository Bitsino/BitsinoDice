window.App.Models.Bet = Backbone.Model.extend({

  url: App.base_url + 'bets.json?auth_token=' + App.auth_token(),

  initialize: function() {
    this.on('change:multiplier', this.calculateChance, this);
    this.on('change:multiplier', this.calculateProfit, this);
    this.on('change:chance', this.calculateMultiplier, this);
    this.on('change:chance', this.calculateGame, this);
    this.on('change:rolltype', this.calculateGame, this);
    this.on('change:amount', this.calculateProfit, this);
  },

  validate: function(attrs, options) {
    if (attrs.amount > attrs.balance) {
      return 'Amount cannot be greater than your balance';
    }
  },

  calculateGame: function() {
    if (this.get('rolltype') == 'under' || this.get('rolltype') == '<') {
      this.set('game', this.get('chance'));
    } else {
      this.set('game', 100 - this.get('chance'));
    }
  },

  calculateChance: function() {
    this.set('chance', (99 / this.get('multiplier')));
  },

  calculateMultiplier: function() {
    this.set('multiplier', (99 / this.get('chance')));
  },

  calculateProfit: function() {
    var profit = (this.get('amount') * this.get('multiplier')) - this.get('amount');
    this.set('profit', profit.toFixed(8));
  }

});