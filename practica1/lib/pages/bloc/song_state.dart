part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongRecordingState extends SongState {
  bool _animated = false;

  SongRecordingState(this._animated);
  @override
  List<Object> get props => [_animated];
}
