window.App.Models.Transaction = Backbone.Model.extend({

  url: App.base_url + 'transactions.json?auth_token=' + App.auth_token()

});