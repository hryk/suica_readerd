function on_login(json) {
  $('#movie').get(0).play_movie();
  setTimeout(function(){
      url_base = "http://localhost:4567/touched";
      url = url_base +"/"+json['base']+"/"+ json['uuid'];
      document.location = url
  }, 2000);
// var log_idline = $('<li></li>').text(json['uuid']);
// var log_actline = $('<li></li>').text(json['action']);
// var ul = $('<ul></ul>').append(log_idline);
// ul.append(log_actline);
// $('#log').append(ul);
}

function on_logout(json) {
//  var log_idline = $('<li></li>').text(json['uuid']);
//  var log_actline = $('<li></li>').text(json['action']);
//  var ul = $('<ul></ul>').append(log_idline);
//  ul.append(log_actline);
//  $('#log').append(ul);
}

$(function(){
    $('#container').flashembed("/swf/kaisatsu.swf");
    $("#container").children("object").attr("id", "movie");
    setTimeout(function(){$('#movie').get(0).stop_movie();}, 1000);

Touch_fu.init('127.0.0.1', '5000', {
                  debug : true,
                  login : on_login ,
                  logout: on_logout
                  });
});
