import 'package:flutter/material.dart';
import 'package:easy_maps_plus/easy_maps_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Easy Maps Plus'),
        ),
        body: EasyMap(
          apiKey: 'CLE API',
          coordinates: const [
            LatLng(37.7749, -122.4194),
            LatLng(37.7749, -122.5194),
            LatLng(37.8749, -122.4194),
            LatLng(37.8749, -122.5194),
          ],
          onMapCreated: (GoogleMapController controller) {},
          polylinesColor: Colors.red,
        ),
      ),
    );
  }
}
