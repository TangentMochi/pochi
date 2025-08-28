import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pochi/import.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pochi/views/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMap extends StatefulWidget {
  final String distance;
  // Stateful(this.distance);

  const MyMap({super.key, required this.distance});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;

  double currentDistance = 0; // 2地点での距離
  double currentSum = 0; // 現在歩いた距離
  double totalDistance = 0; // 今までに歩いた距離

  @override
  void initState() {
    super.initState();
    loadTotalDistance();
    requestLocationPermission().catchError((err) {}).then((temp) {
      getSetting().then((setting) {
        _positionStream =
            Geolocator.getPositionStream(locationSettings: setting).listen((
              position,
            ) {
              setState(() {
                _currentPosition = position;
              });
            });
      });
    });
  }

  void loadTotalDistance() async {
    final prefs = await SharedPreferences.getInstance();
    totalDistance = prefs.getDouble('totalDistance') ?? 0; // キーから値を取得、なければ0
    setState(() {
      totalDistance = prefs.getDouble('totalDistance') ?? 0; // キーから値を取得、なければ0
    });
  }

  void saveTotalDistance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalDistance', totalDistance); // キーに値を保存
  }

  @override
  void dispose() {
    _mapController.dispose();
    _positionStream.cancel();
    super.dispose();
  }

  void myLocationButton() {
    _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
        ),
      ),
    );
  }

  void calculateCurrentDistance() async {
    Position? startLocation;
    Position? lastLocation;

    startLocation = _currentPosition;
    // debugPrint('1段階');
    // debugPrint('startLocation, $startLocation');

    Timer.periodic(Duration(seconds: 5), (timer) async {
      lastLocation = await _currentPosition;
      debugPrint('lastLocation, $lastLocation');

      double temp = await getDistance(startLocation, lastLocation);
      // debugPrint('2段階, $temp');

      setState(() {
        currentDistance = temp;
        currentSum += currentDistance;
        startLocation = lastLocation;
      });
      // debugPrint('3段階');
      // debugPrint('currentSum, $currentSum');
      // debugPrint('startLocation, $startLocation');
      culculateTotalDistance();
    });
  }

  void culculateTotalDistance() async {
    // debugPrint('4段階, $totalDistance');
    double updateTotalDistance = await updateAndSaveTotalDistance(currentSum);

    setState(() {
      totalDistance = updateTotalDistance;
    });
  }

  void resultPage() {
    saveTotalDistance();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ResultPage(title: 'result', distanceValue: currentSum),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('${widget.distance}')),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,

            markers: {
              Marker(
                markerId: MarkerId('currentLocation'),
                position: LatLng(37.7749, -122.4194),
              ),
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('現在の距離 $currentSum'), // 変数を表示
            ),
          ),
          Positioned(
            bottom: 40,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('今までに歩いた距離 $totalDistance'), // 変数を表示
            ),
          ),

          Positioned(
            // 現在位置
            bottom: 50,
            right: 20,
            child: FloatingActionButton(
              onPressed: myLocationButton,
              child: Icon(Icons.my_location),
            ),
          ),
          Positioned(
            // 距離計測スタート（消す）
            bottom: 200,
            right: 200,
            child: FloatingActionButton(
              onPressed: calculateCurrentDistance,
              child: Icon(Icons.start),
            ),
          ),
          Positioned(
            // リザルト画面へ移動（消す）
            bottom: 180,
            right: 100,
            child: FloatingActionButton(
              onPressed: resultPage,
              child: Icon(Icons.stop),
            ),
          ),
        ],
      ),
    );
  }
}
