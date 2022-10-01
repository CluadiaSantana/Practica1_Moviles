import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:record/record.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:practica1/secrets.dart';
import 'package:url_launcher/url_launcher.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final record = Record();
  List<List<String>> favorites = new List.empty(growable: true);
  SongBloc() : super(SongInitial()) {
    on<SongRecordEvent>(_onRecord);
    on<SongVFavoritesEvent>(_viewFavorite);
    on<SongFavoriteRequestEvent>(_requestFavorite);
    on<SongLauncherEvent>(_goOut);
  }

  FutureOr<void> _onRecord(SongEvent event, Emitter emit) async {
    // TODO: implement event handler
    emit(SongRecordingState());
    try {
      bool per = await record.hasPermission();
      if (per) {
        await record.start(
            encoder: AudioEncoder.aacLc, // by default
            bitRate: 128000,
            samplingRate: 44100 // by default
            );
        await Future.delayed(Duration(seconds: 5));
        var songRecord = await record.stop();
        if (songRecord != null) {
          emit(SongSearchState());
          List<String> infoSong = await _listen(songRecord);
          if (infoSong.length > 1) {
            emit(SongSearchSuccessState(songInfo: infoSong));
          } else {
            emit(SongSearchNullState());
          }
        }
      }
    } catch (error) {
      emit(SongErrorState());
      throw Error();
    }
  }

  FutureOr<List<String>> _listen(String songRecord) async {
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

  FutureOr<void> _viewFavorite(
      SongVFavoritesEvent event, Emitter<SongState> emit) {
    emit(SongVFavoritesState());
  }

  FutureOr<void> _requestFavorite(
      SongFavoriteRequestEvent event, Emitter<SongState> emit) {
    emit(SongFavoriteRequestState());
    if (event.songInfo != null) {
      List<String> currentSong = event.songInfo;
      if (favorites.indexOf(currentSong) < 0) {
        favorites.add(currentSong);
        print('añadido');
      }
      for (int i = 0; i < favorites.length; i++) {
        print(favorites[i][0]);
      }
    }

    emit(SongSearchSuccessState(songInfo: event.songInfo));
  }

  FutureOr<void> _goOut(
      SongLauncherEvent event, Emitter<SongState> emit) async {
    Uri url = Uri.parse(event.url);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
