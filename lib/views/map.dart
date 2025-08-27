import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pochi/import.dart';
import 'package:geolocator/geolocator.dart';

class MyMap extends StatefulWidget {
  final String distance;
  // Stateful(this.distance);

  const MyMap({super.key, required this.distance});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _mapController;
  //late int _distance;
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    requestLocationPermission().catchError((err) {}).then((temp) {
      getSetting().then((setting) {
        print(setting.accuracy);
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

  @override
  void dispose() {
    _mapController.dispose();
    _positionStream.cancel();
    super.dispose();
  }

  // void _updateDistance(){
  //   setState(() {
  //     _distance = MyMap.distance;
  //   });
  // }

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

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      // appBar: AppBar(title: Text(widget.distance.toString())),
      appBar: AppBar(title: Text('${widget.distance}')),
      body: GoogleMap(
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
      floatingActionButton: FloatingActionButton(
        onPressed: myLocationButton,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
