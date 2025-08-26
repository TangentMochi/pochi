import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pochi/import.dart';
import 'dart:async';

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
  // LocationData? lastPoint = null;
  LocationData? checkPoint = null;
  double distance = 0;
  double sum = 0;
  Timer? timer;

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
    _startMeasurement();
  }

  @override
  void _startMeasurement() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkPointLocation();
    });
  }

  void _checkPointLocation() async {
    var point = await getPosition(location);
    setState(() {
      checkPoint = point;
    });
    _calculateDistance();
  }

  void _calculateDistance() async {
    //距離の計算
    var temp = await getDistance(startPoint, checkPoint);
    print(temp);
    setState(() {
      distance = temp ?? 0;
    });
    _sumDistance();
  }

  void _sumDistance() async {
    // 測定した距離をsumに加算
    var temp = await distance;
    setState(() {
      sum += temp;
    });
    _locationReset();
  }

  void _locationReset() async {
    var last = await checkPoint;
    setState(() {
      startPoint = last;
    });
  }

  void _reset() {
    timer?.cancel();
    setState(() {
      startPoint = null;
      checkPoint = null;
      distance = 0;
      sum = 0;
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
                    '始点の座標：$startPoint',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text('チェックポイントの座標：$checkPoint'),
                  Text('始点とチェックポイントの距離：$distance'),
                  Text('距離の合計 $sum'),
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
                // SizedBox(
                //   height: 50,
                //   width: 105,
                //   child: ElevatedButton(
                //     onPressed: _checkPointLocation,
                //     child: const Text('チェックポイント'),
                //   ),
                // ),
                SizedBox(
                  height: 50,
                  width: 105,
                  child: ElevatedButton(
                    onPressed: _reset,
                    child: const Text('停止'),
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
