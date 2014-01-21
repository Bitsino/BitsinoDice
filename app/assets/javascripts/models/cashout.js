window.App.Models.Cashout = Backbone.Model.extend({

  url: App.base_url + '/cashouts?auth_token=' + App.auth_token(),

  validate: function(attrs, options) {
    if (attrs.amount >= (+App.user.balance - 0.0005)) {
      return 'amount cannot be greater than your balance';
    }
  }

});