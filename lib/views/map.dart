import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pochi/import.dart';
import 'package:geolocator/geolocator.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    requestLocationPermission().catchError((err) {

    }).then((temp) {
      getPosition().then((position) {
        setState(() {
          _currentPosition = position;
        });
      });
      getSetting().then((setting) {
        print(setting.accuracy);
        _positionStream = Geolocator.getPositionStream(locationSettings: setting).listen((position) {
          setPosition(position);
        });
      });
    });
  }

  Future<void> setPosition(Position position) async {
    var dist = await getDistance(_currentPosition, position);

    setState(() {
      _currentPosition = position;
    });
    _mapController.animateCamera(
        CameraUpdate.newLatLng(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        )
    );
  }

  void myLocationButton() {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
      )
    );
  }



  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Pochi')),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 20,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: myLocationButton,
        child: Icon(Icons.my_location),
      ),
    );
  }
}