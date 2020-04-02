import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerHomePageMap extends StatefulWidget {
  PassengerHomePageMap({Key key}) : super(key: key);

  @override
  _PassengerHomePageMapState createState() => _PassengerHomePageMapState();
}

class _PassengerHomePageMapState extends State<PassengerHomePageMap> {
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
