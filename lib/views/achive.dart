import 'package:flutter/material.dart';

class Achivement extends StatelessWidget {
  const Achivement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achivement',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
    setState(() {});
  }

  double sum = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            (sum >= 10)
                ? Image.network(
                    "https://hamarepo.com/writer/story/images/images/hamarepo/matsuyama_yusuke/2014/07/20140711pochi/000.JPG",
                    width: 250, // 画像の幅を250ピクセルに設定
                    height: 150, // 画像の高さを150ピクセルに設定
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
                ? Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvxF9_HXEMI3ahWw4WNZuiQqiGolR3IR5hEg&s",
                    width: 250,
                    height: 150,
                  )
                : Container(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 250,
                      height: 150,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("20kmで表示")],
                      ),
                    ),
                  ),
            SizedBox(height: 25),
            (sum >= 30)
                ? Image.network(
                    "https://images.dog.ceo/breeds/labradoodle/Cali.jpg",
                    width: 250,
                    height: 150,
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
            (sum >= 40)
                ? Image.network(
                    "https://images.dog.ceo/breeds/frise-bichon/4.jpg",
                    width: 250,
                    height: 150,
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
      floatingActionButton: FloatingActionButton(
        onPressed: BackPage,
        tooltip: 'Increment',
        child: const Icon(Icons.house),
      ),
    );
  }
}
