import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
//import 'package:location/location.dart' as prefix;
//import 'package:pochi/views/home.dart';

FutureOr<double?> getDistance(
  LocationData? startPoint,
  LocationData? lastPoint,
) async {
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

  // LocationData? startLocationValue = await HomeViewState().startPoint;
  // LocationData? lastLocationValue = await HomeViewState().lastPoint;

  if (startPoint == null || lastPoint == null) {
    return null;
  }
  double startLatitude = startPoint.latitude!;
  double startLongitude = startPoint.longitude!;
  double lastLatitude = lastPoint.latitude!;
  double lastLongitude = lastPoint.longitude!;

  double distanceInMeters = Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    lastLatitude,
    lastLongitude,
  );
  return distanceInMeters; // 距離をメートルで返す
}
