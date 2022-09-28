import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

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
            child: Text(
              "Toque para escuchar",
              style: TextStyle(fontSize: 20),
            ),
          ),
          AvatarGlow(
            glowColor: Colors.red,
            endRadius: 150.0,
            animate: true,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
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
                  onPressed: () {},
                ),
                radius: 90.0,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
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
}
