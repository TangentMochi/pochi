import 'package:flutter/material.dart';

class Achivement extends StatelessWidget {
  const Achivement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achivement',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 160, 205, 233),
        ),
      ),
      home: const MyAchive(title: 'Achivement'),
    );
  }
}

class MyAchive extends StatefulWidget {
  const MyAchive({super.key, required this.title});

  final String title;
  @override
  State<MyAchive> createState() => _MyAchiveState();
}

class _MyAchiveState extends State<MyAchive> {
  void BackPage() {
    Navigator.pop(context);
  }

  double sum = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            (sum >= 10)
                ? Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 5),
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
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 5),
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
                      border: Border.all(color: Colors.blue, width: 5),
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
                      border: Border.all(color: Colors.blue, width: 5),
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
      backgroundColor: const Color.fromARGB(255, 185, 251, 255),
      floatingActionButton: FloatingActionButton(
        onPressed: BackPage,
        tooltip: 'Increment',
        child: const Icon(Icons.house),
      ),
    );
  }
}
