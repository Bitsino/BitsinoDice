window.App.Routers.Navigation = Backbone.Router.extend({

  routes: {
    'sign-out': 'signOut',
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
    App.transactions = new App.Views.Transactions();
    App.loginForm = new App.Views.LoginForm({ el: $('#loginForm').get(0) });
    
    if (!App.user) {
      App.user = new App.Models.User();
      App.user.set({ 
        username: App.user.randomString(),
        password: App.user.randomString()
      });
      
      App.user.save(null, {
        success: function (model, response) {
          App.trigger('login', model);
          App.trigger('updateBalance');
        },
        error: function (model, response) {
          console.log("error");
        }
      });
      
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