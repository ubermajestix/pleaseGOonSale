app = {};
app.flot_time_options = {
    
    xaxis: { mode: "time", timeformat: "%m/%d %h%p " } ,
    yaxis: { autoscaleMargin: 0.0002, minTickSize: 1, min: 0 },
    lines: { show: true, fill: false },
    points: { show: false },
    legend: { show: false },
    selection: { mode: "x" },
    grid: { hoverable: true, clickable: true, borderWidth:1, color: '#aaa', tickColor: '#444' }
}
app.flot_date_to_utc = function(flot_date, string_format){
  var raw_date = flot_date;
  var local_date =  new Date(raw_date);
  var local_offset = local_date.getTimezoneOffset() * 60000;
  var parsed_date = new Date(raw_date + local_offset) ;
  return $.datepicker.formatDate(string_format, parsed_date);
}

app.formatted_time = function(flot_date){
  var raw_date = flot_date;
  var local_date =  new Date(raw_date);
  var local_offset = local_date.getTimezoneOffset() * 60000;
  var parsed_date = new Date(raw_date + local_offset) ;
  // var parsed_date = local_date;
  
  var hours = parsed_date.getHours() > 12 ? parsed_date.getHours() - 12 : parsed_date.getHours()
  var minutes = parsed_date.getMinutes() > 9 ? parsed_date.getMinutes() : "0" + parsed_date.getMinutes()
  var date = $.datepicker.formatDate('m/d', parsed_date);
  return date + ' ' + hours + (parsed_date.getHours() > 12 ? 'pm' : 'am')
}

app.hover = function(selector){
  var previousPoint = null;
  $(selector).bind('plothover', function(e, pos, item){
    if (item) {
        if (previousPoint != item.datapoint) { //new point
          $.tipTipLite.hide()
            previousPoint = item.datapoint;
            var x = item.datapoint[0];
            var y = item.datapoint[1].toFixed(0);
            var text = app.formatted_time(x) + " " + y + " request" + (y > 1 ? "s" : "");
            $.tipTipLite(text, {mouse_event: item})
        }
    }
    else{
      $.tipTipLite.hide()
    }
  });
}

app.browser_graph = function(data){
  $.plot($("#browser_graph"), data, {
		series: {
			pie: { 
				show: true,
				radius: 0.6,
				offset:{top:0 , left:0}
			}
		},
		legend: {
			show: true,
			 position: "nw",
			 backgroundOpacity: 0.6,
  		 labelFormatter: function(label, series){
  		 	return label+' <span class="pie_label">'+Math.round(series.percent)+'%</span>'
  		 }
		}
	});
}

app.bind_graph_clicks = function(){
  $('div.graph_container').click(function(){
    var id ='';
    if($(this).find('div.user_graph').length != 0){
      id = $(this).find('div.user_graph').attr('id');
    }
    else{
      id = "slice_" + $(this).find('h4').text();
    }
    window.location.pathname = '/' + id.split('_').join('/');
    return false;
  });
};

app.reporting = function(){
  
  $("#from_date").datepicker();
  $("#to_date").datepicker();
  
}

$(function(){
  $('div.logo').click(function(){
    window.location.pathname = "/today"
    return false;
  }); 
  
  $('div.graph_container').click(function(){
    var id =''
    if($(this).find('div.user_graph').length != 0){
      id = $(this).find('div.user_graph').attr('id')
    }
    else{
      id = $(this).find('div.slice_graph').attr('id')
    }
    log('go to', '/' + id.split('_').join('/'))
    window.location.pathname = '/' + id.split('_').join('/')
    return false;
  });     
  
  $("tr.path").click(function(){
    id = $(this).attr('id').split('_')[1]
    $('tr#params_'+id).toggle()
    return false;
  });
  
  $('a.params').click(function(){
    $(this).hide()
    $('div#params').show('blind')
    return false;
  });
  
                  
})

function log(){
  if(window.console) {
    console.log.apply(console, arguments);
  }
}