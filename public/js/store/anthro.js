var anthro = {};
anthro.init = function(){
  alert('anthro loaded...');
  $('body').append("<div style='border: 1px solid'>I am a div element</div>");
};


function log(){
  if(window.console) {
    console.log.apply(console, arguments);
  }
};
 
anthro.done_loading = true;