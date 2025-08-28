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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pochi'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(250, 231, 117, 78),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => RouteCreate()));
              },
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyAchive(
                      title: 'My Achievements',
                    ), // Corrected line
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
