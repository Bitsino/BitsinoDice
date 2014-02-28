window.App.Models.User = Backbone.Model.extend({

  url: '/users',

  initialize: function() {
    this.on('change:balance', this.updateUserBalance, this);
  },

  updateUserBalance: function() {
    App.trigger('updateBalance');
  }

});