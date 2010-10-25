var anthro = {}
anthro.init = function(){
  alert('anthro loaded')
  log('anthro loaded')
  var body = jQuery('iframe').contents().html()
  log(body)
}


function log(){
  if(window.console) {
    console.log.apply(console, arguments);
  }
}
var done_loading_anthro = '';