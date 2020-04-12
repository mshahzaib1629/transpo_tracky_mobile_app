import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/user_location.dart';
import 'package:location/location.dart' as locationPkg;

class RouteSelectionTopBar extends StatefulWidget {
  final Function fetchTrips;

  RouteSelectionTopBar({this.fetchTrips});

  @override
  _RouteSelectionTopBarState createState() => _RouteSelectionTopBarState();
}

class _RouteSelectionTopBarState extends State<RouteSelectionTopBar> {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);
  final _locationTextController = TextEditingController();

  UserLocation _userLocation;

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
    // homeScaffoldKey.currentState.showSnackBar(
    //   SnackBar(content: Text(response.errorMessage)),
    // );
  }

  Future<void> _searchLocation() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: GOOGLE_API_KEY,
      onError: onError,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "pk")],
    );

    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(
        () {
          _userLocation = UserLocation(
              id: p.placeId,
              address: p.description,
              latitude: lat,
              longitude: lng);
          if (_userLocation != null)
            _locationTextController.text = _userLocation.address;
        },
      );
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
              controller: _locationTextController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Location',
              ),
              onTap: _searchLocation,
              onSubmitted: (value) => widget.fetchTrips(_userLocation),
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
