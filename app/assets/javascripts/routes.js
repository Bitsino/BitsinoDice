window.App.Routers.Navigation = Backbone.Router.extend({

  routes: {
    'sign-out': 'signOut',
    '*path': 'defaultRoute'
  },

  defaultRoute: function() {
    App.bets = new App.Views.Bets();
    App.transactions 

    new App.Views.Seeds({ el: $('#seeds').get(0) });
    new App.Views.BetForm();
    new App.Views.Balance({ el: $('#balance').get(0) });
    new App.Views.CashoutModal({ el: $('#cashoutModal').get(0) });
    new App.Views.UserDetails({ el: $('#userDetails').get(0) });
    new App.Views.DepositModal({ el: $('#depositModal').get(0) });
    new App.Views.Transactions();
    
    if (!App.user) {
      App.loginForm = new App.Views.LoginForm({ el: $('#loginForm').get(0) });
      new App.Views.RegistrationModal({ el: $('#registerModal').get(0) }).show();
    } else {
      App.trigger('login', App.user);
      App.trigger('updateBalance');
    }
  },

  signOut: function() {
    $.ajax({
      url: '/users/sign_out',
      type: 'DELETE',
      success: function(result) {
        App.logout();
      }
    });
  }

});