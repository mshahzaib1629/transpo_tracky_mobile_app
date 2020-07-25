import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:transpo_tracky_mobile_app/helpers/constants.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import 'package:transpo_tracky_mobile_app/providers/passenger_model.dart';
import 'package:transpo_tracky_mobile_app/providers/user_location.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../helpers/firebase_helper.dart';
import 'driver_model.dart';
import '../helpers/enums.dart';
import 'route_model.dart' as r;
import 'bus_model.dart';

class Trip {
  int id;
  // pass trip's stops from DB to the route's stopList here
  r.Route route;
  Stop passengerStop;
  Stop driverNextStop;
  List<Driver> drivers;
  Bus bus;
  BusMeterReading meter;
  bool onBoard;
  int passengersOnBoard;
  String mapTraceKey;
  TripMode mode;
  bool shareLiveLocation;
  DateTime startTime;
  DateTime endTime;

  Trip({
    this.id,
    this.route,
    this.drivers,
    this.passengerStop,
    this.driverNextStop,
    this.bus,
    this.meter,
    this.onBoard = false,
    this.passengersOnBoard,
    this.mapTraceKey,
    this.mode,
    this.shareLiveLocation,
    this.startTime,
    this.endTime,
  });
}

class TripProvider with ChangeNotifier {
  Trip _passengerSelectedTrip;
  // Trip _driverCreatedTrip;
  int _driverNextStopIndex = 0;

  // assigning dummy trip data for testing purpose only
  // Trip _driverCreatedTrip;
  Trip _driverCreatedTrip = Trip(
      route: r.Route(id: 1, name: 'Route Test', stopList: dummy_stops_1),
      bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'New Bus'),
      meter: BusMeterReading(initialReading: 1542),
      driverNextStop: Stop(
        id: 1,
        name: 'Dummy',
        longitude: 74.2475891,
        latitude: 31.6240714,
        timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
        // timeReached: '6:50 AM',
        estToReachBus: '16 mins',
      ),
      mode: TripMode.PICK_UP,
      drivers: [Constants.dummyDriver]);

  Trip get passengerSelectedTrip {
    return _passengerSelectedTrip;
  }

  Trip get driverCreatedTrip {
    return _driverCreatedTrip;
  }

  List<Trip> _suggestedTrips = [];

  List<Trip> _tripsRecord = [];

