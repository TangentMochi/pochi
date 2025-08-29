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
      appBar: AppBar(
        title: Text(
          'Pochi',
          style: GoogleFonts.alfaSlabOne(textStyle: TextStyle(fontSize: 30)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.pets, size: 40),
            Text(
              'おさんぽアプリ',
              style: GoogleFonts.cherryBombOne(
                textStyle: TextStyle(fontSize: 40),
                // color: Color.
              ),
            ),
            Text(
              'Pochi',
              style: GoogleFonts.alfaSlabOne(
                textStyle: TextStyle(fontSize: 60),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: const Text('Start', style: TextStyle(fontSize: 20)),
              onPressed: () {
                print('hi');
                _audio.play(AssetSource("1.mp3"));
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => RouteCreate()));
              },
            ),
            SizedBox(height: 30),

            ElevatedButton(
              child: const Text('Achievements', style: TextStyle(fontSize: 20)),
              onPressed: () {
                _audio.play(AssetSource("cute_button.mp3"));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyAchive(title: 'My Achievements'), // Corrected line
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
