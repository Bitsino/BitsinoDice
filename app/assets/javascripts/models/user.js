window.App.Models.User = Backbone.Model.extend({

  url: '/users',

  initialize: function() {
    this.on('change:balance', this.updateUserBalance, this);
  },

  updateUserBalance: function() {
    App.trigger('updateBalance');
  },
  
  randomString: function() {
  	var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
  	var string_length = 8;
  	var randomstring = '';
  	for (var i=0; i<string_length; i++) {
  		var rnum = Math.floor(Math.random() * chars.length);
  		randomstring += chars.substring(rnum,rnum+1);
  	}
  	return randomstring;
  }

});