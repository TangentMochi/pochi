import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
//import 'package:location/location.dart' as prefix;
import 'package:pochi/views/home.dart';

FutureOr<double?> getDistance() async {
  // // 現在の位置を返す
  // final LocationSettings locationSettings = LocationSettings(
  //   accuracy: LocationAccuracy.best,
  //   distanceFilter: 100,
  // );

  // Position position = await Geolocator.getCurrentPosition(
  //   locationSettings: locationSettings,
  // );
  // print("緯度: " + position.latitude.toString());
  // print("経度: " + position.longitude.toString());

  // 距離をメートルで返す

  LocationData? startLocationValue = await HomeViewState().startPoint;
  LocationData? lastLocationValue = await HomeViewState().lastPoint;

  double? distanceInMeters = null;

  if (startLocationValue != null && lastLocationValue != null) {
    double startLatitude = startLocationValue.latitude!;
    double startLongitude = startLocationValue.longitude!;
    double lastLatitude = lastLocationValue.latitude!;
    double lastLongitude = lastLocationValue.longitude!;

    distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      lastLatitude,
      lastLongitude,
    );

    // print("距離: ${distanceInMeters.toStringAsFixed(2)} メートル");
    // return distanceInMeters;
  }
  return distanceInMeters;
}
