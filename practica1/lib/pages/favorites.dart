import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';
import 'package:practica1/pages/item_favorites.dart';

class Favorites extends StatelessWidget {
  const Favorites({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              icon: Icon(Icons.arrow_back)),
          title: const Text('Canciones favoritas'),
        ),
        body: Center(child: _listFavorite()));
  }

  BlocConsumer<SongBloc, SongState> _listFavorite() {
    return BlocConsumer<SongBloc, SongState>(listener: (context, state) {
      if (state is SongFavoriteDeleteRequestState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Procesando...')));
      }

      if (state is SongFavoriteDelSuccRequestState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Eliminado de favoritos...')));
      }
    }, builder: (context, state) {
      if (state is SongVFavoritesAreState) {
        return ListView.builder(
          itemCount: state.favorite.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemFavorites(content: state.favorite[index]);
          },
        );
      }
      return Text("No hay favoritos agregados");
    });
  }
}
