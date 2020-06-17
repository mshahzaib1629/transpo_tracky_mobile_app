import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

class DriverNavigationMap extends StatefulWidget {
  DriverNavigationMap({Key key}) : super(key: key);

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
  GoogleMapController _controller;
  Timer _throttle;

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
        tripProvider.checkDistanceToNextStop(newLocalData);
        if (_throttle?.isActive ?? false) _throttle.cancel();
        _throttle = Timer(locationUpdatePeriod, () async {
          try {
            // await MapHelper.getDirections(
            //     newLocalData, tripProvider.driverCreatedTrip.driverNextStop);
            await MapHelper.updateDriverLocation(
                trip.mapTraceKey, newLocalData);
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
        });
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: newLocalData.heading,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 10.00)));
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
      bottom: 22.24 * SizeConfig.heightMultiplier,
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

  Widget _buildMap(BuildContext context) {
    print("no. of markers in nav page: ${_setOfMarkers.length}");
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
