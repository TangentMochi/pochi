import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pochi/import.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  // LocationData? _currentLocation;
  final location = Location();
  LocationData? startPoint = null;
  LocationData? lastPoint = null;
  double distance = 0;

  void _requestLocationPermission() async {
    await RequestLocationPermission.request(location);
  }

  // void _getLocation() {
  //   GetLocation.getPosition(
  //     location,
  //   ).then((value) => setState(() => _currentLocation = value));
  // }

  void _startLocation() async {
    var point = await getPosition(location);
    setState(() {
      startPoint = point;
    });
  }

  void _lastLocation() async {
    var point = await getPosition(location);
    setState(() {
      lastPoint = point;
    });
    _calculateDistance();
  }

  void _calculateDistance() async {
    //距離の計算
    var temp = await getDistance(startPoint, lastPoint);
    print(temp);
    setState(() {
      distance = temp ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    '始点の座標：$startPoint 終点の座標：$lastPoint',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text('始点と終点の距離：$distance'),
                ],
              ),
            ),
            Column(
              // alignment: MainAxisAlignment.center,
              // buttonPadding: const EdgeInsets.all(10),
              children: [
                SizedBox(
                  height: 50,
                  width: 105,
                  child: ElevatedButton(
                    onPressed: _requestLocationPermission,
                    child: const Text('request'),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 105,
                  child: ElevatedButton(
                    onPressed: _startLocation,
                    child: const Text('開始'),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 105,
                  child: ElevatedButton(
                    onPressed: _lastLocation,
                    child: const Text('終了'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
