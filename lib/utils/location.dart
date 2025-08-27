import 'package:flutter/foundation.dart';
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
  if (defaultTargetPlatform == TargetPlatform.android) {
    return AndroidSettings(
        accuracy: await isPreciseLocation() ? LocationAccuracy.bestForNavigation : LocationAccuracy.low,
        distanceFilter: 0,
        forceLocationManager: true,
        intervalDuration: const Duration(microseconds: 1000),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
          "Pochi will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: false,
        )
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
    return AppleSettings(
      accuracy: await isPreciseLocation() ? LocationAccuracy.high : LocationAccuracy.low,
      activityType: ActivityType.fitness,
      distanceFilter: 0,
      pauseLocationUpdatesAutomatically: true,
      // Only set to true if our app will be started up in the background.
      showBackgroundLocationIndicator: false,
    );
  } else {
    return LocationSettings(
      accuracy: await isPreciseLocation() ? LocationAccuracy.bestForNavigation : LocationAccuracy.low,
    );
  }
}

