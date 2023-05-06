import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myproject/google_maps/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const LatLng initialLocation = LatLng(44.439663, 26.096306);
const double cameraZoom = 12;
const double cameraTilt = 0;
const double cameraBearing = 0;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();


  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polygonLatLngs = [];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  @override
  void initState() {
    super.initState();

    _setMarker(point: initialLocation, markerId: const MarkerId('marker_1'));
  }

  void _setMarker({required LatLng point, MarkerId? markerId}) {
    setState(() {
      _markers.add(Marker(
        markerId: markerId ?? MarkerId('marker$_polygonIdCounter'),
        position: point,
      ));
    });
  }

  void _setPolygon() {
    _polygonIdCounter++;
    _polygons.add(Polygon(
      polygonId: PolygonId('polygon$_polygonIdCounter'),
      points: _polygonLatLngs,
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.transparent,
    ));

  }

  void _setPolyline(List<PointLatLng> points) {
    _polylineIdCounter++;
    _polylines.add(Polyline(
      polylineId: PolylineId('polyline$_polylineIdCounter'),
      width: 2,
      color: Colors.blue,
      points: points
        .map(
          (point) => LatLng(point.latitude, point.longitude)
        ).toList(),
    ));
  }

  static const CameraPosition _kMapCenter = CameraPosition(
    target: initialLocation,
    zoom: cameraZoom,
    tilt: cameraTilt,
    bearing: cameraBearing
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {},
                    ),
                    TextFormField(
                      controller: _destinationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  _refreshState();
                  var directions = await LocationService().getDirections(_originController.text, _destinationController.text);
                  _goToPlace(
                    directions['start_location']['lat'],
                    directions['start_location']['lng'],
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                    directions['end_location']['lat'],
                    directions['end_location']['lng'],
                  );
                  _setPolyline(directions['polyline']);
                }
              ),
            ],
          ),

          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              polylines: _polylines,
              initialCameraPosition: _kMapCenter,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng point) {
                setState(() {
                  _polygonLatLngs.add(point);
                  _setPolygon();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _refreshState() {
    _markers.clear();
    _polygons.clear();
    _polylines.clear();
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place
    double sourceLat,
    double sourceLng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
    double destinationLat,
    double destinationLng,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(sourceLat, sourceLng),
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing
      ),
    ));

    controller.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
        northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
      ),
      50.0
    ));

    _setMarker(point: LatLng(sourceLat, sourceLng), markerId: MarkerId(_originController.text));
    _setMarker(point: LatLng(destinationLat, destinationLng), markerId: MarkerId(_destinationController.text));
  }
}