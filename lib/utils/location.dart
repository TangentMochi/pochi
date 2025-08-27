import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

Future<void> requestLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
}

Future<bool> isPreciseLocation() async {
  final status = await Geolocator.getLocationAccuracy();
  switch (status) {
    case LocationAccuracyStatus.reduced :
      return false;
    case LocationAccuracyStatus.precise :
      return true;
    default:
      return false;
  }
}

Future<double> getDistance(
    Position? startPoint,
    Position? lastPoint,
) async {
  if (startPoint == null || lastPoint == null) {
    return 0.0;
  }

  double startLatitude = startPoint.latitude;
  double startLongitude = startPoint.longitude;
  double lastLatitude = lastPoint.latitude;
  double lastLongitude = lastPoint.longitude;

  double distanceInMeters = Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    lastLatitude,
    lastLongitude,
  );
  return distanceInMeters;
}

Future<Position> getPosition() async {
  final setting = LocationSettings(
    accuracy: await isPreciseLocation() ? LocationAccuracy.bestForNavigation : LocationAccuracy.low
  );

  return Geolocator.getCurrentPosition(locationSettings: setting);
}

Future<LocationSettings> getSetting() async {
  return LocationSettings(
    accuracy: await isPreciseLocation() ? LocationAccuracy.bestForNavigation : LocationAccuracy.low
  );
}

