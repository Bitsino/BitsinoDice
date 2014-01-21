window.App.Views.Bets = Backbone.View.extend({

  el: 'tbody',
  
  initialize: function() {
    this.collection = new App.Collections.Bets();
    this.collection.on('add', this.renderOne, this);
    this.collection.on('add', this.limitTableSize, this);
    this.collection.on('reset', this.render, this);
    this.collection.on('remove', this.removeOne, this);
  },

  render: function() {
    _.each(this.collection.models, function(model, idx) {
      this.renderOne(model);
    }, this);
  },

  renderOne: function(model) {
    var row = new App.Views.BetRow({ model: model }).render();
    
    this.$el.prepend(row.$el);
  },

  removeOne: function(model) {
    this.collection.remove(model);
  },

  limitTableSize: function() {
    if (this.collection.size() > 5) {
      this.removeOne(this.collection.first());
    }
  }

});