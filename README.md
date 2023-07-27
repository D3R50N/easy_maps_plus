# EasyMapPlus

EasyMapPlus is a Flutter package that provides a simple and easy-to-use widget to display driving directions on a Google Map. With EasyMap, you can easily plot polylines between multiple coordinates and optionally display markers for the origin and destination points.

## Installation

To use EasyMapPlus, add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_map_plus: 0.1.2
```

Then, run `flutter pub get` to fetch the package.

## Usage

To use the EasyMap widget, simply import the package and include it in your Flutter app. Here's an example of how to use it:

```dart
import 'package:flutter/material.dart';
import 'package:easy_map_plus/easy_map_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('EasyMapPlus Example'),
        ),
        body: EasyMap(
          apiKey: 'API_KEY',
          coordinates: [
            LatLng(37.7749, -122.4194), // Origin
            LatLng(34.0522, -118.2437), // Destination
            // Add more waypoints as needed
          ],
          onMapCreated: (GoogleMapController controller) {
            // Map initialization callback
          },
          destinationIcon: BitmapDescriptor.hueBlue, // default BitmapDescriptor.hueRed
          polylinesColor: Colors.blue,
          mapType: MapType.normal,
          showMarkers: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.7749, -122.4194),
            zoom: 15,
          ), // Defaults to the first coordinate in the `coordinates` list if not provided
        ),
      ),
    );
  }
}
```

## Widget Properties

The EasyMap widget supports the following properties:

- `apiKey` (required): Your Location IQ API key. You can obtain one from [the official website](https://us1.locationiq.com/).
- `coordinates` (required): A list of `LatLng` representing the waypoints for the driving directions. The first and last coordinates will be considered as the origin and destination, respectively.
- `onMapCreated` (required): A callback function that will be called when the GoogleMapController is ready to be used.
- `polylinesColor` (required): The color of the polylines that will be drawn on the map.
- `destinationIcon`: The hue of the color of the destination marker.
- `originIcon`: The hue of the color of the origin marker.
- `initialCameraPosition`: The initial camera position for the map. If not provided, it will default to the first coordinate in the `coordinates` list with a zoom level of 15.
- `mapType`: The type of map to display (e.g., normal, satellite, terrain, etc.). Defaults to `MapType.normal`.
- `showMarkers`: A boolean indicating whether to display markers for the origin and destination points. Defaults to `true`.

## Additional Information

- The `DrivingDirections` class is used internally to fetch driving directions from Google Maps. It decodes the response and extracts the necessary coordinates for drawing polylines on the map.
- If any error occurs while fetching the driving directions, an error message will be printed to the console.

## Contributing

If you find a bug or have a feature request, please file an issue on [GitHub](https://github.com/D3R50N/easy_maps_plus) or submit a pull request. All contributions are welcome!

Happy mapping!
