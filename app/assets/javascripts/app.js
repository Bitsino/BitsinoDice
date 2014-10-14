var scheme   = "ws://";
var uri      = scheme + window.document.location.host + "/";
var ws       = new WebSocket(uri);

window.App = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  base_url: window.document.location,

  auth_token: function() {
    return $.cookie('auth_token');
  },

  clientSeed: function() {
    return chance.hash({length: 16});
  },

  initialize: function() {
    App.Router = new App.Routers.Navigation();
    Backbone.history.start();
    
    $('#register').click(function() {
      new App.Views.RegistrationModal({ el: $('#registerModal').get(0) }).show();
      return false;
    })
  },

  login: function(model) {
    if (model) {
      $.cookie('auth_token', model.get('auth_token'));
      App.user = model;
    }
  },

  logout: function() {
    App.user = null;

    $.removeCookie('auth_token');

    window.location = '/';
  }
};

ws.onmessage = function(message) {
  App.bets.collection.add(new App.Models.Bet(JSON.parse(message.data)));
};

_.extend(App, Backbone.Events);

App.on('login', App.login, App);