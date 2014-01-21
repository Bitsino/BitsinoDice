window.App.Views.Balance = Backbone.View.extend({
  
  initialize: function() {
    App.on('login', this.updateUserDetails, this);
    App.on('updateBalance', this.updateBalance, this);
  },

  updateBalance: function() {
    this.$el.val(+App.user.get('balance').toFixed(8));
  }
  
});