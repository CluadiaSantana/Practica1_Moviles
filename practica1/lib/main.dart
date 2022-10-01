import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';
import 'package:practica1/pages/home_page.dart';

void main() => runApp(BlocProvider(
      create: (context) => SongBloc(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      darkTheme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.purple),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
