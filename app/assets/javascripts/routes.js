window.App.Routers.Navigation = Backbone.Router.extend({

  routes: {
    '*path': 'defaultRoute'
  },

  defaultRoute: function() {
    App.bets = new App.Views.Bets();

    new App.Views.Seeds({ el: $('#seeds').get(0) });
    new App.Views.BetForm();
    new App.Views.Balance({ el: $('#balance').get(0) });
    new App.Views.CashoutModal({ el: $('#cashoutModal').get(0) });
    new App.Views.UserDetails({ el: $('#userDetails').get(0) });
    new App.Views.DepositModal({ el: $('#depositModal').get(0) });
    
    if (!App.auth_token()) {
      new App.Views.LoginForm({ el: $('#loginForm').get(0) });
      new App.Views.RegistrationModal({ el: $('#registerModal').get(0) }).show();
    } else {
      App.trigger('login', App.user);
      App.trigger('updateBalance');
    }
  }

});