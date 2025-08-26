import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pochi/import.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // LocationData? _currentLocation;
  final location = Location();
  LocationData? _startPoint = null;
  LocationData? _lastPoint = null;

  void _requestLocationPermission() async {
    await RequestLocationPermission.request(location);
  }

  // void _getLocation() {
  //   GetLocation.getPosition(
  //     location,
  //   ).then((value) => setState(() => _currentLocation = value));
  // }

  void _startLocation() {
    GetLocation.getPosition(
      location,
    ).then((value) => setState(() => _startPoint = value));
  }

  void _lastLocation() {
    GetLocation.getPosition(
      location,
    ).then((value) => setState(() => _lastPoint = value));
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
              child: Text(
                '始点の座標：$_startPoint' + '終点の座標：$_lastPoint',
                style: Theme.of(context).textTheme.bodyLarge,
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
