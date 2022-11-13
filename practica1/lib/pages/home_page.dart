import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';
import 'package:practica1/pages/listen_song.dart';
import 'package:practica1/pages/favorites.dart';
import 'package:practica1/pages/login/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 50),
            child: _listen(),
          ),
          _recordButtom(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  BlocProvider.of<SongBloc>(context).add(SongVFavoritesEvent());
                },
                color: Colors.white,
                child: Icon(
                  Icons.favorite_sharp,
                  color: Colors.black,
                ),
                shape: CircleBorder(),
              ),
              MaterialButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                },
                color: Colors.white,
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.black,
                ),
                shape: CircleBorder(),
              ),
            ],
          )
        ],
      ),
    ));
  }

  BlocBuilder<dynamic, dynamic> _listen() {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongRecordingState) {
          return Text(
            "Escuchando ...",
            style: TextStyle(fontSize: 20),
          );
        }
        return Text(
          "Toque para escuchar",
          style: TextStyle(fontSize: 20),
        );
      },
    );
  }

  BlocConsumer<SongBloc, SongState> _recordButtom() {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SongSearchState) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ListenSong()));
        } else if (state is SongVFavoritesState) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Favorites()));
        }
      },
      builder: (context, state) {
        if (state is SongRecordingState) {
          return _avatarGlow(context, true);
        }
        return _avatarGlow(context, false);
      },
    );
  }

  AvatarGlow _avatarGlow(BuildContext context, bool anima) {
    return AvatarGlow(
        animate: anima,
        glowColor: Colors.red,
        child: Material(
          shape: CircleBorder(),
          elevation: 1,
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              onPressed: () {
                BlocProvider.of<SongBloc>(context).add(SongRecordEvent());
              },
              icon: Image.asset('assets/music.png'),
              iconSize: 150,
            ),
            radius: 90,
          ),
        ),
        endRadius: 150);
  }
}
