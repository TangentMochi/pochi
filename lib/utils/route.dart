import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_config/flutter_config.dart';

import 'package:flutter_google_map_polyline_point/flutter_polyline_point.dart';
import 'package:flutter_google_map_polyline_point/point_lat_lng.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Route {
  final client = http.Client();
  List<RouteSpot> _spots = List.empty(growable: true);
  List<RouteSpot> get spots => _spots;
  int get length => _spots.length;

  void addSpot(RouteSpot spot) {
    var tmp = RouteSpot(spot.position, spot.markerId, spot.title, spot.snippet, (spot) {
      removeSpot(spot);
    });

    tmp.isSelected = true;
    _spots.add(tmp);
  }

  void removeSpot(RouteSpot spot) {
    for (var element in _spots) {
      if (element.markerId.value == spot.markerId.value) {
        _spots.remove(element);
        break;
      }
    }
  }

  void clearSpot() {
    _spots.clear();
  }

  Future<ResultRoute> computeRoute(LatLng origin, LatLng destination) async {
    var uri = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');
    /*
    polyline_points.PolylinePoints polylinePoints = polyline_points.PolylinePoints(apiKey: FlutterConfig.get('androidGoogleMapApiKey'));
    polyline_points.RoutesApiRequest polylineRequest = polyline_points.RoutesApiRequest(
      origin: polyline_points.PointLatLng(origin.latitude, origin.longitude),
      destination: polyline_points.PointLatLng(destination.latitude, destination.longitude),
      intermediates: _spots.map((spot) {
        return polyline_points.PolylineWayPoint(location: '${spot.position.latitude},${spot.position.longitude}');
      }).toList(),
      travelMode: polyline_points.TravelMode.walking,
      optimizeWaypointOrder: true
    );

    polyline_points.RoutesApiResponse res = await polylinePoints.getRouteBetweenCoordinatesV2(request: polylineRequest);
    */


    var res = await client.post(
      uri,
      headers: {
        'X-Goog-Api-Key': FlutterConfig.get('androidGoogleMapApiKey'),
        'X-Goog-FieldMask': 'routes.legs.polyline,routes.optimized_intermediate_waypoint_index,routes.distanceMeters,routes.duration'
      },
      body: json.encode({
        "origin": {
          "location": {
            "latLng" : {
              "latitude": origin.latitude,
              "longitude": origin.longitude
            }
          },
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": destination.latitude,
              "longitude": destination.longitude,
            }
          }
        },
        "intermediates": _spots.map((spot) {
          return {
            "location": {
              "latLng": {
                "latitude": spot.position.latitude,
                "longitude": spot.position.longitude
              }
            }
          };
        }).toList(),
        "travelMode": "WALK",
        "computeAlternativeRoutes": false,
        "languageCode": "ja-JP",
        "units": "METRIC"
      })
    );


    if (res.statusCode != 200) {
      throw Exception('Failed to load route');
    }

    var body = json.decode(res.body);
    var legs = body['routes'][0]['legs'];

    /*
    if (!res.hasRoutes) {
      print(res.errorMessage);
      throw Exception('Failed to load route');
    }
    var route = res.routes.first;
    return ResultRoute(route.polylinePoints ?? [], route.distanceMeters ?? 0, route.duration ?? 0);
    */

    var points = PolylinePoints();
    List<List<PointLatLng>> pointsList = [];
    for (var leg in legs) {
      var polys = points.decodePolyline(leg['polyline']['encodedPolyline']);
      pointsList.add(polys);
    }

    var duaration = body['routes'][0]['duration'];
    return ResultRoute(pointsList, body['routes'][0]['distanceMeters'], 0);
  }
}

class ResultRoute {
  late List<List<PointLatLng>> _points;
  List<List<PointLatLng>> get points => _points;
  late int _distance;
  int get distance => _distance;
  late int _duration;
  int get duration => _duration;

  ResultRoute(List<List<PointLatLng>> points, int distance, int duration) {
    _points = points;
    _distance = distance;
    _duration = duration;
  }
}

class RouteSpot {
  late MarkerId _markerId;
  late LatLng _position;
  late String _title;
  late String _snippet;
  late Function(RouteSpot) _onTap;
  bool isSelected = false;

  MarkerId get markerId => _markerId;
  LatLng get position => _position;
  String get title => _title;
  String get snippet => _snippet;

  RouteSpot(LatLng position, MarkerId markerId, String? title, String? snippet, Function(RouteSpot) onTap) {
    _position = position;
    _markerId = markerId;
    _title = title ?? '';
    _snippet = snippet ?? '';
    _onTap = onTap;
  }

  Marker getMarker() {
    return Marker(
      markerId: markerId,
      position: position,
      icon: isSelected ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      onTap: () {
        _onTap.call(this);
      }
    );
  }

  @override
  String toString() {
    return '${markerId.value}: (${position.latitude}, ${position.longitude})\ntitle: $title\nsnippet: $snippet';
  }
}
