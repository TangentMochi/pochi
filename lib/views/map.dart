import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pochi/import.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class MyMap extends StatefulWidget {
  final ResultRoute route;

  const MyMap({super.key, required this.route});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;
  final _audio = AudioPlayer();

  double currentDistance = 0; // 2地点での距離
  double currentSum = 0; // 現在歩いた距離
  double totalDistance = 0; // 今までに歩いた距離
  int rest = 0; // 残りの距離

  @override
  void initState() {
    super.initState();
    loadTotalDistance();
    requestLocationPermission().catchError((err) {}).then((temp) {
      getPosition().then((position) {
        setState(() {
          _currentPosition = position;
        });
      });
      getSetting().then((setting) {
        _positionStream =
            Geolocator.getPositionStream(locationSettings: setting).listen((
              position,
            ) {
              setPosition(position);
            });
      });
    });
    calculateCurrentDistance();
  }

  Future<void> setPosition(Position position) async {
    setState(() {
      _currentPosition = position;
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ),
    );
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
    _audio.play(AssetSource('cute_button.mp3'));
    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ),
    );
  }

  void calculateCurrentDistance() async {
    Position? startLocation;
    Position? lastLocation;

    startLocation = _currentPosition;

    Timer.periodic(Duration(seconds: 5), (timer) async {
      lastLocation = await _currentPosition;
      debugPrint('lastLocation, $lastLocation');

      double temp = await getDistance(startLocation, lastLocation);

      setState(() {
        currentDistance = temp;
        currentSum += currentDistance;
        startLocation = lastLocation;
      });
      culculateTotalDistance();
    });
  }

  void culculateTotalDistance() async {
    double updateTotalDistance = await updateAndSaveTotalDistance(
      currentDistance,
    );

    setState(() {
      totalDistance = updateTotalDistance;
    });
  }

  void resultPage() {
    _audio.play(AssetSource('cute_button.mp3'));
    saveTotalDistance();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ResultPage(title: 'result', distanceValue: currentSum),
      ),
    );
  }

  void restDistance() {
    setState(() {
      rest = widget.route.distance - currentSum.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Pochi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            tooltip: 'Show Snackbar',
            onPressed: () {
              resultPage();
            },
          ),
        ],
      ),
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
              zoom: 18,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            polylines: widget.route.points.map((val) {
              return Polyline(
                polylineId: PolylineId(
                  '${val.first.latitude},${val.first.longitude}',
                ),
                points: val.map((val) {
                  return LatLng(val.latitude, val.longitude);
                }).toList(),
                color: Colors.blue,
                width: 5,
              );
            }).toSet(),
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
              child: Column(
                children: [
                  Text('現在の距離 ${currentSum.toInt()}'), // 変数を表示
                  Text('残り ${rest.toString()}'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('今までに歩いた距離 ${totalDistance.toInt()}'), // 変数を表示
            ),
          ),

          Positioned(
            // 現在位置
            bottom: 50,
            right: 20,
            child: FloatingActionButton(
              onPressed: myLocationButton,
              child: Icon(Icons.my_location),
              heroTag: 'location',
            ),
          ),
        ],
      ),
    );
  }
}
