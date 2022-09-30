import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';

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
          MaterialButton(
            onPressed: () {
              BlocProvider.of<SongBloc>(context).add(SongSearchEvent());
            },
            color: Colors.white,
            child: Icon(
              Icons.favorite_sharp,
              color: Colors.black,
            ),
            shape: CircleBorder(),
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
}

BlocConsumer<SongBloc, SongState> _recordButtom() {
  return BlocConsumer<SongBloc, SongState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      if (state is SongRecordingState) {
        return AvatarGlow(
          glowColor: Colors.red,
          endRadius: 150.0,
          animate: true,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: Duration(milliseconds: 10),
          child: Material(
            // Replace this child with your own
            elevation: 1.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                icon: Image.asset(
                  'assets/music.png',
                ),
                iconSize: 150,
                onPressed: () {
                  BlocProvider.of<SongBloc>(context).add(SongRecordEvent());
                },
              ),
              radius: 90.0,
            ),
          ),
        );
      }
      return AvatarGlow(
        glowColor: Colors.red,
        endRadius: 150.0,
        animate: false,
        duration: Duration(milliseconds: 20),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 5),
        child: Material(
          // Replace this child with your own
          elevation: 1.0,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: Image.asset(
                'assets/music.png',
              ),
              iconSize: 150,
              onPressed: () {
                BlocProvider.of<SongBloc>(context).add(SongRecordEvent());
              },
            ),
            radius: 90.0,
          ),
        ),
      );
    },
  );
}