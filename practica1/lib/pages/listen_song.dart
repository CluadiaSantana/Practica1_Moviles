import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';

class ListenSong extends StatelessWidget {
  const ListenSong({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Navegation();
  }

  BlocConsumer<SongBloc, SongState> _Navegation() {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is SongSearchSuccessState) {
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    icon: Icon(Icons.arrow_back)),
                title: const Text('Here you go'),
                actions: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<SongBloc>(context).add(
                            SongFavoriteRequestEvent(songInfo: state.songInfo));
                      },
                      icon: Icon(Icons.favorite))
                ],
              ),
              body: Center(
                child: _loadPage(),
              ));
        }
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  icon: Icon(Icons.arrow_back)),
              title: const Text('Here you go'),
            ),
            body: Center(
              child: _loadPage(),
            ));
      },
    );
  }

  BlocConsumer<SongBloc, SongState> _loadPage() {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SongFavoriteRequestState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Procesando...')));
        }
      },
      builder: (context, state) {
        if (state is SongSearchSuccessState) {
          return Column(
            children: [
              Image.network(
                state.songInfo[4],
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${state.songInfo[0]}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${state.songInfo[1]}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text("${state.songInfo[2]}"),
                    Text("${state.songInfo[3]}"),
                  ],
                ),
              ),
              Column(
                children: [
                  Text("Abrir con:", style: TextStyle(fontSize: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<SongBloc>(context)
                              .add(SongLauncherEvent(url: state.songInfo[6]));
                        },
                        icon: Image.asset(
                          'assets/spotify.png',
                          color: Colors.white,
                        ),
                        iconSize: 60,
                      ),
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<SongBloc>(context)
                              .add(SongLauncherEvent(url: state.songInfo[7]));
                        },
                        icon: Image.asset(
                          'assets/others.png',
                          color: Colors.white,
                        ),
                        iconSize: 50,
                      ),
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<SongBloc>(context)
                              .add(SongLauncherEvent(url: state.songInfo[5]));
                        },
                        icon: Image.asset(
                          'assets/apple.png',
                          color: Colors.white,
                        ),
                        iconSize: 50,
                      )
                    ],
                  )
                ],
              )
            ],
          );
        } else if (state is SongSearchState) {
          return Text("Esperando respuesta.....");
        }
        return Text("Cancion no encontrada");
      },
    );
  }
}
