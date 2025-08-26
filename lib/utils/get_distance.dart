import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as prefix;

class GetDistance {
  Future<void> getLocation() async {
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

    double distanceInMeters = Geolocator.distanceBetween(
      35.68,
      139.76,
      -23.61,
      -46.40,
    );
    print("距離: ${distanceInMeters.toStringAsFixed(2)} メートル");
  }
}
