import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:transpo_tracky_mobile_app/helpers/local_db_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:http/http.dart' as http;

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
  int id;
  int routeId;
  String routeName;
  Stop favoriteStop;
  TripMode mode;

  FavoriteRoute({
    this.id,
    this.routeId,
    this.routeName,
    this.favoriteStop,
    this.mode,
  });
}

class RouteProvider with ChangeNotifier {
  List<FavoriteRoute> passengerFavoriteRoutes = [];

  List<Route> routes = [
    // Route(
    //   id: 1,
    //   name: 'Route# 1',
    //   pickUpTime: '8:30 AM',
    //   dropOffTime: '5:30 PM',
    //   stopList: dummy_stops_1,
    // ),
    // Route(
    //   id: 2,
    //   name: 'Route# 2',
    //   pickUpTime: '8:30 AM',
    //   dropOffTime: '5:30 PM',
    //   stopList: dummy_stops_2,
    // ),
    // Route(
    //   id: 3,
    //   name: 'Route# 3',
    //   pickUpTime: '8:30 AM',
    //   dropOffTime: '5:30 PM',
    //   stopList: dummy_stops_3,
    // ),
    // Route(
    //   id: 4,
    //   name: 'Route# 4',
    //   pickUpTime: '8:30 AM',
    //   dropOffTime: '5:30 PM',
    //   stopList: dummy_stops_4,
    // ),
  ];

  Future<void> fetchRoutes() async {
    try {
      List<Route> fetchedRoutes = [];
      final response = await http
          .get('$connectionString/routes/live-routes')
          .timeout(requestTimeout);
      print(json.decode(response.body)['message']);
      final fetchedData = json.decode(response.body)['data'] as List;

      fetchedData.forEach((data) {
        var route = Route(
          id: data['id'],
          name: data['name'],
          pickUpTime: data['pickUpTime'],
          dropOffTime: data['dropOffTime'],
          stopList: [],
        );

        data['stopList'].forEach((data2) {
          var stop = Stop(
            id: data2['id'],
            name: data2['name'],
            timeToReach: data2['timeToReach'],
            longitude: data2['longitude'],
            latitude: data2['latitude'],
          );
          route.stopList.add(stop);
        });
        if (route.stopList.length != 0) fetchedRoutes.add(route);
      });
      routes = fetchedRoutes;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void addFavorite({Trip trip, int currentPassengerId}) {
    LocalDatabase.insert('favorite_routes', {
      'passengerId': currentPassengerId,
      'routeId': trip.route.id,
      'routeName': trip.route.name,
      'stopName': trip.passengerStop.name,
      // --------------------------------------------------------------------------------
      // Modification required here, set timeToReach of the stop as it is on PickUp Mode,
      // but on DropOff Mode, set time to reach that stop estimated by google maps api
      'timeToReach': trip.passengerStop.timeToReach,
      // --------------------------------------------------------------------------------
      'mode': trip.mode.toString(),
    });
    fetchAndSetFavorites(currentPassengerId: 1);
    notifyListeners();
  }

  Future<void> fetchAndSetFavorites({int currentPassengerId}) async {
    final dataList = await LocalDatabase.getFavoriteRoutes(currentPassengerId);
    // print(dataList);
    passengerFavoriteRoutes = dataList
        .map((favorite) => FavoriteRoute(
              id: favorite['id'],
              routeId: favorite['routeId'],
              routeName: favorite['routeName'],
              favoriteStop: Stop(
                name: favorite['stopName'],
                timeToReach: favorite['timeToReach'],
              ),
              mode: favorite['mode'] == 'TripMode.PICK_UP'
                  ? TripMode.PICK_UP
                  : TripMode.DROP_OFF,
            ))
        .toList();
    notifyListeners();
  }

  void deleteConfig(int id) {
    LocalDatabase.delete('favorite_routes', id);
    notifyListeners();
  }

  bool isFavoriteFound({Trip trip}) {
    if (trip == null) return true;
    for (int i = 0; i < passengerFavoriteRoutes.length; i++) {
      FavoriteRoute currentRoute = passengerFavoriteRoutes[i];
      if (currentRoute.routeId == trip.route.id &&
          currentRoute.favoriteStop.id == trip.passengerStop.id) return true;
    }
    return false;
  }

  List<Route> getFilteredRoutes(RouteFilter filter) {
    List<Route> filteredRoutes = [];
    if (filter == RouteFilter.All) {
      filteredRoutes = routes;
    } else if (filter == RouteFilter.Morning) {
      filteredRoutes = routes
          .where((route) => route.pickUpTime == '08:30:00.000000')
          .toList();
    } else if (filter == RouteFilter.Evening) {
      filteredRoutes = routes
          .where((route) => route.pickUpTime == '11:30:00.000000')
          .toList();
    }
    return filteredRoutes;
  }
}
