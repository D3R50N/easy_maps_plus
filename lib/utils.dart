import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DrivingDirections {
  String code;
  List<Route> routes;
  List<Waypoint> waypoints;

  DrivingDirections(
      {required this.code, required this.routes, required this.waypoints});

  factory DrivingDirections.fromJson(Map<String, dynamic> json) {
    List<Route> routes = (json['routes'] as List)
        .map((routeJson) => Route.fromJson(routeJson))
        .toList();

    List<Waypoint> waypoints = (json['waypoints'] as List)
        .map((waypointJson) => Waypoint.fromJson(waypointJson))
        .toList();

    return DrivingDirections(
      code: json['code'],
      routes: routes,
      waypoints: waypoints,
    );
  }

  static Future<DrivingDirections> fetchDirections(
      String apiKey, String coordinates,
      {bool alternatives = false,
      bool steps = false,
      String geometries = 'polyline',
      String overview = 'full',
      bool annotations = false}) async {
    final String apiUrl =
        'https://us1.locationiq.com/v1/directions/driving/$coordinates';
    final String url =
        '$apiUrl?key=$apiKey&alternatives=$alternatives&steps=$steps&geometries=$geometries&overview=$overview&annotations=$annotations';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DrivingDirections.fromJson(data);
    } else {
      throw Exception('Impossible de récupérer les directions');
    }
  }
}

class Route {
  String geometry;
  List<Leg> legs;
  String weightName;
  double weight;
  double duration;
  double distance;

  Route({
    required this.geometry,
    required this.legs,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    List<Leg> legs =
        (json['legs'] as List).map((legJson) => Leg.fromJson(legJson)).toList();

    return Route(
      geometry: json['geometry'],
      legs: legs,
      weightName: json['weight_name'],
      weight: json['weight'].toDouble(),
      duration: json['duration'].toDouble(),
      distance: json['distance'].toDouble(),
    );
  }
}

class Leg {
  List<dynamic> steps;
  String summary;
  double weight;
  double duration;
  double distance;

  Leg({
    required this.steps,
    required this.summary,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      steps: json['steps'],
      summary: json['summary'],
      weight: json['weight'].toDouble(),
      duration: json['duration'].toDouble(),
      distance: json['distance'].toDouble(),
    );
  }
}

class Waypoint {
  String hint;
  double distance;
  String name;
  List location;

  Waypoint(
      {required this.hint,
      required this.distance,
      required this.name,
      required this.location});

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      hint: json['hint'],
      distance: json['distance'].toDouble(),
      name: json['name'],
      location:
          (json['location'] as List).map((loc) => loc.toDouble()).toList(),
    );
  }
}

class Geo {
  String placeId;
  String licence;
  String osmType;
  String osmId;
  String lat;
  String lon;
  String displayName;
  List<String> boundingBox;

  Geo({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.boundingBox,
  });
}

// Reverse Geocoding

class ReverseGeo extends Geo {
  Address address;
  ReverseGeo({
    required super.placeId,
    required super.licence,
    required super.osmType,
    required super.osmId,
    required super.lat,
    required super.lon,
    required super.displayName,
    required super.boundingBox,
    required this.address,
  });

  factory ReverseGeo.fromJson(Map<String, dynamic> json) {
    return ReverseGeo(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      lat: json['lat'],
      lon: json['lon'],
      displayName: json['display_name'],
      address: Address.fromJson(json['address']),
      boundingBox: List<String>.from(json['boundingbox']),
    );
  }

  static Future<ReverseGeo> fetchReverseGeo(
      {required String apiKey,
      required String lat,
      required String long}) async {
    const String apiUrl = 'https://us1.locationiq.com/v1/reverse';
    final String url = '$apiUrl?key=$apiKey&lat=$lat&lon=$long&format=json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ReverseGeo.fromJson(data);
    } else {
      throw Exception('Impossible de récupérer les infos');
    }
  }

  @override
  String toString() {
    return 'ReverseGeo{placeId: $placeId, lat: $lat, lon: $lon, displayName: $displayName, address: $address}';
  }
}

// Forward Geocoding
class ForwardGeo extends Geo {
  String classValue;
  String type;
  double importance;
  String icon;

  ForwardGeo({
    required super.placeId,
    required super.licence,
    required super.osmType,
    required super.osmId,
    required super.lat,
    required super.lon,
    required super.displayName,
    required super.boundingBox,
    required this.classValue,
    required this.type,
    required this.importance,
    required this.icon,
  });

  factory ForwardGeo.fromJson(Map<String, dynamic> json) {
    return ForwardGeo(
      placeId: json['place_id'],
      licence: json['licence'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      lat: json['lat'],
      lon: json['lon'],
      displayName: json['display_name'],
      boundingBox: List<String>.from(json['boundingbox']),
      classValue: json['class'],
      type: json['type'],
      importance: json['importance'] is double
          ? json['importance']
          : json['importance'].toDouble(),
      icon: json['icon'],
    );
  }

  static Future<List<ForwardGeo>> fetchForwardGeo(
      {required String apiKey, required String query}) async {
    const String apiUrl = 'https://us1.locationiq.com/v1/search';
    final String url = '$apiUrl?key=$apiKey&q=$query&format=json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => ForwardGeo.fromJson(e)).toList();
    } else {
      throw Exception('Impossible de récupérer les places');
    }
  }

  @override
  String toString() {
    return 'ForwardGeo{placeId: $placeId,  lat: $lat, lon: $lon, displayName: $displayName, classValue: $classValue, type: $type, importance: $importance, icon: $icon}';
  }
}

class Address {
  String tramStop;
  String road;
  String neighbourhood;
  String city;
  String state;
  String postcode;
  String country;
  String countryCode;

  Address({
    required this.tramStop,
    required this.road,
    required this.neighbourhood,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      tramStop: json['tram_stop'] ?? "",
      road: json['road'] ?? "",
      neighbourhood: json['neighbourhood'] ?? "",
      city: json['city'] ?? "",
      state: json['state'],
      postcode: json['postcode'] ?? "",
      country: json['country'] ?? "",
      countryCode: json['country_code'] ?? "",
    );
  }

  @override
  String toString() {
    return 'Address{city: $city, state: $state, country: $country, countryCode: $countryCode}';
  }
}

class Area {
  LatLng c1;
  LatLng c2;
  LatLng c3;

  Area({
    required this.c1,
    required this.c2,
    required this.c3,
  });

  bool hasInside(LatLng point) {
    double x = point.latitude;
    double y = point.longitude;

    double x1 = c1.latitude;
    double y1 = c1.longitude;

    double x2 = c2.latitude;
    double y2 = c2.longitude;

    double x3 = c3.latitude;
    double y3 = c3.longitude;

    double d1 = (x - x1) * (y2 - y1) - (y - y1) * (x2 - x1);
    double d2 = (x - x2) * (y3 - y2) - (y - y2) * (x3 - x2);
    double d3 = (x - x3) * (y1 - y3) - (y - y3) * (x1 - x3);

    return (d1 < 0 && d2 < 0 && d3 < 0) || (d1 > 0 && d2 > 0 && d3 > 0);
  }
}
