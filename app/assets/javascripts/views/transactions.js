window.App.Views.Transactions = Backbone.View.extend({

  el: 'tbody#transactions',
  
  initialize: function() {
    this.collection = new App.Collections.Transactions();
    this.collection.on('add', this.renderOne, this);
  },

  render: function() {
    _.each(this.collection.models, function(model, idx) {
      this.renderOne(model);
    }, this);
  },

  renderOne: function(model) {
    var row = new App.Views.TransactionRow({ model: model }).render();
    
    this.$el.prepend(row.$el);
  },

  removeOne: function(model) {
    this.collection.remove(model);
  }

});