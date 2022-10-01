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

class SongSearchNullState extends SongState {}

class SongVFavoritesState extends SongState {}

class SongFavoriteSuccessState extends SongState {}

class SongFavoriteRequestState extends SongState {
  final List<String> songInfo;

  SongFavoriteRequestState({required this.songInfo});

  @override
  List<Object> get props => [songInfo];
}

class SongFavoriteFailState extends SongState {}

class SongSearchSuccessState extends SongState {
  final List<String> songInfo;

  SongSearchSuccessState({required this.songInfo});

  @override
  List<Object> get props => [songInfo];
}
