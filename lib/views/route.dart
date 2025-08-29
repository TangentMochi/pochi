import 'dart:async';

import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_overpass/flutter_overpass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pochi/import.dart';
import 'package:geolocator/geolocator.dart';

class RouteCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RouteCreateState();
}

class _RouteCreateState extends State<RouteCreate> {
  final flutterOverpass = FlutterOverpass();

  late GoogleMapController _mapController;

  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;
  List<RouteSpot> _viewSpots = List.empty(growable: true);
  Route _route = Route();

  bool _isLocked = false;
  bool _isCollapsed = true;
  bool _isExpanded = false;
  final _bsbController = BottomSheetBarController();

  @override
  void initState() {
    _bsbController.addListener(_onBsbChanged);
    requestLocationPermission().catchError((err) {}).then((temp) {
      getPosition().then((position) {
        setState(() {
          _currentPosition = position;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _bsbController.removeListener(_onBsbChanged);
    _bsbController.dispose();
    _positionStream.cancel();
    super.dispose();
  }

  void _onBsbChanged() {
    if (_bsbController.isCollapsed && !_isCollapsed) {
      setState(() {
        _isCollapsed = true;
        _isExpanded = false;
      });
    } else if (_bsbController.isExpanded && !_isExpanded) {
      setState(() {
        _isCollapsed = false;
        _isExpanded = true;
      });
    }
  }

  void myLocationButton() {
    var newLatLng = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
    _mapController.animateCamera(CameraUpdate.newLatLng(newLatLng));
  }

  void fetchRouteSpots() async {
    final region = await _mapController.getVisibleRegion();
    final southWest = region.southwest;
    final northEast = region.northeast;

    var nodes = await flutterOverpass.rawOverpassQL(
      query:
          "("
          "node(${southWest.latitude}, ${southWest.longitude}, ${northEast.latitude}, ${northEast.longitude})[amenity];"
          "node(${southWest.latitude}, ${southWest.longitude}, ${northEast.latitude}, ${northEast.longitude})[leisure];"
          ");"
          "out;",
    );

    var temp = List<RouteSpot>.empty(growable: true);
    for (var element in nodes['elements']) {
      temp.add(
        RouteSpot(
          LatLng(element['lat'], element['lon']),
          MarkerId(element['id'].toString()),
          element['tags']['name'],
          element['tags']['amenity'],
          (spot) {
            askAddRouteSpot(spot);
          },
        ),
      );
    }
    setState(() {
      _viewSpots = temp;
    });
  }

  void askAddRouteSpot(RouteSpot spot) async {
    var ret = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RouteSpotView(spot: spot)),
    );
    if (ret is RouteSpot) {
      setState(() {
        _route.addSpot(spot);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }

    var markers = Set<Marker>();
    var exceptedIds = _route.spots.map((val) {
      return val.markerId.value;
    }).toList();

    for (var spot in _route.spots) {
      markers.add(spot.getMarker());
    }

    for (var spot in _viewSpots) {
      if (exceptedIds.contains(spot.markerId.value)) continue;
      markers.add(spot.getMarker());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pochi'),
        //backgroundColor: Color.fromARGB(250, 231, 117, 78),
      ),
      body: BottomSheetBar(
        willPopScope: true,
        controller: _bsbController,
        backdropColor: Colors.grey.shade300,
        locked: _isLocked,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
        borderRadiusExpanded: const BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.grey.withAlpha(150),
            spreadRadius: 5.0,
            blurRadius: 32.0,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        expandedBuilder: (scrollController) {
          return Material(
            color: Colors.white,
            child: CustomScrollView(
              controller: scrollController,
              shrinkWrap: true,
              slivers: [
                SliverAppBar(title: const Text('追加された経路')),
                SliverFixedExtentList(
                  itemExtent: 128,
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var spot = _route.spots[index];
                    return ListTile(
                      title: Text('${spot.title}'),
                      subtitle: Text(
                        '(${spot.position.latitude}, ${spot.position.longitude})',
                      ),
                      onTap: () {},
                    );
                  }, childCount: _route.length),
                ),
                SliverFillRemaining(
                  hasScrollBody: false, // スクロールビューの本体として機能しないことを指定
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_route.length < 1) {
                            return;
                          }

                          var ret = await _route.computeRoute(
                            LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                          );
                          // TODO: ここで遷移させる。

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyMap(route: ret),
                            ),
                          );
                        },
                        child: const Text('この経路でルートを生成する'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        body: GoogleMap(
          mapType: MapType.normal,
          onMapCreated: (controller) {
            _mapController = controller;
            fetchRouteSpots();
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            zoom: 20,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: markers,
          onCameraIdle: () {
            fetchRouteSpots();
          },
          onLongPress: (position) {
            askAddRouteSpot(
              RouteSpot(
                position,
                MarkerId(
                  'S${DateTime.now().millisecondsSinceEpoch.toString()}',
                ),
                '',
                '',
                (spot) {},
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: myLocationButton,
        child: Icon(Icons.my_location),
      ),
    );
  }
}

class RouteSpotView extends StatelessWidget {
  final RouteSpot _spot;
  const RouteSpotView({super.key, required RouteSpot spot}) : _spot = spot;

  void _popRouteSpot(BuildContext context) {
    Navigator.pop(context, _spot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('場所詳細')),
      body: Center(
        child: Column(
          children: [
            Text(_spot.toString()),
            ElevatedButton(
              onPressed: () {
                _popRouteSpot(context);
              },
              child: const Text('このポイントを経路に追加'),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteView extends StatelessWidget {
  final ResultRoute _route;
  late GoogleMapController _mapController;

  RouteView({super.key, required ResultRoute route}) : _route = route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('おさんぽルート')),
      body: Stack(
        children: [
          const Text('data'),
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _route.points.first.first.latitude,
                _route.points.first.first.longitude,
              ),
              zoom: 20,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: _route.points.map((val) {
              return Polyline(
                polylineId: PolylineId(
                  '${val.first.latitude},${val.first.longitude}',
                ),
                points: val.map((val) {
                  return LatLng(val.latitude, val.longitude);
                }).toList(),
                color: Colors.blue,
                width: 5,
              );
            }).toSet(),
          ),
        ],
      ),
    );
  }
}
