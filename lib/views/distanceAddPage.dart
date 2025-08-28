import 'package:flutter/material.dart';
import 'package:pochi/views/achive.dart';
import 'package:pochi/views/map.dart';

class DistanceAddPage extends StatefulWidget {
  const DistanceAddPage({super.key});
  // final String title;

  @override
  State<DistanceAddPage> createState() => DistanceAddPageState();
}

class DistanceAddPageState extends State<DistanceAddPage> {
  String distance = '';
  final TextEditingController _controller = TextEditingController();

  void decidedDistance(text) {
    setState(() {
      distance = text;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      // )
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('歩きたい距離', style: TextStyle(fontSize: 20)),

            // スクロールできるやつ
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '距離を追加',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                decidedDistance(text);
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 176, 176),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyMap(distance: distance),
                  ),
                );
              },
              child: Text('距離を追加'),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const MyAchive(title: 'My Achievements'), // Corrected line
            ),
          );
        },
        tooltip: 'Achive',
        child: const Icon(Icons.celebration),
      ),
    );
  }
}
