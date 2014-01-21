window.App.Views.CashoutModal = Backbone.View.extend({

  events: {
    'submit': 'process'
  },

  initialize: function() {
    this.model = new App.Models.Cashout();
    this.model.on('invalid', this.showValidationNotice, this);
  },

  showValidationNotice: function(model, error) {
    this.$el.find('form').before('<p>' + error + '</p>');
  },

  process: function(e) {
    e.preventDefault();

    var self = this;

    this.model.set({
      amount: parseFloat(this.$el.find('#amount').val()).toFixed(8),
      address: this.$el.find('#address').val()
    });

    this.model.save(
      {},
      {
        success: function(model, response, options) {
          App.trigger('updateBalance');

          self.$el.modal('hide');
        },
        error: function(model, xhr, options) {
          self.$el.find('form').remove();
          console.log(model);
          console.log(xhr);
          console.log(xhr.responseJSON)
          self.$el.find('.modal-body').append('<p>' + xhr + '</p>');
        }
      }
    );
  }

});