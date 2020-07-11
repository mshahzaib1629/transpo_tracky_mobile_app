import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/firebase_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

class PassengerTrackingMap extends StatefulWidget {
  PassengerTrackingMap({Key key}) : super(key: key);

  @override
  _PassengerTrackingMapState createState() => _PassengerTrackingMapState();
}

class _PassengerTrackingMapState extends State<PassengerTrackingMap> {
  TripProvider tripProvider;
  Trip trip;
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
    tripProvider = Provider.of<TripProvider>(context, listen: false);
    trip = tripProvider.passengerSelectedTrip;
    getCurrentLocation();
    getStopLocation();
  }

  void getStopLocation() async {
    setState(() {
      _setOfMarkers.add(Marker(
        markerId: MarkerId(trip.passengerStop.id.toString()),
        position: LatLng(
          trip.passengerStop.latitude,
          trip.passengerStop.longitude,
        ),
        draggable: false,
        infoWindow:
            InfoWindow(title: trip.passengerStop.name),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<Uint8List> getBusMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/location_icons/bus_location.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/location_icons/user_location.png");
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
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: newLocalData.heading,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 16.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
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
      bottom: 26.24 * SizeConfig.heightMultiplier,
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

  void _updateDriverLocation(LatLng driverLocation) async {

    tripProvider.updateEsdToReachBus(driverLocation);
    
    Uint8List imageData = await getBusMarker();
    this.setState(() {
      _setOfMarkers.removeWhere((m) => m.markerId.value == "driver");
      _setOfMarkers.add(Marker(
          markerId: MarkerId("driver"),
          position: driverLocation,
          infoWindow: InfoWindow(title: trip.bus.plateNumber),
          // rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));
    });
  }

  Widget _buildMap(BuildContext context) {
    print('no. of markers in tracking page: ${_setOfMarkers.length}');
    return StreamBuilder(
        stream: FirebaseHelper.getDriverLocation(trip.mapTraceKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            LatLng driverLocation =
                LatLng(snapshot.data['lat'], snapshot.data['lng']);

            Future.delayed(Duration(milliseconds: 500))
                .then((value) => _updateDriverLocation(driverLocation));
          }
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            markers: _setOfMarkers,
            circles: _setOfCircles,
            compassEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              print('---------------------------------');
              print('tracking page map created');
              print('---------------------------------');
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildMap(context),
        _buildCurrentLocationButton(context),
      ],
    );
  }
}
