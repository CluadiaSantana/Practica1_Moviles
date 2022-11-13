import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/bloc/song_bloc.dart';
import 'package:practica1/pages/home_page.dart';
import 'package:practica1/pages/login/bloc/auth_bloc.dart';
import 'package:practica1/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => AuthBloc()..add(VerifyAuthEvent()),
    ),
    BlocProvider(create: (context) => SongBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        textButtonTheme: TextButtonThemeData(
          style:
              TextButton.styleFrom(textStyle: TextStyle(color: Colors.purple)),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: ((context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error al autenticase"),
              ),
            );
          }
        }),
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return Login();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
