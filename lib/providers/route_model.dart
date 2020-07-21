import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:transpo_tracky_mobile_app/helpers/local_db_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:http/http.dart' as http;

import 'stop_model.dart';

class Route {
  int id;
  String name;
  RouteType routeType;
  DateTime pickUpTime;
  DateTime dropOffTime;
  List<Stop> stopList;
  Image staticMapImage;

  Route({
    this.id,
    this.name,
    this.routeType,
    this.pickUpTime,
    this.dropOffTime,
    this.stopList,
    this.staticMapImage,
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

  List<Route> routes = [];

  Future<void> fetchRoutes() async {
    List<Route> fetchedRoutes = [];
    try {
      final response = await http
          .get('$connectionString/routes/live-routes')
          .timeout(requestTimeout);
      print(json.decode(response.body)['message']);
      final fetchedData = json.decode(response.body)['data'] as List;

      fetchedData.forEach((data) {
        var route = Route(
          id: data['id'],
          name: data['name'],
          routeType:
              data['type'] == 'IN_LINE' ? RouteType.IN_LINE : RouteType.IN_LOOP,
          pickUpTime: DateFormat('Hms', 'en_US').parse(data['pickUpTime']),
          dropOffTime: DateFormat('Hms', 'en_US').parse(data['dropOffTime']),
          stopList: [],
        );

        data['stopList'].forEach((data2) {
          var stop = Stop(
            id: data2['id'],
            name: data2['name'],
            timeToReach: DateFormat('Hms', 'en_US').parse(data2['timeToReach']),
            longitude: data2['location']['longitude'],
            latitude: data2['location']['latitude'],
          );
          route.stopList.add(stop);
        });
        if (route.stopList.length != 0) fetchedRoutes.add(route);
      });
      routes = fetchedRoutes;
      routes.sort((a, b) => a.name.compareTo(b.name));
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
      'timeToReach': trip.passengerStop.timeToReach.toIso8601String(),
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
                timeToReach: DateTime.parse(favorite['timeToReach']),
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
    passengerFavoriteRoutes.removeWhere((favorite) => favorite.id == id);
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
    if (filter == RouteFilter.Morning) {
      filteredRoutes =
          routes.where((route) => route.name.startsWith('M')).toList();
    } else if (filter == RouteFilter.Evening) {
      filteredRoutes =
          routes.where((route) => route.name.startsWith('E')).toList();
    } else if (filter == RouteFilter.Faculty) {
      filteredRoutes =
          routes.where((route) => route.name.startsWith('F')).toList();
    } else if (filter == RouteFilter.Hostel) {
      filteredRoutes =
          routes.where((route) => route.name.startsWith('H')).toList();
    } else if (filter == RouteFilter.Testing) {
      filteredRoutes =
          routes.where((route) => route.name.startsWith('T')).toList();
    }
    return filteredRoutes;
  }
}
