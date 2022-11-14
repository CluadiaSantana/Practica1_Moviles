part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();
  @override
  List<Object> get props => [];
}

class SongRecordEvent extends SongEvent {}

class SongVFavoritesEvent extends SongEvent {}

class SongLauncherEvent extends SongEvent {
  final String url;

  SongLauncherEvent({required this.url});

  @override
  List<Object> get props => [url];
}

class SongFavoriteRequestEvent extends SongEvent {
  final Map<String, dynamic> songInfo;

  SongFavoriteRequestEvent({required this.songInfo});

  @override
  List<Object> get props => [songInfo];
}

class SongFavoriteDeleteRequestEvent extends SongEvent {
  final int songIndex;

  SongFavoriteDeleteRequestEvent({required this.songIndex});

  @override
  List<Object> get props => [songIndex];
}
