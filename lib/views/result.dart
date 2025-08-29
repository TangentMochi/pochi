import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pochi/views/startPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class ResultPageApp extends StatelessWidget {
  final double distanceValue;
  const ResultPageApp({super.key, required this.distanceValue});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Result',

      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color.fromARGB(255, 110, 213, 132),
      //   ),
      // ),
      home: ResultPage(title: 'Result', distanceValue: distanceValue),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.title,
    required this.distanceValue,
  });

  final String title;
  final double distanceValue;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  int count = 0;
  double allDistanceValue = 0;

  void loadTotalDistance() async {
    final prefs = await SharedPreferences.getInstance();
    allDistanceValue = prefs.getDouble('totalDistance') ?? 0; // キーから値を取得、なければ0
    setState(() {
      allDistanceValue =
          prefs.getDouble('totalDistance') ?? 0; // キーから値を取得、なければ0
    });
  }

  late AnimationController _controller;
  late Animation<double> _animation;
  final _audio = AudioPlayer();
  @override
  void initState() {
    super.initState();
    // 画面が初期化された時にデータを読み込む
    loadTotalDistance();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resultBackPage() {
    _audio.play(AssetSource('cute_button.mp3'));
    setState(() {
      Navigator.popUntil(context, (route) {
        return route.isFirst;
      });
    });
  }

  Widget _buildRainbowShader(Widget child) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: <Color>[
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
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRainbowShader(
                    Text(
                      'Congratulation!!',
                      style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(10, 10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          blurRadius: 20,
                        ),
                        BoxShadow(
                          offset: const Offset(-10, -10),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "https://as2.ftcdn.net/jpg/12/62/21/27/220_F_1262212788_LKYWL77LpOzkkTO82bgcoWDejICJnTrk.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildRainbowShader(
                    Text(
                      "今回の記録${widget.distanceValue.toInt()} m",
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _buildRainbowShader(
                    Text(
                      "これまで走った距離${allDistanceValue.toInt()} m",
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
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
                "今回の記録${widget.distanceValue} m",
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
