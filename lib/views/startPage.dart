import 'package:flutter/material.dart';
import 'package:pochi/views/achive.dart';
import 'package:pochi/views/map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pochi/views/views.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  // final String title;

  @override
  State<StartPage> createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('スタートページ'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
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
              tooltip: 'Achive',
              child: const Icon(Icons.celebration),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => RouteCreate()));
              },
              tooltip: 'routeCreate',
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
