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

class SongVFavoritesNullState extends SongState {}

class SongVFavoritesAreState extends SongState {
  final List<dynamic> favorite;

  SongVFavoritesAreState({required this.favorite});

  @override
  List<Object> get props => [favorite];
}

class SongFavoriteSuccessState extends SongState {}

class SongVFavoritesSuccessState extends SongState {}

class SongFavoriteRequestState extends SongState {}

class SongFavoriteDeleteRequestState extends SongState {}

class SongFavoriteDelSuccRequestState extends SongState {}

class SongFavoriteFailState extends SongState {}

class SongSearchSuccessState extends SongState {
  final Map<String, dynamic> songInfo;

  SongSearchSuccessState({required this.songInfo});

  @override
  List<Object> get props => [songInfo];
}
