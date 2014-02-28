window.App.Models.User = Backbone.Model.extend({

  url: '/users',

  initialize: function() {
    this.on('change:balance', App.trigger('updateBalance'));
  }

});