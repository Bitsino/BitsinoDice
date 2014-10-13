window.App.Views.UserDetails = Backbone.View.extend({

  initialize: function() {
    App.on('login', this.updateUserDetails, this);
  },

  updateUserDetails: function(model) {
    this.$el.find('#username').text(model.get('username'));
    this.$el.find('#userId').text(model.get('id'));
  }

});