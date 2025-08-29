import 'package:flutter/material.dart';
import 'package:pochi/views/achive.dart';
import 'package:pochi/views/map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pochi/views/views.dart';
import 'package:audioplayers/audioplayers.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  // final String title;

  @override
  State<StartPage> createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  final _audio = AudioPlayer();

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pochi'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print('hi');
                _audio.play(AssetSource("1.mp3"));
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => RouteCreate()));
              },
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                _audio.play(AssetSource("mouse.mp3"));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyAchive(title: 'My Achievements'), // Corrected line
                  ),
                );
              },
              child: const Text('Achievements'),
            ),
          ],
        ),
      ),
    );
  }
}
