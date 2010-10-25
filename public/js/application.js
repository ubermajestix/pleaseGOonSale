app = {};
app.init = function(){
  // var url = "http://www.anthropologie.com/anthro/catalog/productdetail.jsp?id=" + sku
  // store url in database
  // fetch info about product every few minutes - or per request
  // $('div.iframe').append('')
  $.read
  anthro_url = "http://www.anthropologie.com/anthro/catalog/category.jsp?id=CLOTHES-DRESSES"
  $('iframe#anthro').attr('src', anthro_url)
  $('iframe#anthro').load(function(){
    // NO DICE!!!
    $(this).append('<script src="http://localhost:9393/js/loader.localhost.js"></script>')
  });
};
function log(){
  if(window.console) {
    console.log.apply(console, arguments);
  }
}