// for passenger
// ------------------------------------------------------------------
  // selectedTrip removed from here
  // rename passengerSelectedTrip to passengerJoinedTrip in this file
  // ----------------------------------------------------------------
  Future<bool> checkLiveStatus(int tripId) async {
    try {
      String url = '$connectionString/trips/check-live-status/tripId=$tripId';
      final response = await http.get(url).timeout(requestTimeout);
      final responseData = json.decode(response.body);
      print(responseData['message']);
      print('status: ${responseData['status']}');

      return responseData['status'] == 1 ? true : false;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> joinTrip({Trip selectedTrip}) async {
    final passenger = Passenger(id: 1);
    try {
      final response = await http
          .put(
              '$connectionString/trips/joinTrip/tripId=${selectedTrip.id},passengerId=${passenger.id},stopId=${selectedTrip.passengerStop.id}')
          .timeout(requestTimeout);
      print(json.decode(response.body));
      var tripData = json.decode(response.body)['data'] as Map<String, dynamic>;

      if (tripData != null) {
        _passengerSelectedTrip = Trip(
            id: tripData['id'],
            route: r.Route(
                id: tripData['route']['id'],
                name: tripData['route']['name'],
                routeType: tripData['route']['type'] == 'IN_LINE'
                    ? RouteType.IN_LINE
                    : RouteType.IN_LOOP,
                stopList: []),
            bus: Bus(
              id: tripData['bus']['id'],
              name: tripData['bus']['name'],
              plateNumber: tripData['bus']['plate'],
              capacity: tripData['bus']['capacity'],
            ),
            mode: tripData['mode'] == 'PICK_UP'
                ? TripMode.PICK_UP
                : TripMode.DROP_OFF,
            startTime: DateFormat('yyyy-MM-ddTHH:mm:ss', 'en_US')
                .parse(tripData['startTime']),
            passengersOnBoard: tripData['no_of_passengers'],
            drivers: [],
            mapTraceKey: tripData['mapTraceKey'],
            shareLiveLocation:
                tripData['shareLiveLocation'] == 1 ? true : false);

        tripData['route']['stops'].forEach((stopData) {
          var stop = Stop(
            id: stopData['id'],
            name: stopData['name'],
            timeToReach:
                DateFormat('Hms', 'en_US').parse(stopData['estimatedTime']),
            timeReached: stopData['timeReached'] != null
                ? DateFormat('Hms', 'en_US').parse(stopData['timeReached'])
                : null,
            longitude: stopData['location']['longitude'],
            latitude: stopData['location']['latitude'],
          );
          _passengerSelectedTrip.route.stopList.add(stop);

          if (selectedTrip.passengerStop.id == stop.id)
            _passengerSelectedTrip.passengerStop = stop;
        });

        tripData['drivers'].forEach((driverData) {
          var driver = Driver(
              id: driverData['id'],
              registrationID: driverData['registrationId'],
              firstName: driverData['firstName'],
              lastName: driverData['lastName'],
              contact: driverData['contact']);
          _passengerSelectedTrip.drivers.add(driver);
        });
      } else {
        // throw an exception here
        print('throw an exception here');
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

// updating estimated distance to reach the bus on passenger stop
  updateEsdToReachBus(LatLng driverLocation) {
    Stop stop = passengerSelectedTrip.passengerStop;
    var distance = calculateDistance(driverLocation.latitude,
        driverLocation.longitude, stop.latitude, stop.longitude);
    passengerSelectedTrip.passengerStop.estToReachBus =
        distance.toStringAsFixed(2);
    notifyListeners();
  }

// for driver
  Future<void> startTrip({TripConfig config}) async {
    final trackingKey = Uuid().v1();
    var currentLocation = await Location().getLocation();
    List<Driver> driversList = [];
    driversList.add(config.currentDriver);
    if (config.partnerDriver != null) driversList.add(config.partnerDriver);
    try {
      await FirebaseHelper.updateDriverLocation(trackingKey, currentLocation);

      final requestBody = {
        "routeId": config.route.id,
        "busId": config.bus.id,
        "driversList": driversList.map((driver) => {"id": driver.id}).toList(),
        "tripMode": config.mode == TripMode.PICK_UP ? "PICK_UP" : "DROP_OFF",
        "mapTraceKey": trackingKey,
        "initialMeterReading": config.meter.initialReading
      };

      final response = await http
          .post(
            '$connectionString/trips',
            headers: {
              "accept": "application/json",
              "content-type": "application/json",
              "connection": "keep-alive",
            },
            body: json.encode(requestBody),
          )
          .timeout(requestTimeout);

      var tripData = json.decode(response.body)['data'] as Map<String, dynamic>;

      print('data fetched: $tripData');

      _driverCreatedTrip = Trip(
          id: tripData['id'],
          route: r.Route(
              id: tripData['route']['id'],
              name: tripData['route']['name'],
              routeType: tripData['route']['type'] == 'IN_LINE'
                  ? RouteType.IN_LINE
                  : RouteType.IN_LOOP,
              stopList: []),
          bus: Bus(
            id: tripData['bus']['id'],
            name: tripData['bus']['name'],
            plateNumber: tripData['bus']['plate'],
            capacity: tripData['bus']['capacity'],
          ),
          meter: BusMeterReading(
              initialReading: tripData['meterReading']['initial'].toDouble()),
          mode: tripData['mode'] == 'PICK_UP'
              ? TripMode.PICK_UP
              : TripMode.DROP_OFF,
          drivers: [],
          mapTraceKey: tripData['mapTraceKey']);

      tripData['route']['stops'].forEach((stopData) {
        var stop = Stop(
          id: stopData['id'],
          name: stopData['name'],
          timeToReach:
              DateFormat('Hms', 'en_US').parse(stopData['estimatedTime']),
          timeReached: stopData['timeReached'] != null
              ? DateFormat('Hms', 'en_US').parse(stopData['timeReached'])
              : null,
          longitude: stopData['location']['longitude'],
          latitude: stopData['location']['latitude'],
        );
        _driverCreatedTrip.route.stopList.add(stop);
      });

      tripData['drivers'].forEach((driverData) {
        var driver = Driver(
            id: driverData['id'],
            registrationID: driverData['registrationId'],
            firstName: driverData['firstName'],
            lastName: driverData['lastName'],
            contact: driverData['contact']);
        _driverCreatedTrip.drivers.add(driver);
      });
      _driverCreatedTrip.driverNextStop = _driverCreatedTrip.route.stopList[0];
    } catch (error) {
      print(error);
      throw error;
    }

    notifyListeners();
    // ---------------------
    // add server notify logic here
    // ---------------------
  }

  // for driver (if he is already on trip)
  Future<bool> checkIfOnTrip(int driverId) async {
    try {
      final response = await http
          .get('$connectionString/trips/take-driver-on-trip/driverId=$driverId')
          .timeout(requestTimeout);

      var tripData = json.decode(response.body)['data'] as Map<String, dynamic>;

      print('data fetched: $tripData');

      if (tripData != null) {
        _driverCreatedTrip = Trip(
            id: tripData['id'],
            route: r.Route(
                id: tripData['route']['id'],
                name: tripData['route']['name'],
                routeType: tripData['route']['type'] == 'IN_LINE'
                    ? RouteType.IN_LINE
                    : RouteType.IN_LOOP,
                stopList: []),
            bus: Bus(
              id: tripData['bus']['id'],
              name: tripData['bus']['name'],
              plateNumber: tripData['bus']['plate'],
              capacity: tripData['bus']['capacity'],
            ),
            meter: BusMeterReading(
                initialReading: tripData['meterReading']['initial'].toDouble()),
            mode: tripData['mode'] == 'PICK_UP'
                ? TripMode.PICK_UP
                : TripMode.DROP_OFF,
            drivers: [],
            mapTraceKey: tripData['mapTraceKey']);

        tripData['route']['stops'].forEach((stopData) {
          var stop = Stop(
            id: stopData['id'],
            name: stopData['name'],
            timeToReach:
                DateFormat('Hms', 'en_US').parse(stopData['estimatedTime']),
            timeReached: stopData['timeReached'] != null
                ? DateFormat('Hms', 'en_US').parse(stopData['timeReached'])
                : null,
            longitude: stopData['location']['longitude'],
            latitude: stopData['location']['latitude'],
          );
          _driverCreatedTrip.route.stopList.add(stop);
        });
        tripData['drivers'].forEach((driverData) {
          var driver = Driver(
              id: driverData['id'],
              registrationID: driverData['registrationId'],
              firstName: driverData['firstName'],
              lastName: driverData['lastName'],
              contact: driverData['contact']);
          _driverCreatedTrip.drivers.add(driver);
        });
        _driverCreatedTrip.driverNextStop =
            _driverCreatedTrip.route.stopList.firstWhere(
          (stop) => stop.timeReached == null,
          orElse: () => _driverCreatedTrip
              .route.stopList[_driverCreatedTrip.route.stopList.length - 1],
        );
        print(_driverCreatedTrip.driverNextStop.name);
        return true;
      } else
        return false;
    } catch (error) {
      throw error;
    }
  }

  // for passenger
  Future<void> passengerEndTrip() async {
    print('passenger trip ended');
    // ---------------------
    // add server notify / review logic here
    // ---------------------
    // _passengerSelectedTrip = null;
    notifyListeners();
  }

  Future<void> driverEndTrip(BusMeterReading reading) async {
    _driverCreatedTrip.meter.finalReading = reading.finalReading;

    try {
      final response = await http.put(
        '$connectionString/trips/endTrip/${_driverCreatedTrip.id}',
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
          // "connection": "keep-alive",
        },
        body: json.encode(
            {"finalMeterReading": _driverCreatedTrip.meter.finalReading}),
      );
      print('status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        // _driverCreatedTrip = null;
        _driverNextStopIndex = 0;
      }
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> fetchSuggestedTrips(double latitude, double longitude) async {
    _suggestedTrips = [];

    try {
      final response = await http
          .get(
              '$connectionString/trips/suggest/latitude=$latitude,longitude=$longitude,range=${Constants.passengerRange}')
          .timeout(requestTimeout);
      print(json.decode(response.body)['message']);
      final fetchedData = json.decode(response.body)['data'] as List;
      fetchedData.forEach((data) {
        var trip = Trip(
          id: data['trip']['id'],
          route: r.Route(
            id: data['trip']['route']['id'],
            name: data['trip']['route']['name'],
            routeType: data['trip']['route']['type'] == 'IN_LINE'
                ? RouteType.IN_LINE
                : RouteType.IN_LOOP,
            stopList: [],
          ),
          drivers: [],
          passengerStop: Stop(
            id: data['suggestedStop']['id'],
            name: data['suggestedStop']['name'],
            timeToReach: DateFormat('Hms', 'en_US')
                .parse(data['suggestedStop']['estimatedTime']),
            latitude: data['suggestedStop']['location']['latitude'],
            longitude: data['suggestedStop']['location']['longitude'],
            distanceFromUser:
                data['suggestedStop']['distanceFromUser'].toStringAsFixed(2),
          ),
          bus: Bus(
            id: data['trip']['bus']['id'],
            plateNumber: data['trip']['bus']['plate'],
            name: data['trip']['bus']['name'],
            capacity: data['trip']['bus']['capacity'],
          ),
          passengersOnBoard: data['trip']['no_of_passengers'],
          mapTraceKey: data['trip']['mapTraceKey'],
          mode: data['trip']['mode'] == 'PICK_UP'
              ? TripMode.PICK_UP
              : TripMode.DROP_OFF,
          shareLiveLocation:
              data['trip']['shareLiveLocation'] == 1 ? true : false,
        );

        data['trip']['route']['stops'].forEach((data2) {
          var stop = Stop(
            id: data2['id'],
            name: data2['name'],
            timeToReach:
                DateFormat('Hms', 'en_US').parse(data2['estimatedTime']),
            longitude: data2['location']['longitude'],
            latitude: data2['location']['latitude'],
          );
          trip.route.stopList.add(stop);
        });

        data['trip']['drivers'].forEach((data3) {
          var driver = Driver(
              id: data3['id'],
              registrationID: data3['registrationId'],
              firstName: data3['firstName'],
              lastName: data3['lastName'],
              contact: data3['contact']);
          trip.drivers.add(driver);
        });
        _suggestedTrips.add(trip);
      });
    } catch (error) {
      throw error;
    }
    _suggestedTrips.sort((t1, t2) => t1.passengerStop.distanceFromUser
        .compareTo(t2.passengerStop.distanceFromUser));
    notifyListeners();
  }

  get getSuggestedTrips {
    return _suggestedTrips;
  }

  Future<void> fetchFavoriteSuggested(r.FavoriteRoute favorite) async {
    _suggestedTrips = [];
    List<Trip> tripsFetched = [];

    try {
      print('favorite route id: ${favorite.routeId}');
      final response = await http
          .get(
              '$connectionString/trips/tripsOnFavouriteRoute/routeId=${favorite.routeId}')
          .timeout(requestTimeout);
      print(json.decode(response.body)['message']);
      final fetchedData = json.decode(response.body)['data'] as List;
      fetchedData.forEach((data) {
        var trip = Trip(
          id: data['id'],
          route: r.Route(
            id: data['route']['id'],
            name: data['route']['name'],
            routeType: data['route']['type'] == 'IN_LINE'
                ? RouteType.IN_LINE
                : RouteType.IN_LOOP,
            stopList: [],
          ),
          drivers: [],
          bus: Bus(
            id: data['bus']['id'],
            plateNumber: data['bus']['plate'],
            name: data['bus']['name'],
            capacity: data['bus']['capacity'],
          ),
          passengersOnBoard: data['no_of_passengers'],
          mapTraceKey: data['mapTraceKey'],
          mode:
              data['mode'] == 'PICK_UP' ? TripMode.PICK_UP : TripMode.DROP_OFF,
          shareLiveLocation: data['shareLiveLocation'] == 1 ? true : false,
        );

        data['route']['stops'].forEach((data2) {
          var stop = Stop(
            id: data2['id'],
            name: data2['name'],
            timeToReach:
                DateFormat('Hms', 'en_US').parse(data2['estimatedTime']),
            longitude: data2['location']['longitude'],
            latitude: data2['location']['latitude'],
          );
          trip.route.stopList.add(stop);
        });

        data['drivers'].forEach((data3) {
          var driver = Driver(
              id: data3['id'],
              registrationID: data3['registrationId'],
              firstName: data3['firstName'],
              lastName: data3['lastName'],
              contact: data3['contact']);
          trip.drivers.add(driver);
        });
        tripsFetched.add(trip);
      });
      _suggestedTrips = tripsFetched;
    } catch (error) {
      throw error;
    }

    tripsFetched.map((trip) async {
      if (trip.route.id == favorite.routeId) {
        trip.passengerStop = trip.route.stopList
            .firstWhere((stop) => stop.name == favorite.favoriteStop.name);
        if (trip.passengerStop != null) {
          var userLocation = await Location().getLocation();
          if (userLocation != null) {
            trip.passengerStop.distanceFromUser = calculateDistance(
                    userLocation.latitude,
                    userLocation.longitude,
                    trip.passengerStop.latitude,
                    trip.passengerStop.longitude)
                .toStringAsFixed(2);
          }
          print(trip.passengerStop.distanceFromUser);
          _suggestedTrips.add(trip);
        }
      }
    }).toList();

    _suggestedTrips.sort((t1, t2) => t1.passengerStop.distanceFromUser
        .compareTo(t2.passengerStop.distanceFromUser));
    notifyListeners();
  }

  Future<void> fetchTripsRecord() async {
    // we send request to same url for both driver & passenger, just filter by userType variable for responding
    LoginMode userType = LoginMode.Driver;

    List<Trip> fetchedTrips = [];
    try {
      final response = await http
          .get(
              '$connectionString/trips/tripsRecord/userType=${userType == LoginMode.Driver ? "EMPLOYEE" : "PASSENGER"},userId=${3},limit=${30}')
          .timeout(requestTimeout);
      print(json.decode(response.body)['message']);

      print('trips record fetched!');

      final fetchedData = json.decode(response.body)['data'] as List;
      fetchedData.forEach((data) {
        var trip = Trip(
            id: data['id'],
            mode: data['mode'] == 'PICK_UP'
                ? TripMode.PICK_UP
                : TripMode.DROP_OFF,
            route: r.Route(
              id: data['route']['id'],
              name: data['route']['name'],
              routeType: data['route']['type'] == 'IN_LINE'
                  ? RouteType.IN_LINE
                  : RouteType.IN_LOOP,
              stopList: [],
            ),
            drivers: [],
            bus: Bus(
              id: data['bus']['id'],
              name: data['bus']['name'],
              plateNumber: data['bus']['plate'],
              capacity: data['bus']['capacity'],
            ),
            startTime: DateFormat('yyyy-MM-ddThh:mm:ss', 'en_US')
                .parse(data['startTime']),
            endTime: DateFormat('yyyy-MM-ddTHH:mm:ss', 'en_US')
                .parse(data['endTime']),
            mapTraceKey: data['mapTraceKey'],
            passengersOnBoard: data['no_of_passengers']);
        print('start time: ${trip.startTime}');
        data['route']['stops'].forEach((data2) {
          var stop = Stop(
            id: data2['id'],
            name: data2['name'],
            timeToReach:
                DateFormat('Hms', 'en_US').parse(data2['estimatedTime']),
            timeReached: data2['timeReached'] != null
                ? DateFormat('Hms', 'en_US').parse(data2['timeReached'])
                : null,
            longitude: data2['location']['longitude'],
            latitude: data2['location']['latitude'],
          );
          trip.route.stopList.add(stop);
        });

        data['drivers'].forEach((data3) {
          var driver = Driver(
              id: data3['id'],
              registrationID: data3['registrationId'],
              firstName: data3['firstName'],
              lastName: data3['lastName'],
              contact: data3['contact']);
          trip.drivers.add(driver);
        });

        if (userType == LoginMode.Driver)
          trip.meter = BusMeterReading(
            initialReading: data['meterReading']['initial'] != null
                ? data['meterReading']['initial'].toDouble()
                : 0.0,
            finalReading: data['meterReading']['final'] != null
                ? data['meterReading']['final'].toDouble()
                : 0.0,
          );
        else if (userType == LoginMode.Passenger)
          trip.passengerStop = Stop(
              id: data['passengerStop']['id'],
              name: data['passengerStop']['name'],
              timeReached: data['passengerStop']['timeReached'] != null
                  ? DateFormat('Hms', 'en_US')
                      .parse(data['passengerStop']['timeReached'])
                  : trip.route.stopList
                      .firstWhere(
                          (stop) => stop.id == data['passengerStop']['id'])
                      .timeToReach,
              latitude: data['passengerStop']['location']['latitude'],
              longitude: data['passengerStop']['location']['longitude']);

        if (trip.route.stopList.length != 0) fetchedTrips.add(trip);
      });

      _tripsRecord = fetchedTrips;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  get getTripsRecord {
    return [..._tripsRecord];
  }

  // For passengers
  void updateOnBoardStatus() {
    print('on board status called');
    _passengerSelectedTrip.onBoard = true;
    if (_passengerSelectedTrip.mode == TripMode.PICK_UP) {
      List<Stop> _stopList = _passengerSelectedTrip.route.stopList;
      _passengerSelectedTrip.passengerStop = _stopList[_stopList.length - 1];
      print('passenger stop: ${_passengerSelectedTrip.passengerStop.name}');
    }
    notifyListeners();
  }

  // For drivers
  Future<void> _updateNextStop() async {
    String url =
        '$connectionString/trips/stop-reached/stopId=${_driverCreatedTrip.driverNextStop.id}';
    try {
      final response = await http.put(url).timeout(requestTimeout);
      _driverCreatedTrip.driverNextStop.timeReached = DateTime.now();
      print('/////////////////////////');
      print('updating next stop');
      print(json.decode(response.body));
      print('/////////////////////////');
      if (_driverNextStopIndex <
          (_driverCreatedTrip.route.stopList.length - 1)) {
        _driverNextStopIndex++;
        driverCreatedTrip.driverNextStop =
            _driverCreatedTrip.route.stopList[_driverNextStopIndex];
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void checkDistanceToNextStop(LocationData driverLocation) {
    double distance = calculateDistance(
        driverLocation.latitude,
        driverLocation.longitude,
        driverCreatedTrip.driverNextStop.latitude,
        driverCreatedTrip.driverNextStop.longitude);
    // print('distance to ${driverCreatedTrip.driverNextStop.name}: $distance');
    if (distance < Constants.stopRadius) _updateNextStop();
  }

  // calculates the distance between two locations in KM
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double earthRadius =
        6371; // in kilometer, change to 3958.75 for miles output

    double dLat = radians(lat2 - lat1);
    double dLng = radians(lng2 - lng1);

    double sindLat = sin(dLat / 2);
    double sindLng = sin(dLng / 2);

    double a = pow(sindLat, 2) +
        pow(sindLng, 2) * cos(radians(lat1)) * cos(radians(lat2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double dist = earthRadius * c;

    return dist; // output distance, in KM
  }

  Future<List<LatLng>> getDirections(LocationData userLocaiton) async {
    final route = await MapHelper.getDirections(
        userLocaiton, driverCreatedTrip.driverNextStop);
    List<LatLng> pointsList = MapHelper.convertToLatLng(
        route['routes'][0]['overview_polyline']['points']);
    _driverCreatedTrip.driverNextStop.estToReachBus =
        route['routes'][0]['legs'][0]['duration']['text'];
    _driverCreatedTrip.driverNextStop.distanceFromUser =
        route['routes'][0]['legs'][0]['distance']['text'];
    // print('duration: ${route['routes'][0]['legs'][0]['duration']['text']}');
    // print('distance: ${route['routes'][0]['legs'][0]['distance']['text']}');
    // print(pointsList);
    notifyListeners();
    return pointsList;
  }
}
