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
      SongVFavoritesEvent event, Emitter<SongState> emit) async {
    List<dynamic> list = await getList();
    emit(SongVFavoritesState());
    if (list.length > 0) {
      emit(SongVFavoritesAreState(favorite: list));
      dynamic cancion = list[0];
    } else {
      emit(SongVFavoritesNullState());
    }
  }

  FutureOr<void> _requestFavorite(
      SongFavoriteRequestEvent event, Emitter<SongState> emit) async {
    emit(SongFavoriteRequestState());
    emit(SongSearchSuccessState(songInfo: event.songInfo));
    List<dynamic> list = await getList();
    if (event.songInfo != null) {
      Map<String, dynamic> songInfo = event.songInfo;
      print(songInfo);
      if (list.length > 0) {
        for (dynamic song in list) {
          if (song['artist'] == songInfo['artist'] &&
              song['title'] == songInfo['title']) {
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
      emit(SongFavoriteSuccessState());
      emit(SongSearchSuccessState(songInfo: event.songInfo));
    }
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
      SongFavoriteDeleteRequestEvent event, Emitter<SongState> emit) async {
    List<dynamic> list = await getList();
    emit(SongFavoriteDeleteRequestState());
    emit(SongVFavoritesAreState(favorite: list));
    await Future.delayed(Duration(seconds: 2));
    int index = event.songIndex;
    list.removeAt(index);
    await FirebaseFirestore.instance
        .collection("favorites")
        .doc(_auth.currentUser!.uid)
        .update({'list_favorites': list});
    emit(SongFavoriteDelSuccRequestState());
    if (list.length > 0) {
      emit(SongVFavoritesAreState(favorite: list));
    } else {
      emit(SongVFavoritesNullState());
    }
  }

  FutureOr<List<dynamic>> getList() async {
    var user_canciones = await FirebaseFirestore.instance
        .collection("favorites")
        .doc(_auth.currentUser!.uid)
        .get();
    List<dynamic> lista = user_canciones.data()?['list_favorites'];
    return lista;
  }
}
