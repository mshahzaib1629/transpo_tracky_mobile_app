import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PassengerTrackingMap extends StatefulWidget {
  PassengerTrackingMap({Key key}) : super(key: key);

  @override
  _PassengerTrackingMapState createState() => _PassengerTrackingMapState();
}

class _PassengerTrackingMapState extends State<PassengerTrackingMap> {
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
