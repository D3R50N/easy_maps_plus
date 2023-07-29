import 'package:flutter/material.dart';
import 'package:easy_maps_plus/easy_maps_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:example/.env.dart';

void main() async {
  EasyMap.init(API_KEY);
  var forward = await EasyMap.findPlaces('Paris');
  print(forward[0].displayName); // the name of the first place that matches
  var reverse = await EasyMap.findInfos(lat: '48.8566', long: '0.3522');
  print(reverse.displayName); // the name of the place
  print(reverse.address.city); // the city of the place
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
          coordinates: const [
            LatLng(37.7749, -122.4194),
            LatLng(37.7749, -122.5194),
            LatLng(37.8749, -122.4194),
            LatLng(37.8749, -122.5194),
          ],
          destinationIcon: BitmapDescriptor.hueBlue,
          onMapCreated: (GoogleMapController controller) {},
          polylinesColor: Colors.red,
          cameraTargetBounds: const CameraTargetBounds(null),
        ),
      ),
    );
  }
}
