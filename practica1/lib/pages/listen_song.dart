import 'package:flutter/material.dart';

class ListenSong extends StatelessWidget {
  const ListenSong({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (() {}), icon: Icon(Icons.arrow_back)),
          title: const Text('Here you go'),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.favorite))],
        ),
        body: Center(
          child: Column(
            children: [
              Image.network(
                'https://i.scdn.co/image/d3acaeb069f37d8e257221f7224c813c5fa6024e',
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Infinity",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Feel Something",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text("Jaymes Young"),
                    Text("2017-06-23"),
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
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/spotify.png',
                          color: Colors.white,
                        ),
                        iconSize: 60,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/others.png',
                          color: Colors.white,
                        ),
                        iconSize: 50,
                      ),
                      IconButton(
                        onPressed: () {},
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
          ),
        ));
  }
}
