import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'utils.dart';

class EasyMap extends StatefulWidget {
  final String apiKey;
  final List<LatLng> coordinates;
  final Function(GoogleMapController) onMapCreated;
  final Color polylinesColor;
  final CameraPosition? initialCameraPosition;
  final MapType mapType;
  final bool showMarkers;

  final double originIcon;
  final double destinationIcon;

  const EasyMap({
    super.key,
    required this.apiKey,
    required this.coordinates,
    required this.onMapCreated,
    required this.polylinesColor,
    this.mapType = MapType.normal,
    this.showMarkers = true,
    this.initialCameraPosition,
    this.originIcon = BitmapDescriptor.hueGreen,
    this.destinationIcon = BitmapDescriptor.hueRed,
  });

  @override
  EasyMapState createState() => EasyMapState();
}

class EasyMapState extends State<EasyMap> {
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getDrivingDirections();
  }

  Future<void> _getDrivingDirections() async {
    try {
      String coordinates = widget.coordinates
          .map((e) => '${e.longitude},${e.latitude}')
          .join(';');
      DrivingDirections directions =
          await DrivingDirections.fetchDirections(widget.apiKey, coordinates);
      setState(() {
        // Afficher les informations en debug
        debugPrint('Code: ${directions.code}');
        debugPrint('Nombre de routes: ${directions.routes.length}');
        debugPrint('Nombre de points: ${directions.waypoints.length}');

        String encodedPolyline =
            directions.routes[0].geometry; // première route
        polylineCoordinates = _decodePolyline(encodedPolyline);
      });
    } catch (e) {
      debugPrint('Oups: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        widget.onMapCreated(controller);
      },
      mapType: widget.mapType,
      polylines: {
        Polyline(
          polylineId: const PolylineId('route'),
          color: widget.polylinesColor,
          points: polylineCoordinates,
        ),
      },
      markers: widget.showMarkers
          ? {
              Marker(
                markerId: const MarkerId('origine'),
                position: widget.coordinates.first,
                icon: BitmapDescriptor.defaultMarkerWithHue(widget.originIcon),
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: widget.coordinates.last,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    widget.destinationIcon),
              ),
            }
          : {},
      initialCameraPosition: widget.initialCameraPosition ??
          CameraPosition(target: widget.coordinates.first, zoom: 15),
    );
  }
}
