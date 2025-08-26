import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pochi/utils/get_location.dart';
import 'package:pochi/utils/location_permission_request.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final location = Location();
  late GoogleMapController mapController;
  late LatLng _center = const LatLng(37.7749, -122.4194);

  void button() {
    RequestLocationPermission.request(location).then((_) {
      getPosition(location).then((pos) {
        print(pos);
        mapController.moveCamera(
          CameraUpdate.newLatLng(LatLng(pos.latitude!, pos.longitude!)),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Map')),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(target: _center, zoom: 10),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: button,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
