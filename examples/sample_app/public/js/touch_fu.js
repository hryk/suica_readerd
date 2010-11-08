// touch_fu

/* Usage:
 * $(function(){
 *    Touch_fu.init('127.0.0.1', '5000', {
 *      debug: 1,
 *      login: function(){
 *
 *      },
 *      logout: function(){
 *
 *      },
 *      close: function(){ # Optional
 *
 *      },
 *      error: function(){ # Optional
 *
 *      }
 *    })
 * });
 */
var CRLF = "\x0D\x0A";

function Touch_fu(){};
Touch_fu.VERSION = '0.01';

Touch_fu.default_error_handler = function(str){
  if ( typeof(console) )
    console.log('---error--- : ' + str);
};

Touch_fu.default_close_handler = function(){
  if ( typeof(console) )
    console.log('---close---');
};

Touch_fu.connect_handler = function(){//{{{
   request = 
    "GET / HTTP/1.0" + CRLF +
    "Host: " + Touch_fu.host + CRLF;

   Touch_fu.socket.write(request); 
   Touch_fu.socket.writeFlush(CRLF); 
};//}}}

Touch_fu.data_handler = function (data) {//{{{
  if ( Touch_fu.debug )
    console.log(data);
  var json = $.parseJSON(data);
  if (json['action'] == 'login') {
    Touch_fu.login_handler(json);
  }
  else if (json['action'] == 'logout') {
    Touch_fu.logout_handler(json);
  }
  return;
};//}}}

Touch_fu.swfloaded = function(){
  Touch_fu.socket = new JSocket({
      "connectHandler": Touch_fu.connect_handler,
      "dataHandler"   : Touch_fu.data_handler,
      "closeHandler"  : Touch_fu.close_handler,
      "errorHandler"  : Touch_fu.error_handler
  });
  Touch_fu.socket.connect(Touch_fu.host, Touch_fu.port);
};

Touch_fu.init = function(host, port, opt){
    Touch_fu.host = host;
    Touch_fu.port = port;

    if ( typeof(opt['debug']) ) {
      Touch_fu.debug = true;
    } 
    else {
      Touch_fu.debug = false;
    }

    if (typeof(opt['login']) == 'function') {
      Touch_fu.login_handler = opt['login'];
    }

    if (typeof(opt['logout']) == 'function') {
      Touch_fu.logout_handler = opt['logout'];
    }

    if (typeof(opt['close']) == 'function') {
      Touch_fu.close_handler = opt['close'];
    }
    else {
      Touch_fu.close_handler = Touch_fu.default_close_handler;
    }

    if (typeof(opt['error']) == 'function') {
      Touch_fu.error_handler = opt['login']
    }
    else {
      Touch_fu.error_handler = Touch_fu.default_error_handler;
    }
    JSocket.init('/swf/JSocket.swf', Touch_fu.swfloaded );
};
