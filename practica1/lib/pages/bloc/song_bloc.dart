import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
import 'package:practica1/pages/Repository/repo_http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final record = Record();
  final ht = httpReq();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> list = [];
  List<Cancion> favorC = [];
  SongBloc() : super(SongInitial()) {
    on<SongRecordEvent>(_onRecord);
    on<SongVFavoritesEvent>(_viewFavorite);
    on<SongFavoriteRequestEvent>(_requestFavorite);
    on<SongLauncherEvent>(_goOut);
    on<SongFavoriteDeleteRequestEvent>(_delete);
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
          Map<String, dynamic> infoSong = await ht.listen(songRecord);
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

  FutureOr<void> _viewFavorite(
      SongVFavoritesEvent event, Emitter<SongState> emit) {
    getList();
    emit(SongVFavoritesState());
    if (list.length > 0) {
      emit(SongVFavoritesAreState(favorite: list));
      dynamic cancion = list[0];
      print(cancion['artist']);
    } else {
      emit(SongVFavoritesNullState());
    }
  }

  FutureOr<void> _requestFavorite(
      SongFavoriteRequestEvent event, Emitter<SongState> emit) async {
    emit(SongFavoriteRequestState());
    emit(SongSearchSuccessState(songInfo: event.songInfo));
    getList();
    if (event.songInfo != null) {
      Map<String, dynamic> songInfo = event.songInfo;
      print(songInfo);
      if (list.length > 0) {
        for (dynamic song in list) {
          if (song['image'] == songInfo['image']) {
            emit(SongFavoriteFailState());
            emit(SongSearchSuccessState(songInfo: event.songInfo));
            return;
          }
        }
      }
      list.add(songInfo);
      await FirebaseFirestore.instance
          .collection("favorites")
          .doc(_auth.currentUser!.uid)
          .update({'list_favorites': list});
      emit(SongSearchSuccessState(songInfo: event.songInfo));
    }
    //   List<String> currentSong = event.songInfo;
    //   try {} catch (e) {}
    //   Cancion k = new Cancion(
    //       currentSong[0],
    //       currentSong[1],
    //       currentSong[2],
    //       currentSong[3],
    //       currentSong[4],
    //       currentSong[5],
    //       currentSong[6],
    //       currentSong[7]);
    //   int p = favorC.indexWhere((element) => element.image == currentSong[4]);
    //   if (p < 0) {
    //     favorC.add(k);
    //     favorites.add(currentSong);
    //     emit(SongFavoriteSuccessState());
    //   } else {
    //     emit(SongFavoriteFailState());
    //   }
  }

  FutureOr<void> _goOut(
      SongLauncherEvent event, Emitter<SongState> emit) async {
    Uri url = Uri.parse(event.url);
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  FutureOr<void> _delete(
      SongFavoriteDeleteRequestEvent event, Emitter<SongState> emit) {
    // emit(SongFavoriteDeleteRequestState());
    // Map<String, dynamic> currentSong = event.songInfo;
    // Cancion k = new Cancion(
    //     currentSong[0],
    //     currentSong[1],
    //     currentSong[2],
    //     currentSong[3],
    //     currentSong[4],
    //     currentSong[5],
    //     currentSong[6],
    //     currentSong[7]);
    // favorites.remove(event.songInfo);
    // int p = favorC.indexWhere((element) => element.image == currentSong[4]);
    // favorC.removeAt(p);
    // emit(SongFavoriteDelSuccRequestState());
    // if (favorites.length > 0) {
    //   emit(SongVFavoritesAreState(favorite: favorites));
    // } else {
    //   emit(SongVFavoritesNullState());
    // }
  }

  dynamic getList() async {
    var user_canciones = await FirebaseFirestore.instance
        .collection("favorites")
        .doc(_auth.currentUser!.uid)
        .get();
    list = user_canciones.data()?['list_favorites'];
  }
}

class Cancion {
  String album;
  String title;
  String artist;
  String date;
  String image;
  String apple;
  String spotify;
  String ext;

  Cancion(this.album, this.title, this.artist, this.date, this.image,
      this.apple, this.spotify, this.ext);
}
