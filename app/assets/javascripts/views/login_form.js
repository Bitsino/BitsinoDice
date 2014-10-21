window.App.Views.LoginForm = Backbone.View.extend({
  
  events: {
    'submit': 'process'
  },

  initialize: function() {
    App.on('login', this.hide, this);

    this.model = new App.Models.Session();
    this.$el.show();
  },

  process: function(e) {
    e.preventDefault();

    this.model.set({
      username: this.$el.find('.username').val(),
      password: this.$el.find('.password').val()
    });
    
    this.model.save({},
      {
        success: function(model, response, options) {
          var user = new App.Models.User(response);
          $('#logout').show();
          App.trigger('login', user);
        },
        error: function(model, xhr, options) {
          $('.navbar').after('<div id="loginAlert" class="container"><div class="alert alert-danger"><p><strong>Login Error</strong> - please check the details you have entered</p></div></div>');
          setTimeout(function() {
            $('#loginAlert').fadeOut(function() {
              $(this).remove();
            });
          }, 1500);
        }
      }
    );

  },

  hide: function() {
    this.$el.hide();
  }

});