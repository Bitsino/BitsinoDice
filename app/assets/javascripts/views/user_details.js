window.App.Views.UserDetails = Backbone.View.extend({

  initialize: function() {
    App.on('login', this.updateUserDetails, this);
  },

  updateUserDetails: function(model) {
    this.$el.find('#username').val(model.get('username'));
    this.$el.find('#userId').text(model.get('id'));
  }

});