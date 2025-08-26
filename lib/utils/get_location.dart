import 'package:location/location.dart';

Future<LocationData> getPosition(Location location) async {
  final currentLocation = await location.getLocation();

  print('Date:${DateTime.now()}\nLocation:$currentLocation');

  return currentLocation;
}
