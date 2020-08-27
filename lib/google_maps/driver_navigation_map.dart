import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_rest_page.dart';
import 'package:transpo_tracky_mobile_app/helpers/enums.dart';
import '../helpers/constants.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import '../helpers/firebase_helper.dart';

class DriverNavigationMap extends StatefulWidget {
  Function showEndTripDialog;

  DriverNavigationMap(this.showEndTripDialog);
  @override
  _DriverNavigationMapState createState() => _DriverNavigationMapState();
}

class _DriverNavigationMapState extends State<DriverNavigationMap> {
  TripProvider tripProvider;
  Trip trip;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Set<Marker> _setOfMarkers = {};
  Set<Circle> _setOfCircles = {};
  Set<Polyline> _setOfPolylines = {};
  GoogleMapController _controller;
  LocationData _lastCheckpoint;
  bool _restPageDisplayed = false;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(31.4826352, 74.0541966),
    zoom: 0,
  );

  @override
  void initState() {
    super.initState();
    tripProvider = Provider.of<TripProvider>(context, listen: false);
    trip = tripProvider.driverCreatedTrip;
    getCurrentLocation();
    getStopLocation();
  }

  void getStopLocation() async {
    final routeStops = trip.route.stopList;
    setState(() {
      routeStops.forEach((stop) {
        _setOfMarkers.add(Marker(
          markerId: MarkerId(stop.id.toString()),
          position: LatLng(
            stop.latitude,
            stop.longitude,
          ),
          draggable: false,
          infoWindow: InfoWindow(title: stop.name),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    });
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/location_icons/user_location.png");
    return byteData.buffer.asUint8List();
  }

  Future<void> updateDirections(LocationData updatedLocation) async {
    try {
      List<LatLng> directionPoints =
          await tripProvider.getDirections(updatedLocation);
      setState(() {
        _lastCheckpoint = updatedLocation;
        _setOfPolylines.removeWhere((p) => p.polylineId.value == 'direction');
        _setOfPolylines.add(Polyline(
          polylineId: PolylineId('direction'),
          color: Theme.of(context).accentColor,
          width: 8,
          points: directionPoints,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ));
      });
      await FirebaseHelper.updateDriverLocation(
          trip.mapTraceKey, updatedLocation);
    } catch (error) {
      showDialog(
          context: context,
          child: AlertDialog(
            content: Text('Internet Connection Failed!'),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Try Again'))
            ],
          ));
    }
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

      if (_lastCheckpoint == null) {
        await updateDirections(location);
      }

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) async {
        tripProvider.checkDistanceToNextStop(newLocalData);
        var locDiff = tripProvider.calculateDistance(
            newLocalData.latitude,
            newLocalData.longitude,
            _lastCheckpoint.latitude,
            _lastCheckpoint.longitude);

        if (trip.shareLiveLocation == false &&
            trip.driverNextStop.id == trip.route.stopList[0].id) {
          var distanceFromStop = tripProvider.calculateDistance(
            newLocalData.latitude,
            newLocalData.longitude,
            trip.driverNextStop.latitude,
            trip.driverNextStop.longitude,
          );
          if (distanceFromStop < (Constants.stopRadius + 0.5) &&
              _restPageDisplayed == false) {
            setState(() {
              _restPageDisplayed = true;
            });
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => RestPage()));
          }
        }

        if (trip.driverNextStop.id ==
            trip.route.stopList[trip.route.stopList.length - 1].id) {
          var distanceFromDestination = tripProvider.calculateDistance(
            newLocalData.latitude,
            newLocalData.longitude,
            trip.driverNextStop.latitude,
            trip.driverNextStop.longitude,
          );
          if (distanceFromDestination <= Constants.stopRadius)
            widget.showEndTripDialog();
        }

        //------------------------------------------------------

        print('last checkpoint: $_lastCheckpoint');
        print('distance from last checkpoint: $locDiff');

        if (locDiff > Constants.thresholdDistance) {
          await updateDirections(newLocalData);
        }
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: newLocalData.heading,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: Constants.mapZoomNavPage)));
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

  Widget _buildDistanceInfo(BuildContext context) {
    return Container(
      height: 5.625 * SizeConfig.heightMultiplier,
      width: 23.89 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
            blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
            blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
          ),
        ],
        borderRadius:
            BorderRadius.circular(4.45 * SizeConfig.imageSizeMultiplier),
      ),
      child: Center(
          child: Text(
        trip.driverNextStop.distanceFromUser ?? '0 km',
        style: Theme.of(context).textTheme.body2,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        getCurrentLocation();
      },
      backgroundColor: Colors.white,
      child: Icon(
        Icons.location_searching,
        color: Colors.black54,
        size: 7.78 * SizeConfig.imageSizeMultiplier,
      ),
    );
  }

  Widget _buildFloatingWidgets(BuildContext context) {
    return Positioned(
        bottom: 22.24 * SizeConfig.heightMultiplier,
        right: 4.86 * SizeConfig.widthMultiplier,
        left: 4.86 * SizeConfig.widthMultiplier,
        child: Row(
          mainAxisAlignment: trip.mode == TripMode.PICK_UP
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (trip.mode == TripMode.PICK_UP) _buildDistanceInfo(context),
            _buildCurrentLocationButton(context),
          ],
        ));
  }

  Widget _buildMap(BuildContext context) {
    print("no. of markers in nav page: ${_setOfMarkers.length}");
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialLocation,
      markers: _setOfMarkers,
      circles: _setOfCircles,
      polylines: _setOfPolylines,
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildMap(context),
        _buildFloatingWidgets(context),
      ],
    );
  }
}
