import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  double sum = 0;

  final _audio = AudioPlayer();
  void BackPage() {
    _audio.play(AssetSource("cute_button.mp3"));

    Navigator.pop(context);
  }

  void loadTotalDistance() async {
    final prefs = await SharedPreferences.getInstance();
    sum = prefs.getDouble('totalDistance') ?? 0; // キーから値を取得、なければ0
    setState(() {
      sum = prefs.getDouble('totalDistance') ?? 0; // キーから値を取得、なければ0
    });
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _confettiController.play();
    loadTotalDistance();
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
        title: Text(
          'Pochi',
          style: GoogleFonts.alfaSlabOne(textStyle: TextStyle(fontSize: 30)),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              'My Achivements',
              style: GoogleFonts.dmSerifDisplay(
                textStyle: TextStyle(fontSize: 40),
              ),
            ),
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
            (sum >= 100)
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
                    color: Colors.grey,
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("100mで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 200)
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
                    color: Colors.grey,
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("200mで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 30000)
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
                        children: [Text("30kmで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 40000)
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
                        children: [Text("40kmで表示")],
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
        backgroundColor: Color.fromARGB(255, 197, 149, 105),
      ),
    );
  }
}
