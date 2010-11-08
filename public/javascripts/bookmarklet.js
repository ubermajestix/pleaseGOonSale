javascript:(function(){var%20s=document.createElement('div');
api_key = '<-api_key->';
host = '<-host->';

s.style.display = 'none';

s.setAttribute('class','cleanslate pleasegoonsale');

s.innerHTML='<img src=\'http://<-host->/images/loader.gif\'/> loading...';

document.body.appendChild(s);

s.setAttribute('id','pleasegoonsale');

s=document.createElement('script');

s.setAttribute('type','text/javascript');

s.setAttribute('src','http://<-host->/javascripts/loader.js');

document.body.appendChild(s);

})()