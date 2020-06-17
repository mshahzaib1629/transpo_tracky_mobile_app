import 'dart:async';
import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/user_location.dart';
import 'package:location/location.dart' as locationPkg;
import '../helpers/google_map_helper.dart';

class RouteSelectionTopBar extends StatefulWidget {
  final Function fetchTrips;
  final Function setLocationPredictions;

  RouteSelectionTopBar({
    this.fetchTrips,
    this.setLocationPredictions,
  });

  @override
  _RouteSelectionTopBarState createState() => _RouteSelectionTopBarState();
}

class _RouteSelectionTopBarState extends State<RouteSelectionTopBar> {
  final _locationTextController = TextEditingController();
  Timer _throttle;

  UserLocation _userLocation;

  @override
  void initState() {
    super.initState();
    _locationTextController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _locationTextController.removeListener(_onSearchChanged);
    _locationTextController.dispose();
    super.dispose();
  }

// _lastValue is added to avoid calling api on closing the keyboard
  String _lastValue;
  _onSearchChanged() {
    if (_lastValue != _locationTextController.text) {
      List<Map<String, dynamic>> predictions = [];
      List predictionsFetched = [];
      if (_throttle?.isActive ?? false) _throttle.cancel();
      _throttle = Timer(const Duration(milliseconds: 500), () async {
        try {
          predictionsFetched = await MapHelper.getLocationAutoFills(
              _locationTextController.text);
        } catch (error) {
          print(error);
        }
        for (int i = 0; i < predictionsFetched.length; i++) {
          predictions.add({
            'id': predictionsFetched[i]['place_id'],
            'name': predictionsFetched[i]['description'],
          });
        }
        widget.setLocationPredictions(predictions);
        _lastValue = _locationTextController.text;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    var location = await locationPkg.Location().getLocation();
    if (location != null) {
      setState(() {
        _userLocation = UserLocation(
            id: location.toString(),
            address: '${location.latitude}, ${location.longitude}',
            latitude: location.latitude,
            longitude: location.longitude);
        if (_userLocation != null)
          _locationTextController.text = _userLocation.address;
      });
    }
    print(_userLocation.id);
    widget.fetchTrips(_userLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.28 * SizeConfig.widthMultiplier,
          color: Colors.black12,
        ),
        borderRadius:
            BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            // Let user enter location manually
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _locationTextController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Location',
              ),
            ),
          ),
          // For Fetching User's Location automatically
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
    );
  }
}
