import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future updateAndSaveTotalDistance(double currentSum) async {
  final prefs = await SharedPreferences.getInstance();

  double totalDistance = prefs.getDouble('totalDistance') ?? 0.0;

  totalDistance += currentSum;

  await prefs.setDouble('totalDistance', totalDistance);
  print('5段階, $totalDistance');

  return totalDistance;
}
