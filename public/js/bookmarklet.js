javascript:(function(){var%20s=document.createElement('div');
api_key = '';
host = '';

s.style.display = 'none';

s.setAttribute('class','cleanslate pleasegoonsale');

s.innerHTML='<img src=\'images/loader.gif\'/> loading...';

document.body.appendChild(s);

s.setAttribute('id','pleasegoonsale');

s=document.createElement('script');

s.setAttribute('type','text/javascript');

s.setAttribute('src','http://localhost:9393/js/loader.localhost.js');

document.body.appendChild(s);

})()