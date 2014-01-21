window.App.Views.BetRow = Backbone.View.extend({

  tagName: 'tr',
  
  template: HandlebarsTemplates['bet_row'],

  events: {
    'click' : 'showModal'
  },

  initialize: function() {
    this.model.on('remove', this.hide, this);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));

    return this;
  },

  hide: function() {
    this.$el.hide();
  },

  showModal: function() {
    $('#betModal').modal({ remote: '/bets/' + this.model.get('id') });
    $('#betModal').on('hidden.bs.modal', function(e) {
      $(this).removeData('bs.modal');
    });
    $('#betModal').modal('show');
  }

});