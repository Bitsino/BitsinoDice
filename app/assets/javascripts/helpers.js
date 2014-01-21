Handlebars.registerHelper('dateFormat', function(context, block) {
  if (window.moment) {
    f = block.hash.format || "MMM Do, YYYY";
    return moment(context).format(f);
  } else {
    return context;
  }
});