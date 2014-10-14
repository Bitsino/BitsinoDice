window.App.Collections.Transactions = Backbone.Collection.extend({

  model: App.Models.Transaction,

  url: App.base_url + 'transactions.json?auth_token=' + App.auth_token(),

});