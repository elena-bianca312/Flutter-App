import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationService {

  final String key = "AIzaSyC4QCgA8q0XMEIN1v60XPQG1uLgilYHVGI";

  // https://maps.googleapis.com/maps/api/place/search/xml?location=37.4419444,-122.1419444&radius=5000&name=food&sensor=false&key=YourAPIKey
  // https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key

  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&fields=place_id&key=$key';
    final response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'];

    print(placeId);
    return placeId;
  }


  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    final response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(String origin, String destination) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
    final response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    print(results);
    return results;
  }

  // void makePointFromLocationName (String location) {
  //   final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
  //   final response = http.get(Uri.parse(url));
  //   var json = convert.jsonDecode(response.body);
  //   var placeId = json['candidates'][0]['place_id'];


  // }
}