import 'package:practica1/secrets.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class httpReq {
  static final httpReq _singleton = httpReq._internal();

  factory httpReq() {
    return _singleton;
  }

  httpReq._internal();

  Future listen(String songRecord) async {
    var url = Uri.parse('https://api.audd.io/');
    print(songRecord);
    File file = new File(songRecord);
    String filebase = base64Encode(file.readAsBytesSync());
    print(filebase);
    try {
      var response = await http.post(url, body: {
        'api_token': API_TOKEN,
        'audio': filebase,
        'return': 'apple_music,spotify'
      });
      print(response.body);
      final result = jsonDecode(response.body)['result'];
      if (result == null) {
        List<String> infoSong = ['null'];
        return infoSong;
      } else {
        List<String> infoSong = [
          result?['album'],
          result?['title'],
          result?['artist'],
          result?['release_date'],
          result?['spotify']['album']['images'][1]['url'],
          result?["apple_music"]["url"],
          result?["spotify"]["external_urls"]["spotify"],
          result?["song_link"]
        ];
        return infoSong;
      }
    } catch (e) {
      List<String> infoSong = ['null'];
      return infoSong;
    }
  }
}
