import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc() : super(SongInitial()) {
    on<SongRecordEvent>(_onRecord);
    on<SongSearchEvent>(_onSearch);
  }

  void _onRecord(SongEvent event, Emitter emit) {
    // TODO: implement event handler
    print("se escuchara");
    emit(SongRecordingState());
  }

  void _onSearch(SongEvent event, Emitter emit) {
    // TODO: implement event handler
    print("buscar");
    emit(SongSearchState());
  }
}
