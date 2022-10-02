import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
import 'package:practica1/pages/Repository/repo_http.dart';
import 'package:url_launcher/url_launcher.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final record = Record();
  final ht = httpReq();
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
          List<String> infoSong = await ht.listen(songRecord);
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
    emit(SongVFavoritesState());
    if (favorites.length > 0) {
      emit(SongVFavoritesAreState(favorite: favorites));
    } else {
      emit(SongVFavoritesNullState());
    }
  }

  FutureOr<void> _requestFavorite(
      SongFavoriteRequestEvent event, Emitter<SongState> emit) {
    emit(SongFavoriteRequestState());
    if (event.songInfo != null) {
      List<String> currentSong = event.songInfo;
      if (favorites.indexOf(currentSong) < 0) {
        favorites.add(currentSong);
        emit(SongFavoriteSuccessState());
      } else {
        emit(SongFavoriteFailState());
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
