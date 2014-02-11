window.App.Views.RegistrationModal = Backbone.View.extend({

  events: {
    'submit': 'process',
    'click a': 'login'
  },

  initialize: function() {
    App.on('login', this.hide, this);

    this.model = new App.Models.User();
  },

  show: function() {
    this.$el.modal('show');
  },

  hide: function() {
    this.$el.modal('hide');
  },

  login: function(e) {
    e.preventDefault();

    $('.username').val(this.$el.find('#user_username').val());
    $('.password').val(this.$el.find('#user_password').val());

    this.hide();

    App.loginForm.$el.trigger('submit');
  },

  process: function(e) {
    e.preventDefault();

    this.model.set({ 
      username: this.$el.find('#user_username').val(),
      password: this.$el.find('#user_password').val()
    });

    var self = this;

    this.model.save(
      {},
      {
        success: function(model, response, options) {
          App.trigger('login', model);
        },
        error: function(model, xhr, options) {
          $(self).before('<div id="loginAlert" class="container"><div class="alert alert-danger"><p><strong>Error</strong> - please check the details you have entered</p></div></div>');
          setTimeout(function() {
            $('#loginAlert').fadeOut(function() {
              $(this).remove();
            });
          }, 1500);
        }
      }
    );
  }

});