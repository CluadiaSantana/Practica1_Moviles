import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/pages/login/bloc/auth_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: Image.asset(
            'assets/login.gif',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          )),
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 250,
              child: Image.asset(
                'assets/music.png',
                scale: 3,
              )),
          Positioned(
            left: 0,
            right: 0,
            top: 200,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoogleAuthButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  },
                  text: "Iniciar con Google",
                  style: AuthButtonStyle(
                      buttonColor: Color.fromARGB(255, 5, 134, 9),
                      iconColor: Colors.white,
                      textStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      width: 350),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
