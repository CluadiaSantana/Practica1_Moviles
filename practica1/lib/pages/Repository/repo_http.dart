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
      final result = jsonDecode(response.body)['result'];
      print(result);
      if (result == null) {
        Map<String, dynamic> infoSong = {};
        return infoSong;
      } else {
        Map<String, dynamic> infoSong = {
          'album': result?['album'],
          'title': result?['title'],
          'artist': result?['artist'],
          'release_date': result?['release_date'],
          'image': result?['spotify']['album']['images'][1]['url'],
          'apple': result?["apple_music"]["url"],
          'spotify': result?["spotify"]["external_urls"]["spotify"],
          'ext': result?["song_link"]
        };
        return infoSong;
      }
    } catch (e) {
      Map<String, dynamic> infoSong = {};
      return infoSong;
    }
  }
}
