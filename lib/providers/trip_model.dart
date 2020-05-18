import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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
  int passengersOnBoard;
  String mapTraceKey;
  TripMode mode;
  bool shareLiveLocation;
  String startTime;
  String endTime;

  Trip({
    this.id,
    this.route,
    this.drivers,
    this.passengerStop,
    this.driverNextStop,
    this.bus,
    this.meter,
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
          timeReached: '6:50 AM',
          estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
          estWalkTime: '8 mins'),
      mode: TripMode.PICK_UP,
      drivers: [
        Driver(
            registrationID: 'EMP-DR-107',
            firstName: 'Mushtaq',
            lastName: 'Sidique'),
        Driver(
          registrationID: 'EMP-CD-108',
          firstName: 'Shakeel',
          lastName: 'Ahmed',
        )
      ]);

  Trip get passengerSelectedTrip {
    return _passengerSelectedTrip;
  }

  Trip get driverCreatedTrip {
    return _driverCreatedTrip;
  }

  List<Trip> trips_suggested = [];

  List<Trip> dummy_trips_record = [
    Trip(
      id: 1,
      route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
      passengerStop: Stop(
          id: 1,
          name: 'Sagian Pull',
          longitude: 1235.05,
          latitude: 78453,
          timeReached: '7:35 AM'),
      mode: TripMode.PICK_UP,
      drivers: [
        Driver(
            registrationID: 'EMP-DR-107',
            firstName: 'Mushtaq',
            lastName: 'Sidique'),
        Driver(
          registrationID: 'EMP-CD-108',
          firstName: 'Shakeel',
          lastName: 'Ahmed',
        )
      ],
      bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
      passengersOnBoard: 45,
      meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
      startTime: '6:20 AM',
      endTime: '8:25 AM',
      mapTraceKey: 'ABC321e2',
    ),
    Trip(
      id: 2,
      route: r.Route(
          id: 2, name: 'Route# 2', stopList: dummy_stops_2.reversed.toList()),
      passengerStop: Stop(
          id: 1,
          name: 'Sagian Pull',
          longitude: 1235.05,
          latitude: 78453,
          timeReached: '7:35 AM'),
      mode: TripMode.DROP_OFF,
      drivers: [
        Driver(
            registrationID: 'EMP-DR-107',
            firstName: 'Mushtaq',
            lastName: 'Sidique'),
        Driver(
          registrationID: 'EMP-CD-108',
          firstName: 'Shakeel',
          lastName: 'Ahmed',
        )
      ],
      bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
      passengersOnBoard: 45,
      meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
      startTime: '6:20 AM',
      endTime: '8:25 AM',
      mapTraceKey: 'ABC321e2',
    ),
    Trip(
      id: 2,
      route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
      passengerStop: Stop(
          id: 1,
          name: 'Sagian Pull',
          longitude: 1235.05,
          latitude: 78453,
          timeReached: '7:35 AM'),
      mode: TripMode.PICK_UP,
      drivers: [
        Driver(
            registrationID: 'EMP-DR-107',
            firstName: 'Mushtaq',
            lastName: 'Sidique'),
        Driver(
          registrationID: 'EMP-CD-108',
          firstName: 'Shakeel',
          lastName: 'Ahmed',
        )
      ],
      bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
      passengersOnBoard: 45,
      meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
      startTime: '6:20 AM',
      endTime: '8:25 AM',
      mapTraceKey: 'ABC321e2',
    ),
    Trip(
      id: 2,
      route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
      passengerStop: Stop(
          id: 1,
          name: 'Sagian Pull',
          longitude: 1235.05,
          latitude: 78453,
          timeReached: '7:35 AM'),
      mode: TripMode.PICK_UP,
      drivers: [
        Driver(
            registrationID: 'EMP-DR-107',
            firstName: 'Mushtaq',
            lastName: 'Sidique'),
        Driver(
          registrationID: 'EMP-CD-108',
          firstName: 'Shakeel',
          lastName: 'Ahmed',
        )
      ],
      bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
      passengersOnBoard: 45,
      meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
      startTime: '6:20 AM',
      endTime: '8:25 AM',
      mapTraceKey: 'ABC321e2',
    ),
    Trip(
      id: 2,
      route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
      passengerStop: Stop(
          id: 1,
          name: 'Sagian Pull',
          longitude: 1235.05,
          latitude: 78453,
          timeReached: '7:35 AM'),
      mode: TripMode.PICK_UP,
      drivers: [
        Driver(
            registrationID: 'EMP-DR-107',
            firstName: 'Mushtaq',
            lastName: 'Sidique'),
        Driver(
          registrationID: 'EMP-CD-108',
          firstName: 'Shakeel',
          lastName: 'Ahmed',
        )
      ],
      bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
      passengersOnBoard: 45,
      meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
      startTime: '6:20 AM',
      endTime: '8:25 AM',
      mapTraceKey: 'ABC321e2',
    ),
  ];

// for passenger
  void setSelectedTrip({Trip selectedTrip}) {
    this._passengerSelectedTrip = selectedTrip;
    notifyListeners();
  }

