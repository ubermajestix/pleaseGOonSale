(function($){

  pleasegoonsale = {};

  pleasegoonsale.init = function(){
    pgos = pleasegoonsale;
    log('pgos!', window.location);
    // TODO who are you? Need current_user_id. 
    // Need to find a cookie (site should lay down cookie), or ask to login and lay down cookie. 
    
    // TODO add a help button
    
    //capture data and send it home
    var url = window.location.href;
    log('url', url);
    if(window.location.search){
      log('search!')
      pgos.search_match = window.location.search.match(/(\?|\&)(id\=)(\d+)/);
      log('match', pgos.search_match);
    }
    else{
      pleasegoonsale.error();
    }
    if(pgos.search_match.length >= 4){
      var sku = _.last(pgos.search_match);
      // TODO get product name, image_url, price, color, size(?)
      var price = $('#price').text().trim();
      var name = $('#productName').text().trim();
      var image_url = $('meta[name="imageURL"]').attr('content')
      var colors = []
      $("#tabBlock2 img").each(function(i,e){log($(e));colors.push({swatch_url: $(e).attr('src'), name: $(e).attr('alt')})})
      log('colors', colors, $("#tabBlock2 img").length)
      log(sku, name, price, image_url, colors)
      var item = {sku: sku, name: name, raw_price: price, image_url: image_url, store_url: url, raw_colors: colors}
      $.ajax({
        jsonp: 'jsonp',
        dataType: 'jsonp',
        url: 'http://localhost:9393/customer/item/create',
        // type: 'POST',
        data: {item:item},
        beforeSend:function(){},
        success: function(json){
          log(json)
          // TODO number of items on your rack
          // TODO link to rack 
          $('div.pleasegoonsale').html(' We put '+name+' on your pleaseGOonSale rack! <a href="#/customer/list/"url here');
        },
        error: function(){
          pleasegoonsale.error();
        }
      });
    }
    else{
      pleasegoonsale.error();
    }

  };
  pleasegoonsale.error = function(message){
    $('div.pleasegoonsale').html('Looks like we\'re having a problem. We have been notified. Try some helpful tips');
  };
  pleasegoonsale.close = function(){
    // TODO close button
  };
  
  function log() {if (window.console) {console.log.apply(console, arguments);}}
  // String trim() prototype ex: "  blah  ".trim() //=> "blah"
  if(typeof(String.prototype.trim) === "undefined"){String.prototype.trim = function(){return String(this).replace(/^\s+|\s+$/g, '');};}
  
})(jQuery);

var done_loading = true; //for the bookmarklet loader to know the file has been read
