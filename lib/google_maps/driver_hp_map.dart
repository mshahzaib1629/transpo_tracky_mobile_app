import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomePageMap extends StatefulWidget {
  DriverHomePageMap({Key key}) : super(key: key);

  @override
  _DriverHomePageMapState createState() => _DriverHomePageMapState();
}

class _DriverHomePageMapState extends State<DriverHomePageMap> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(31.5626134, 74.3041532),
          zoom: 16,
        ),
      ),
    );
  }
}
