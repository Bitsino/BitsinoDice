// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets  
//= require bootstrap-material-design
//= require chance.min
var initialise = function() {
  
  setInterval(function() { 
    //$('#bets').load('/bet_table');
  }, 2000); 
    
  var client_seed = chance.hash({length: 16});
  $('#client-seed').val(client_seed);
  $('#client-seed-form').val(client_seed);

  $("#probability-slider").noUiSlider({
      start: $('#start-prob').val(),
      connect: "lower",
      range: {
        min: 0.5,
        max: 99.5
      }
  });
  
  $("#probability-slider").on({
  	slide: function(){
      update_button_text();
  	},
  	change: function(){
      update_button_text();
  	}
  });

  $("#amount-slider").noUiSlider({
      start: parseInt($('#amount-hidden').val()),
      connect: "lower",
      range: {
        min: parseInt($('#range').val().split(',')[0]),
        max: parseInt($('#range').val().split(',')[1])
      }
  });
  
  $("#amount-slider").on({
  	slide: function(){
      update_button_text();
  	},
  	change: function(){
      update_button_text();
  	}
  });
  
  update_button_text();

  //$("#amount-slider").bind("slider:changed", function (event, data) {
  // update_button_text();
  //});

  //$("#probability-slider").bind("slider:changed", function (event, data) {
  // update_button_text();
  //});

  function update_button_text() {
 
   amount = $("#amount-slider").val();
   $('#amount-hidden').val(amount);
   prob = parseFloat($("#probability-slider").val()).toFixed(1);
   multiplier = (99 / prob).toFixed(2);
   profit = (amount * multiplier / 100000000.0).toFixed(4)
 
   $('#roll-prob').val(prob)
   $('#bet_profit').val(profit)
   $('#amount-view').val((amount / 100000000.00).toFixed(5));
   $('#bet_chance').val(prob + '%');
   $('#roll-button').val("Click for a " + prob + "% chance of multiplying your bet by " + multiplier);
  }
};

$(document).ready(initialise);
$(document).on('page:load', initialise);