window.App.Views.Balance = Backbone.View.extend({
  
  initialize: function() {
    App.on('login', this.updateBalance, this);
    App.on('updateBalance', this.updateBalance, this);
  },

  updateBalance: function() {
    this.$el.val(App.user.get('balance'));
  }
  
});