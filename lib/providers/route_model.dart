import 'package:flutter/cupertino.dart';
import 'package:transpo_tracky_mobile_app/providers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import 'stop_model.dart';

class Route {
  int id;
  String name;
  String pickUpTime;
  String dropOffTime;
  List<Stop> stopList;

  Route({
    this.id,
    this.name,
    this.pickUpTime,
    this.dropOffTime,
    this.stopList,
  });
}

class FavoriteRoute {
  int routeId;
  String routeName;
  Stop favoriteStop;
  TripMode mode;

  FavoriteRoute({
    this.routeId,
    this.routeName,
    this.favoriteStop,
    this.mode,
  });
}

class RouteProvider with ChangeNotifier {

  
  List<FavoriteRoute> passengerFavoriteRoutes = [];
  
  List<Route> dummy_routes = [
    Route(
      id: 1,
      name: 'Route# 1',
      pickUpTime: '8:30 AM',
      dropOffTime: '5:30 PM',
      stopList: dummy_stops_1,
    ),
    Route(
      id: 2,
      name: 'Route# 2',
      pickUpTime: '8:30 AM',
      dropOffTime: '5:30 PM',
      stopList: dummy_stops_2,
    ),
    Route(
      id: 3,
      name: 'Route# 3',
      pickUpTime: '8:30 AM',
      dropOffTime: '5:30 PM',
      stopList: dummy_stops_3,
    ),
    Route(
      id: 4,
      name: 'Route# 4',
      pickUpTime: '8:30 AM',
      dropOffTime: '5:30 PM',
      stopList: dummy_stops_4,
    ),
  ];

  void addFavorite({Trip trip}) {
    Stop favoriteStop = new Stop(
      id: trip.passengerStop.id,
      name: trip.passengerStop.name,
      // --------------------------------------------------------------------------------
      // Modification required here, set timeToReach of the stop as it is on PickUp Mode, 
      // but on DropOff Mode, set time to reach that stop estimated by google maps api
      timeToReach: trip.passengerStop.timeToReach,
      // --------------------------------------------------------------------------------
      latitude: trip.passengerStop.latitude,
      longitude: trip.passengerStop.longitude,
    );

    FavoriteRoute favoriteRoute = new FavoriteRoute(
        routeId: trip.route.id,
        routeName: trip.route.name,
        mode: trip.mode,
        favoriteStop: favoriteStop);
    passengerFavoriteRoutes.add(favoriteRoute);
    notifyListeners();
  }
}
