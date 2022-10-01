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
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Agregar a favoritos'),
                                content: Text(
                                  'El elemento será gregado a tus favoritos \n ¿Quieres continuar?',
                                  style: TextStyle(fontSize: 12),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      BlocProvider.of<SongBloc>(context).add(
                                          SongFavoriteRequestEvent(
                                              songInfo: state.songInfo));
                                    },
                                    child: Text('ACCEPT',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ],
                              );
                            });
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

        if (state is SongFavoriteSuccessState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Agregado a favoritos...')));
        }
        if (state is SongFavoriteFailState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Este titulo ya se encuentra en favoritos')));
        }
      },
      builder: (context, state) {
        if (state is SongSearchSuccessState) {
          return _dataSong(state.songInfo, context);
        } else if (state is SongSearchState) {
          return Text("Esperando respuesta.....");
        }
        return Text("Cancion no encontrada");
      },
    );
  }

  Column _dataSong(List<String> data, context) {
    return Column(
      children: [
        Image.network(
          data[4],
          width: double.infinity,
          fit: BoxFit.fitHeight,
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${data[0]}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "${data[1]}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text("${data[2]}"),
              Text("${data[3]}"),
            ],
          ),
        ),
        Column(
          children: [
            Text("Abrir con:", style: TextStyle(fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buttomUrl(context, data[6], 'assets/spotify.png'),
                _buttomUrl(context, data[7], 'assets/others.png'),
                _buttomUrl(context, data[5], 'assets/apple.png')
              ],
            )
          ],
        )
      ],
    );
  }

  IconButton _buttomUrl(context, String url, String imaf) {
    return IconButton(
      onPressed: () {
        BlocProvider.of<SongBloc>(context).add(SongLauncherEvent(url: url));
      },
      icon: Image.asset(
        imaf,
        color: Colors.white,
      ),
      iconSize: 50,
    );
  }
}
