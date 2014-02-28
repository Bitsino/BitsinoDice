window.App.Views.DepositModal = Backbone.View.extend({
  
  initialize: function() {
    App.on('login', this.renderQRCode, this);
  },

  renderQRCode: function() {
    var address = App.user.get('address');

    $(this).find('h3').text(address);

    new QRCode("qrcode", {
      text: address,
      width: 256,
      height: 256,
      colorDark : "#000000",
      colorLight : "#ffffff",
      correctLevel : QRCode.CorrectLevel.H
    });
  }

});