// for driver
  Future<void> startTrip({TripConfig config}) async {
    final trackingKey = Uuid().v1();
    var currentLocation = await Location().getLocation();
    try {
      await MapHelper.updateDriverLocation(trackingKey, currentLocation);
    } catch (error) {
      throw error;
    }
    List<Driver> driversList = [];
    driversList.add(config.currentDriver);
    if (config.partnerDriver != null) driversList.add(config.partnerDriver);
    _driverCreatedTrip = Trip(
        route: config.route,
        bus: config.bus,
        meter: config.meter,
        mode: config.mode,
        drivers: driversList,
        mapTraceKey: trackingKey);
    _driverCreatedTrip.driverNextStop = _driverCreatedTrip.route.stopList[0];

    notifyListeners();
    // ---------------------
    // add server notify logic here
    // ---------------------
  }

  // for passenger
  Future<void> passengerEndTrip() async {
    print('passenger trip ended');
    // ---------------------
    // add server notify / review logic here
    // ---------------------
    _passengerSelectedTrip = null;
    notifyListeners();
  }

  Future<void> driverEndTrip(BusMeterReading reading) async {
    _driverCreatedTrip.meter.finalReading = reading.finalReading;
    // ---------------------
    // add server notify logic here
    // ---------------------
    _driverCreatedTrip = null;
    _driverNextStopIndex = 0;
    notifyListeners();
  }

  void fetchSuggestedTrips(double latitude, double longitude) {
    // --------------------------------------------------------------------------------
    // Modification required here, we should pass suggested trips based on user's shared
    // location, currently passing a dummy list
    // How should it work?
    // We'll pass current location's cordinates to server, where we pass those cordinates
    // along with the list of active trip's stops to the 3rd Party API (may be  elastic search),
    // from where we get the list of nearby stops to the user's cordinates. We return the
    // trips associated with those nearby stops to the mobile app.
    // --------------------------------------------------------------------------------
    trips_suggested = [
      Trip(
        id: 1,
        route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
        mode: TripMode.PICK_UP,
        bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 45,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
        passengerStop: dummy_stops_1[2],
      ),
      Trip(
        id: 2,
        route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
        mode: TripMode.PICK_UP,
        bus: Bus(
            id: 1, plateNumber: 'LEZ 4421', name: 'Coaseter VU', capacity: 40),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 36,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
        passengerStop: dummy_stops_1[4],
      ),
      Trip(
        id: 3,
        route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
        mode: TripMode.PICK_UP,
        bus:
            Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 56,
        shareLiveLocation: false,
        mapTraceKey: 'ABC321e2',
        passengerStop: dummy_stops_2[4],
      ),
      Trip(
        id: 4,
        route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
        mode: TripMode.PICK_UP,
        bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 45,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
        passengerStop: dummy_stops_1[6],
      ),
      Trip(
        id: 5,
        route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
        mode: TripMode.PICK_UP,
        bus: Bus(
            id: 1, plateNumber: 'LEZ 4421', name: 'Coaseter VU', capacity: 40),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 36,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
        passengerStop: dummy_stops_3[0],
      ),
    ];
    notifyListeners();
  }

  void fetchFavoriteSuggested(r.FavoriteRoute favorite) {
    // How it will work?
    // we get routeId, favorite stop's name & mode from the
    // favorite and pass it to the server, where we'll find for
    // the trip with same routeId, stop's name & mode from the current
    // active trips. If some are found, we return a list of trips
    // back to the mobile app.
    List<Trip> dummy_trips_on_server = [
      Trip(
        id: 1,
        route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
        mode: TripMode.PICK_UP,
        bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 45,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
      ),
      Trip(
        id: 2,
        route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
        mode: TripMode.PICK_UP,
        bus: Bus(
            id: 1, plateNumber: 'LEZ 4421', name: 'Coaseter VU', capacity: 40),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 36,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
      ),
      Trip(
        id: 3,
        route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
        mode: TripMode.PICK_UP,
        bus:
            Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 56,
        shareLiveLocation: false,
        mapTraceKey: 'ABC321e2',
      ),
      Trip(
        id: 4,
        route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
        mode: TripMode.PICK_UP,
        bus: Bus(
            id: 1,
            plateNumber: 'LOY 7714',
            name: 'Hondai Coaster',
            capacity: 65),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 45,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
      ),
      Trip(
        id: 5,
        route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
        mode: TripMode.PICK_UP,
        bus: Bus(
            id: 1, plateNumber: 'LZF 8218', name: 'Coaseter VU', capacity: 40),
        drivers: [
          Driver(
              registrationID: 'EMP-DR-107',
              firstName: 'Mushtaq',
              lastName: 'Sidique'),
          Driver(
            registrationID: 'EMP-CD-108',
            firstName: 'Shakeel',
            lastName: 'Ahmed',
          )
        ],
        passengersOnBoard: 36,
        shareLiveLocation: true,
        mapTraceKey: 'ABC321e2',
      ),
    ];

    trips_suggested = [];
    dummy_trips_on_server.map((trip) {
      if (trip.route.id == favorite.routeId) {
        trip.passengerStop = trip.route.stopList
            .firstWhere((stop) => stop.name == favorite.favoriteStop.name);
        if (trip.passengerStop != null) {
          trips_suggested.add(trip);
        }
      }
    }).toList();
    notifyListeners();
  }

  void checkDistanceToNextStop(LocationData driverLocation) {
    double distance = calculateDistance(
        driverLocation.latitude,
        driverLocation.longitude,
        driverCreatedTrip.driverNextStop.latitude,
        driverCreatedTrip.driverNextStop.longitude);
    print('distance to ${driverCreatedTrip.driverNextStop.name}: $distance');
    if (distance < 0.5 &&
        _driverNextStopIndex < (_driverCreatedTrip.route.stopList.length - 1)) {
      _driverNextStopIndex++;
      driverCreatedTrip.driverNextStop =
          _driverCreatedTrip.route.stopList[_driverNextStopIndex];
      notifyListeners();
    }
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

    return dist; // output distance, in MILES
  }
}
