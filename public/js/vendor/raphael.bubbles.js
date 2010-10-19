// Bubbles for RaphaelJS 1.2.4
// requires jQuery 1.4
// Raphael.bubbleGraph needs data, color and a label (sorta like in flot.js) [{data: [[x1,y1,r1]], color:'#DBFF00', label: 'wondertwins activate!'}, {data: [[x2,y2,r2], [x3,y3,r3]], color:'#5F3800', label: 'shape of an eagle'} ]
// ex:
//  paper.bubbleGraph(data, {height: , width:, hover:[in_fn,out_fn], click:fn})

    function Bubbles(bubble_array, paper, opts) {
      bubbles = this
      bubbles.colors = ['#2f80fb', '#ff5f88', '#ff9500', '#ffa038', '#00b6cc', '#cc3300', '#2f2ea2', 
      '#9900ff', '#aaaa99', '#6c891e', '#b71ef2', '#7681A9', '#CC9A00', '#43DBFC', 
      '#FC4366', '#8CA466'];
      bubbles.height       = opts.height // because ie can suck it
      bubbles.width        = opts.width // like for real, ie is not fun
      bubbles.font_size    = 11 // TODO opt
      bubbles.maximum_size = 60; // TODO opt
      bubbles.minimum_size = 10; // TODO opt
      bubbles.padding      = bubbles.width * 0.1 // 10% padding
      bubbles.border_width = 3; // TODO opt
      bubbles.border_color = '#7d7d7d' //opt
      bubbles.onClick      = opts.click //opt uses jquery
      bubbles.mouseIn      = opts.hover[0]
      bubbles.mouseOut     = opts.hover[1]
      parse_options(opts)
      
      // load up the data 
      // TODO this does not work for situations where I have two series of 5 bubbles each
      // right now i have 1 series per bubble - which isn't ideal
      series = []
      $.each(bubble_array, function(index,                                                                                                                                                                                       point) {
        if(point){
          
          if(!point.color)
            point.color = bubbles.colors[index%(bubbles.colors.length)];
          point.x = point.data[0]
          point.y = point.data[1]
          point.z = point.data[2]
          point.size = point.z
          series.push(point)
        }
      });
      bubbles.series = series
      if(bubbles.series.length>0){
        // log(bubbles.series.length, 'bubbles')
        setup_scaling()
     
        series.bubbles_sort_by('z', 'DESC') //reset sort to z to laydown biggest bubbles first

        bubbles.label_positions = []
      
        $.each(series, function(index, point){
          
          point.x = ((point.x - bubbles.range.x.min)*bubbles.x_scale) + bubbles.padding + bubbles.maximum_size
          point.y = ((point.y - bubbles.range.y.min)*bubbles.y_scale) + bubbles.padding + bubbles.maximum_size
          // point.z = point.z < bubbles.minimum_size ? bubbles.minimum_size : bubbles.maximum_size * point.z / bubbles.max_z
          point.z = bubbles.maximum_size * point.z / bubbles.max_z
          point.label_y = (point.y < bubbles.height/2) ? bubbles.padding : bubbles.height - bubbles.padding;
          bubbles.label_positions.push(point)
        
          // flip the label_y if its inside the bubble
          var label_to_y = point.label_y < point.y ? (point.label_y - point.y) : (point.y - point.label_y)
          if(label_to_y < point.z){
             point.label_y = (point.label_y == bubbles.padding) ?  bubbles.height - bubbles.padding : bubbles.padding;
           }
        
          //try to place the label so they don't overlap each other
          x_pad = bubbles.font_size
          $.each(bubbles.label_positions, function(index, p) {
            if(p!=point){
              if(p.x < (point.x + x_pad) && p.x > (point.x - x_pad)){
                if(point.label_y < (p.label_y + x_pad) && point.label_y > (p.label_y - x_pad)){
                  point.label_y = (point.label_y == bubbles.padding) ?  bubbles.height - bubbles.padding : bubbles.padding;
                }
              }
            }
          })
        
          render_bubbles(point)
          $(point.circle.node).hover(function(e){ bubbles.mouseIn(e, point)}, function(e){ bubbles.mouseOut(e, point)})
          $(point.circle.node).click(function(e){bubbles.onClick(e,point)})
          $(point.circle.node).css({cursor: 'pointer'})
        })
      }
      

      function setup_scaling(){
        bubbles.range     = series_range(series)
        padding           = bubbles.padding + bubbles.maximum_size
        x_width           = bubbles.width  - padding * 2 //new width to include padding and make sure the largest bubble fits
        y_width           = bubbles.height - padding * 2  
        bubbles.max_z     = bubbles.range.z.max
        bubbles.x_scale   = x_width/(bubbles.range.x.max - bubbles.range.x.min)
        bubbles.y_scale   = y_width/(bubbles.range.y.max - bubbles.range.y.min)
      }
      
      function series_range(series){
        $.each(series, function(index, point){ point.x_order = index})
        bubbles.range = { x: series.bubbles_min_max('x')}
        bubbles.range.y = series.bubbles_min_max('y')
        bubbles.range.z = series.bubbles_min_max('z')
        return bubbles.range
      }
      

      
      function render_bubbles(point){
        // lay down the line to the term label
        point.label_line = paper.path( "M" + point.x + " " +  point.y + "V" + point.label_y );
        point.label_line.attr( 'stroke-width', 1 );
        point.label_line.attr( 'stroke', point.color );
        point.label_line.attr( 'opacity', 0.5 );

        // lay down the shadow
        var shadow_padding = point.z*0.1 > 3 ? point.z*0.1 : 4 
        var shadow = paper.circle( point.x+shadow_padding, point.y+shadow_padding, point.z );
        shadow.attr( 'stroke-width', 0 );
        shadow.attr( 'fill', '#aaa' );      
        shadow.attr( 'opacity', 0.2);

        // Render base circle that is full color, no gradient, mostly trasparent   
        var base_circle = paper.circle( point.x, point.y, point.z );
        base_circle.attr( 'stroke-width', 3);
        base_circle.attr( 'stroke', '#fff' );
        base_circle.attr( 'fill', point.color );      
        base_circle.attr( 'opacity', 0.3 );

        // Render overlay circle that has gradient and is mostly transparent
        // hack to make gradient fill from color to a lightened version of its color
        point.circle = paper.circle( point.x, point.y, point.z );
        point.circle.attr( 'stroke-width', 3 );
        point.circle.attr( 'stroke', bubbles.border_color );
        // SVG-Gradient: ‹angle›-‹colour›[-‹colour›[:‹offset›]]*-‹colour›
        point.circle.attr( 'fill', point.color );      
        point.circle.attr( 'gradient', '315-' + point.color + '-#fff');
        point.circle.attr( 'opacity', 0.6 );
        
        // Render the label at 45 degree angle
        label_padding = 2
        point.label_y = point.label_y > point.y ? point.label_y + label_padding : point.label_y - label_padding
        point.text_label = paper.text(point.x, point.label_y, point.label.bubbles_truncate(10));
        point.text_label.attr( 'font-weight', 'bold' );
        point.text_label.attr( 'font-size', bubbles.font_size );  
        point.text_label.attr( 'fill', point.color );
        point.label_y > point.y ? point.text_label.attr( 'text-anchor', 'start' ) : point.text_label.attr( 'text-anchor', 'end' )
        point.text_label.rotate(45,point.x, point.label_y);
        
        point.label_line.toFront()
        return;
      }

      function parse_options(opts) {
          if (opts.border_color)
          bubbles.border_color = opts.border_color
      }

      function log() {if (window.console) {console.log.apply(console, arguments);}}
      
    }//end of bubbles

  
  Raphael.fn.bubbleGraph = function(data, opts) {
      var paper = this
      if (!opts)
        opts = {}
      var bubbles = new Bubbles(data, paper, opts)
      return bubbles
  }  
  
  String.prototype.bubbles_truncate = function(length){
    text = this
    if(text.length > length){
      text = text.substring(0, length) + '...'
    }
    return text
  }
  Array.prototype.bubbles_sort_by = function(sort_val, direction) {
    if(direction == 'DESC'){
      return this.sort(function(a,b){return b[sort_val] - a[sort_val]})
    }
    else{ //ASC by default
      return this.sort(function(a,b){return a[sort_val] - b[sort_val]})
    }
  };

  Array.prototype.bubbles_min_max = function(val) {
    this.bubbles_sort_by(val)
    return {min: this[0][val], max: this[this.length-1][val]}
  };