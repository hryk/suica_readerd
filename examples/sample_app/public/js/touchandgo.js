// Touch and Go 
var connect_count = 0;
var CRLF = "\x0D\x0A";
var pull_socket;
var host = '127.0.0.1';
var port = 5000;

$(function(){
  $('#container').flashembed("/swf/kaisatsu3.swf");
  $("#container").children("object").attr("id", "movie")
  JSocket.init('/swf/JSocket.swf', swfloaded);  
});

function swfloaded() {
  $('#movie').get(0).stop_movie();
  console.log('initializing start.');
  pull_socket = new JSocket({
      "connectHandler": pullConnectHandler,
      "dataHandler"   : dataHandler,
      "closeHandler"  : closeHandler,
      "errorHandler"  : errorHandler
      });
  console.log('connecting...');
  pull_socket.connect( host , port );
  console.log('initializing finished.');
}

function pullConnectHandler() {
  console.log('pullconnecthander : called ');

  request = 
    "GET / HTTP/1.0" + CRLF +
    "Host: " + host + CRLF;

  pull_socket.write(request );
  pull_socket.writeFlush(CRLF);
  connect_count++;
}

function closeHandler(){
  console.log('---close---');
}

function errorHandler(str){
  console.log('---error---' + str);
}

function dataHandler(data){
  console.log(data);
  var json = $.parseJSON(data);
  if (typeof json['uuid']) {
    if (json['action'] == 'login') {
      $('#movie').get(0).play_movie();
    }
    else {
      $('#movie').get(0).stop_movie();
    }
    var log_idline = $('<li></li>').text(json['uuid'])
      var log_actline = $('<li></li>').text(json['action'])
      var ul = $('<ul></ul>').append(log_idline)
      ul.append(log_actline)
      $('#log').append(ul)
      // document.location = "http://masui.sfc.keio.ac.jp/orf09/" + json['uuid'] + '/1/';
  }
  return;
}

