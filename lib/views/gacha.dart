
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: GachaView()));
}

class GachaView extends StatefulWidget {
  const GachaView({super.key});

  @override
  State<GachaView> createState() => GachaState();
}

class GachaState extends State<GachaView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    WidgetsBinding.instance!.addPostFrameCallback(
            (_) => _showAlert()
    );
  }

  Future<void> _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('注意'),
          content: const Text('この機能は信号待ち用です。\n歩きスマホは絶対にしないでください。'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('犬ガチャ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ElevatedButton(onPressed: () {}, child: const Text('ガチャを回す'))
          ],
        ),
      ),
    );
  }
}