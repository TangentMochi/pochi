import 'dart:convert';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class GachaView extends StatefulWidget {
  const GachaView({super.key});

  @override
  State<GachaView> createState() => GachaState();
}

class GachaState extends State<GachaView> {
  late ConfettiController _confettiController;
  String? _imageUrl = "https://images.dog.ceo/breeds/frise-bichon/4.jpg";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) => _showAlert());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
      },
    );
  }

  Future<void> _fetchGacha() async {
    setState(() {
      _imageUrl = null;
    });
    var uri = Uri.parse('https://dog.ceo/api/breeds/image/random');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      _confettiController.play();
      setState(() {
        _imageUrl = body.containsKey('message') ? body['message'] : null;
      });
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '犬ガチャ',
              style: GoogleFonts.delaGothicOne(
                textStyle: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 70),
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
            _imageUrl != null
                ? Container(
                    width: 300,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(255, 199, 152, 110),
                        width: 5,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(_imageUrl!, fit: BoxFit.cover),
                    ),
                  )
                : Container(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 300,
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
            SizedBox(width: 300, height: 25),
            ElevatedButton(
              onPressed: () {
                _fetchGacha();
              },
              child: const Text('ガチャを回す'),
            ),
          ],
        ),
      ),
    );
  }
}
