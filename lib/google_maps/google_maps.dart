import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:myproject/google_maps/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';

const LatLng initialLocation = LatLng(44.439663, 26.096306);
const double cameraZoom = 12;
const double cameraTilt = 0;
const double cameraBearing = 0;

class MapPage extends StatefulWidget {

  final CloudShelterInfo shelter;
  final int shelterNumber;
  const MapPage({
    super.key,
    required this.shelter,
    required this.shelterNumber,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late final CloudShelterInfo _shelter = widget.shelter;
  late final FirebaseShelterStorage _sheltersService;

  Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _originController = TextEditingController();
  late final TextEditingController _destinationController = TextEditingController(text: _shelter.address);
  late String dropDownValue =  _shelter.address;
  late Set<String> _sheltersAddresses = {};

  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polygonLatLngs = [];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  @override
  void initState() {
    super.initState();
    _sheltersService = FirebaseShelterStorage();
    // _setShelters();

    // Future.delayed(Duration.zero,() async {
    //   _setShelters();
    // });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    _controller = Completer();
    super.dispose();
  }

  void _setMarker({required LatLng point, MarkerId? markerId}) {
    if (!mounted) return;
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
    print("Addresses:\n");
    print(_sheltersAddresses);
    return Scaffold(
            backgroundColor: Colors.greenAccent,
            appBar: AppBar(
              title: const Text('Google Maps'),
              backgroundColor: Colors.transparent,
            ),
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  polygons: _polygons,
                  polylines: _polylines,
                  initialCameraPosition: _kMapCenter,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _customInfoWindowController.googleMapController = controller;
                  },
                  onTap: (LatLng point) {
                    if (!mounted) return;
                    setState(() {
                      _polygonLatLngs.add(point);
                      _setPolygon();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[600]?.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextFormField(
                                controller: _originController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  hintStyle: subheader,
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (_originController.text == '' || _destinationController.text == '') return;
                                      _refreshState();
                                      var directions = await LocationService().getDirections(_originController.text, _destinationController.text);
                                      _drawLine(
                                        directions['start_location']['lat'],
                                        directions['start_location']['lng'],
                                        directions['bounds_ne'],
                                        directions['bounds_sw'],
                                        directions['end_location']['lat'],
                                        directions['end_location']['lng'],
                                      );
                                      _setPolyline(directions['polyline']);
                                    },
                                    icon: const Icon(Icons.search)
                                  ),
                                ),
                                style: subheader,
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[600]?.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextFormField(
                                controller: _destinationController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  // hintText: 'Search',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  hintStyle: subheader,
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (_destinationController.text == '') return;
                                      _refreshState();
                                      var place = await LocationService().getPlace(_destinationController.text);
                                      _goToPlace(place: place);
                                    },
                                    icon: const Icon(Icons.pin_drop)
                                  ),
                                ),
                                style: subheader,
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(height: 10),
                            // TODO
                            // doesnt work on reloading probably because it doesnt wait for
                            // _setShelters() to finish so _sheltersAddresses is not complete
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey[600]?.withOpacity(0.6),
                            //     borderRadius: BorderRadius.circular(16),
                            //   ),
                            //   child: DropdownButton(
                            //     value: dropDownValue,
                            //     // items: <String>['Dog', 'Cat', 'Tiger', 'Lion']
                            //     items: _sheltersAddresses
                            //         .map<DropdownMenuItem<String>>((String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Text(
                            //           value,
                            //           style: const TextStyle(fontSize: 30),
                            //         ),
                            //       );
                            //     }).toList(),
                            //     onChanged: (String? newValue) {
                            //       setState(() {
                            //         dropDownValue = newValue!;
                            //       });
                            //     },
                            //   )
                            // ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          );
  }

  void _refreshState() {
    // _markers.clear();
    _polygons.clear();
    _polylines.clear();
  }

  Future<void> _drawLine(
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

    // _setMarker(point: LatLng(sourceLat, sourceLng), markerId: MarkerId(_originController.text));
    _setMarker(point: LatLng(destinationLat, destinationLng), markerId: MarkerId(_destinationController.text));
  }

  Future<void> _goToPlace({required Map<String, dynamic> place}) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 16, tilt: cameraTilt, bearing: cameraBearing)
    ));
  }

  Future<void> _setShelterMarker({required Map<String, dynamic> place, String? markerId}) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    _setMarker(point: LatLng(lat, lng), markerId: markerId != null ? MarkerId(markerId) : MarkerId(_shelter.title));
  }

  Future<void> _setShelters() async {
    var shelters = await _sheltersService.getShelters();
    // ignore: avoid_function_literals_in_foreach_calls
    shelters.forEach((shelter) async {
      if (shelter.address != '') {
        var place = await LocationService().getPlace(shelter.address);
        _setShelterMarker(place: place, markerId: shelter.title);
        _sheltersAddresses.add(shelter.address);
      }
    });
    var place = await LocationService().getPlace(_shelter.address);
    _goToPlace(place: place);
    print('shelters ADDRESS');
    print(_sheltersAddresses);
  }

  @override
  bool get wantKeepAlive => false;
}
