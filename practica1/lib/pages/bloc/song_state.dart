part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongRecordingState extends SongState {}

class SongErrorState extends SongState {}

class SongSearchState extends SongState {}
