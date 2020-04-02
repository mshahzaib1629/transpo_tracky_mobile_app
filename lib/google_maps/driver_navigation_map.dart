import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverNavigationMap extends StatefulWidget {
  DriverNavigationMap({Key key}) : super(key: key);

  @override
  _DriverNavigationMapState createState() => _DriverNavigationMapState();
}

class _DriverNavigationMapState extends State<DriverNavigationMap> {
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
