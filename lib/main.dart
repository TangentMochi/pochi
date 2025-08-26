import 'package:flutter/material.dart';
import 'package:pochi/import.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // @override
  // void initState() {
  //   super.initState();
  //   Timer.periodic(const Duration(seconds: 5), flash);
  // }

  @override
  Widget build(BuildContext context) {
    const String title = 'Pochi';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyMap(),
    );
  }
}
