window.App.Views.TransactionRow = Backbone.View.extend({

  tagName: 'tr',
  
  template: HandlebarsTemplates['transaction_row'],

  initialize: function() {
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));

    return this;
  },

});