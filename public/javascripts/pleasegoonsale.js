(function($){
  pleasegoonsale = {};
  
  pleasegoonsale.init = function(){
    pgos = pleasegoonsale;
    
    // TODO add a help button
    
    //capture data and send it home
    var url = window.location.href;
    log('url', url);
    if(window.location.search){
      pgos.search_match = window.location.search.match(/(\?|\&)(id\=)(\d+)/);
    }
    else{
      pleasegoonsale.error();
    }
    if(pgos.search_match && pgos.search_match.length >= 4){
      var sku = _.last(pgos.search_match);
      var price = $('#price').text().trim();
      var name = $('#productName').text().trim();
      var image_url = $('meta[name="imageURL"]').attr('content')
      var colors = []
      $("#tabBlock2 img").each(function(i,e){log($(e));colors.push({swatch_url: $(e).attr('src'), name: $(e).attr('alt')})})
      var item = {sku: sku, name: name, raw_price: price, image_url: image_url, store_url: "http://" + window.location.host + "/anthro/catalog/productdetail.jsp?id=" + sku, raw_colors: colors}
      log(item)
      log(api_key)
      log(host)
      $.ajax({
        jsonp: 'jsonp',
        dataType: 'jsonp',
        url: 'http://'+host + '/item/create',
        // type: 'POST',
        data: {item:item, api_key: api_key},
        beforeSend:function(){},
        success: function(json){
          log(json)
          if(json.error){
            pgos.error(json.error)
          }
          else{
            // TODO number of items on your rack
            // TODO link to rack
            $('div.pleasegoonsale').html(' We put '+name+' on your pleaseGOonSale rack! <a href="#/customer/list/"url here');
          }

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
    message = message ? message : 'Looks like we\'re having a problem. We have been notified. Try some helpful tips'
    $('div.pleasegoonsale').html(message);
  };
  pleasegoonsale.close = function(){
    // TODO close button
  };
  
  function log() {if (window.console) {console.log.apply(console, arguments);}}
  // String trim() prototype ex: "  blah  ".trim() //=> "blah"
  if(typeof(String.prototype.trim) === "undefined"){String.prototype.trim = function(){return String(this).replace(/^\s+|\s+$/g, '');};}
  
})(jQuery);

var done_loading = true; //for the bookmarklet loader to know the file has been read