import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final record = Record();
  SongBloc() : super(SongInitial()) {
    on<SongRecordEvent>(_onRecord);
    on<SongSearchEvent>(_onSearch);
  }

  FutureOr<void> _onRecord(SongEvent event, Emitter emit) async {
    // TODO: implement event handler
    emit(SongRecordingState());
    try {
      bool per = await record.hasPermission();
      if (per) {
        await record.start();
        await Future.delayed(Duration(seconds: 5));
        String? pathSong = await record.stop();
        emit(SongSearchState());
      }
    } catch (error) {
      emit(SongErrorState());
      throw Error();
    }
  }

  void _onSearch(SongEvent event, Emitter emit) {
    // TODO: implement event handler
    print("buscar");
    emit(SongSearchState());
  }
}
