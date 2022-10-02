import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';

class ItemFavorites extends StatelessWidget {
  final List<String> content;
  ItemFavorites({Key? key, required this.content}) : super(key: key);

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
              content[4],
              fit: BoxFit.fill,
            )),
            Positioned(
                child: MaterialButton(
              onPressed: () {
                _redirigir(context);
                ;
              },
              child: Ink(
                width: double.infinity,
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
                          content[1],
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(content[0])
                      ],
                    )),
              ),
            ),
            Positioned(
                child: IconButton(
              onPressed: () {
                BlocProvider.of<SongBloc>(context).add(SongVFavoritesEvent());
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

  AlertDialog _eliminarFavoritos(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar de favoritos'),
      content: Text(
        'El elemento será eliminado de tus favoritos \n ¿Quieres continuar?',
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            BlocProvider.of<SongBloc>(context)
                .add(SongFavoriteRequestEvent(songInfo: content));
          },
          child: Text('ACCEPT',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }

  AlertDialog _redirigir(BuildContext context) {
    return AlertDialog(
      title: Text('Abrir cncion'),
      content: Text(
        'Sera redirigido a las opciones para abrir la cancion \n ¿Quieres continuar?',
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            BlocProvider.of<SongBloc>(context)
                .add(SongFavoriteRequestEvent(songInfo: content));
          },
          child: Text('ACCEPT',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }
}
