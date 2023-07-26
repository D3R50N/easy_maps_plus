import 'dart:convert';
import 'package:http/http.dart' as http;

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
