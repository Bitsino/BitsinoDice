window.App.Views.Balance = Backbone.View.extend({
  
  initialize: function() {
    App.on('updateBalance', this.updateBalance, this);

    this.updateBalance();
  },

  updateBalance: function() {
    this.$el.val(App.user.get('balance'));
  }
  
});