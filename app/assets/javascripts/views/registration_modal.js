window.App.Views.RegistrationModal = Backbone.View.extend({

  events: {
    'submit': 'process'
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

  process: function(e) {
    e.preventDefault();

    this.model.set({ 
      username: this.$el.find('#user_username').val(),
      password: this.$el.find('#user_password').val()
    });

    this.model.save(
      {},
      {
        success: function(model, response, options) {
          App.trigger('login', model);
        },
        error: function(model, xhr, options) {
          console.log(xhr)
        }
      }
    );
  }

});