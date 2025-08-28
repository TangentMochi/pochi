import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pochi/views/distanceAddPage.dart';

class ResultPageApp extends StatelessWidget {
  const ResultPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Result',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 110, 213, 132),
        ),
      ),
      home: const ResultPage(title: 'Result'),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.title});

  final String title;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int count = 0;
  double distanceValue = 25.0;
  double allDistanceValue = 20;

  void _resultBackPage() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DistanceAddPage(), // Corrected line
        ),
      );
    });
  }

  Map<int, bool> results = {10: false, 20: false, 30: false, 40: false};
  void judgment() {
    setState(() {
      results[10] = distanceValue >= 10;
      results[20] = distanceValue >= 20;
      results[30] = distanceValue >= 30;
      results[40] = distanceValue >= 40;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: const <Color>[
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Congratulation!!',
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Image.network(
                "https://as2.ftcdn.net/jpg/12/62/21/27/220_F_1262212788_LKYWL77LpOzkkTO82bgcoWDejICJnTrk.jpg",
              ),
              Text(
                "今回の記録$distanceValue m",
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "これまで走った距離$allDistanceValue m",
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resultBackPage,
        tooltip: 'Increment',
        child: const Icon(Icons.house),
      ),
    );
  }
}
