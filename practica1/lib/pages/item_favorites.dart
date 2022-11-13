import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';

class ItemFavorites extends StatelessWidget {
  final Map<String, dynamic> content;
  final index;
  ItemFavorites({Key? key, required this.content, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.network(
              content['image'],
              fit: BoxFit.fill,
            )),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  onPressed: () {
                    _showdialog(context, 'Abrir cancion',
                        'Sera redirigido a ver opciones para abir la cancion \n ¿Quieres continuar?');
                  },
                  icon: Icon(
                    Icons.square,
                    color: Color.fromARGB(0, 255, 82, 82),
                  ),
                )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
                child: Container(
                    height: 70,
                    color: Color.fromARGB(255, 72, 99, 255),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          content['title'],
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(content['album'])
                      ],
                    )),
              ),
            ),
            Positioned(
                child: IconButton(
              onPressed: () {
                _showdialog(context, 'Eliminar de favoritos',
                    'El elemento será eliminado de tus favoritos \n ¿Quieres continuar?');
              },
              icon: Icon(
                Icons.favorite_sharp,
                color: Colors.redAccent,
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showdialog(
      BuildContext context, String texto, String pregunta) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(texto),
            content: Text(
              pregunta,
              style: TextStyle(fontSize: 12),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              _delete(context, texto),
            ],
          );
        });
  }

  TextButton _delete(BuildContext context, String text) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (text == 'Eliminar de favoritos') {
          BlocProvider.of<SongBloc>(context)
              .add(SongFavoriteDeleteRequestEvent(songIndex: index));
        } else {
          BlocProvider.of<SongBloc>(context)
              .add(SongLauncherEvent(url: content['ext']));
        }
      },
      child: Text('ACCEPT',
          style: TextStyle(color: Theme.of(context).primaryColor)),
    );
  }
}
