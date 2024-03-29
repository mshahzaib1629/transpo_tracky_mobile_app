import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:transpo_tracky_mobile_app/helpers/constants.dart';
import 'package:transpo_tracky_mobile_app/helpers/firebase_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';

class PassengerHomePageMap extends StatefulWidget {
  final passengerSelectedTrip;

  PassengerHomePageMap(this.passengerSelectedTrip);

  @override
  _PassengerHomePageMapState createState() => _PassengerHomePageMapState();
}

class _PassengerHomePageMapState extends State<PassengerHomePageMap> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Set<Marker> _setOfMarkers = {};
  Set<Circle> _setOfCircles = {};
  GoogleMapController _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(31.4826352, 74.0541966),
    zoom: 0,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getStopLocation() async {
    if (widget.passengerSelectedTrip != null) {
      setState(() {
        _setOfMarkers.removeWhere((m) => m.markerId.value == "stop");
        _setOfMarkers.add(Marker(
          markerId: MarkerId('stop'),
          position: LatLng(
            widget.passengerSelectedTrip.passengerStop.latitude,
            widget.passengerSelectedTrip.passengerStop.longitude,
          ),
          draggable: false,
          infoWindow: InfoWindow(
              title: widget.passengerSelectedTrip.passengerStop.name),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/location_icons/user_location.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getBusMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/location_icons/bus_location.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      _setOfMarkers.removeWhere((m) => m.markerId.value == "user");
      _setOfMarkers.add(Marker(
          markerId: MarkerId("user"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));

      _setOfCircles.removeWhere((c) => c.circleId.value == "user");
      _setOfCircles.add(Circle(
        circleId: CircleId("user"),
        radius: newLocalData.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latlng,
        fillColor: Colors.blue.withAlpha(40),
        strokeWidth: 0,
      ));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                bearing: newLocalData.heading,
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                tilt: 0,
                zoom: Constants.mapZoomHomePage,
              ),
            ),
          );
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void _updateBusLocation(LatLng busLocation) async {
    Uint8List imageData = await getBusMarker();
    this.setState(() {
      _setOfMarkers.removeWhere((m) => m.markerId.value == "bus");
      _setOfMarkers.add(Marker(
          markerId: MarkerId("bus"),
          position: busLocation,
          infoWindow:
              InfoWindow(title: widget.passengerSelectedTrip.bus.plateNumber),
          // rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return Positioned(
      bottom: 14.24 * SizeConfig.heightMultiplier,
      right: 4.86 * SizeConfig.widthMultiplier,
      child: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(
          Icons.location_searching,
          color: Colors.black54,
          size: 7.78 * SizeConfig.imageSizeMultiplier,
        ),
      ),
    );
  }

  Widget _googleMap() => GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: _setOfMarkers,
        circles: _setOfCircles,
        zoomControlsEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          print('---------------------------------');
          print('home page map created');
          print('---------------------------------');
        },
      );

  Widget _buildMap(BuildContext context) {
    print("no. of markers in homepage: ${_setOfMarkers.length}");
    return widget.passengerSelectedTrip != null
        ? StreamBuilder(
            stream: FirebaseHelper.getDriverLocation(
                widget.passengerSelectedTrip.mapTraceKey),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                LatLng busLocation =
                    LatLng(snapshot.data['lat'], snapshot.data['lng']);

                Future.delayed(Duration(milliseconds: 500))
                    .then((value) => _updateBusLocation(busLocation));
              }
              return _googleMap();
            })
        : _googleMap();
  }

  @override
  Widget build(BuildContext context) {
    getStopLocation();
    return Stack(
      children: <Widget>[
        _buildMap(context),
        _buildCurrentLocationButton(context),
      ],
    );
  }
}
