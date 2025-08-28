import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:pochi/import.dart';
import 'package:pochi/views/startPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'Pochi';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 149, 60, 46),
          primary: Colors.black,
          surface: Color.fromARGB(255, 251, 230, 203),
        ),
        useMaterial3: true,
      ),
      home: StartPage(),
    );
  }
}
