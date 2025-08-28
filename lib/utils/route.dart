import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Route {
  final client = http.Client();
  List<RouteSpot> spots = List.empty(growable: true);

  void addSpot(RouteSpot spot) {
    spots.add(spot);
  }

  void removeSpot(RouteSpot spot) {
    spots.remove(spot);
  }

  void clearSpot() {
    spots.clear();
  }

  List<RouteSpot> computeRoute() {
    // TODO
    return spots;
  }
}

class RouteSpot {
  late Marker _marker;
  late MarkerId _markerId;
  late LatLng _position;
  late String _title;
  late String _snippet;

  Marker get marker => _marker;
  MarkerId get markerId => _markerId;
  LatLng get position => _position;
  String get title => _title;
  String get snippet => _snippet;

  RouteSpot(LatLng position, MarkerId markerId, String? title, String? snippet, Function(RouteSpot) onTap) {
    _position = position;
    _markerId = markerId;
    _title = title ?? '';
    _snippet = snippet ?? '';
    _marker = Marker(
      markerId: markerId,
      position: position,
      onTap: () {
        onTap(this);
    });
  }
}