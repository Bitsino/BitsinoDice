window.App.Views.DepositModal = Backbone.View.extend({
  
  initialize: function() {
    this.$el.on('show.bs.modal', this.showQRCode, this.relatedTarget);
  },

  showQRCode: function() {
    var address = $('#balance').data('address');

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