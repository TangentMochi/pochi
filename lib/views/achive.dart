import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

class Achivement extends StatelessWidget {
  const Achivement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Achive',
      home: MyAchive(title: 'My Achive'),
    );
  }
}

class MyAchive extends StatefulWidget {
  MyAchive({super.key, required this.title});

  final String title;
  @override
  State<MyAchive> createState() => _MyAchiveState();
}

class _MyAchiveState extends State<MyAchive> {
  late ConfettiController _confettiController;

  final _audio = AudioPlayer();
  void BackPage() {
    _audio.play(AssetSource("mouse.mp3"));

    Navigator.pop(context);
  }

  double sum = 60;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(250, 231, 117, 78),
        title: Text(
          widget.title,
          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -3.14 / 2,
              numberOfParticles: 20, // 1度に放出される粒子の数
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
            (sum >= 10)
                ? Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(255, 199, 152, 110),
                        width: 5,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        "https://images.dog.ceo/breeds/frise-bichon/4.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("10kmで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 20)
                ? Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 199, 152, 110),
                        width: 5,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        "https://hamarepo.com/writer/story/images/images/hamarepo/matsuyama_yusuke/2014/07/20140711pochi/000.JPG",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("10kmで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 30)
                ? Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(255, 199, 152, 110),
                        width: 5,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvxF9_HXEMI3ahWw4WNZuiQqiGolR3IR5hEg&s",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("10kmで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 40)
                ? Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(255, 199, 152, 110),
                        width: 5,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        "https://images.dog.ceo/breeds/labradoodle/Cali.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("10kmで表示")],
                      ),
                    ),
                  ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: BackPage,
        tooltip: 'Increment',
        child: const Icon(Icons.house),
      ),
    );
  }
}
