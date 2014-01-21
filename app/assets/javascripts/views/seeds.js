window.App.Views.Seeds = Backbone.View.extend({

  initialize: function() {
    App.on('refreshClientSeed', this.updateClientSeed, this);
    App.on('refreshServerSeed', this.updateServerSeed, this);

    this.updateClientSeed();
  },

  updateClientSeed: function() {
    this.$el.find('#client-seed').val(App.clientSeed());
  },

  updateServerSeed: function() {
    var self = this;
    $.getJSON('/', function(data) {
      self.$el.find('#server-seed').val(data['server_seed']);
    });
  }

});