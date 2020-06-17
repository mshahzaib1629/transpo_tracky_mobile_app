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
        // timeReached: '6:50 AM',
        estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      ),
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

  List<Trip> _suggestedTrips = [];

  List<Trip> _tripsRecord = [
    // Trip(
    //   id: 1,
    //   route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
    //   passengerStop: Stop(
    //       id: 1,
    //       name: 'Sagian Pull',
    //       longitude: 1235.05,
    //       latitude: 78453,
    //       timeReached: '7:35 AM'),
    //   mode: TripMode.PICK_UP,
    //   drivers: [
    //     Driver(
    //         registrationID: 'EMP-DR-107',
    //         firstName: 'Mushtaq',
    //         lastName: 'Sidique'),
    //     Driver(
    //       registrationID: 'EMP-CD-108',
    //       firstName: 'Shakeel',
    //       lastName: 'Ahmed',
    //     )
    //   ],
    //   bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    //   passengersOnBoard: 45,
    //   meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
    //   startTime: '6:20 AM',
    //   endTime: '8:25 AM',
    //   mapTraceKey: 'ABC321e2',
    // ),
    // Trip(
    //   id: 2,
    //   route: r.Route(
    //       id: 2, name: 'Route# 2', stopList: dummy_stops_2.reversed.toList()),
    //   passengerStop: Stop(
    //       id: 1,
    //       name: 'Sagian Pull',
    //       longitude: 1235.05,
    //       latitude: 78453,
    //       timeReached: '7:35 AM'),
    //   mode: TripMode.DROP_OFF,
    //   drivers: [
    //     Driver(
    //         registrationID: 'EMP-DR-107',
    //         firstName: 'Mushtaq',
    //         lastName: 'Sidique'),
    //     Driver(
    //       registrationID: 'EMP-CD-108',
    //       firstName: 'Shakeel',
    //       lastName: 'Ahmed',
    //     )
    //   ],
    //   bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    //   passengersOnBoard: 45,
    //   meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
    //   startTime: '6:20 AM',
    //   endTime: '8:25 AM',
    //   mapTraceKey: 'ABC321e2',
    // ),
    // Trip(
    //   id: 2,
    //   route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
    //   passengerStop: Stop(
    //       id: 1,
    //       name: 'Sagian Pull',
    //       longitude: 1235.05,
    //       latitude: 78453,
    //       timeReached: '7:35 AM'),
    //   mode: TripMode.PICK_UP,
    //   drivers: [
    //     Driver(
    //         registrationID: 'EMP-DR-107',
    //         firstName: 'Mushtaq',
    //         lastName: 'Sidique'),
    //     Driver(
    //       registrationID: 'EMP-CD-108',
    //       firstName: 'Shakeel',
    //       lastName: 'Ahmed',
    //     )
    //   ],
    //   bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    //   passengersOnBoard: 45,
    //   meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
    //   startTime: '6:20 AM',
    //   endTime: '8:25 AM',
    //   mapTraceKey: 'ABC321e2',
    // ),
    // Trip(
    //   id: 2,
    //   route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
    //   passengerStop: Stop(
    //       id: 1,
    //       name: 'Sagian Pull',
    //       longitude: 1235.05,
    //       latitude: 78453,
    //       timeReached: '7:35 AM'),
    //   mode: TripMode.PICK_UP,
    //   drivers: [
    //     Driver(
    //         registrationID: 'EMP-DR-107',
    //         firstName: 'Mushtaq',
    //         lastName: 'Sidique'),
    //     Driver(
    //       registrationID: 'EMP-CD-108',
    //       firstName: 'Shakeel',
    //       lastName: 'Ahmed',
    //     )
    //   ],
    //   bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    //   passengersOnBoard: 45,
    //   meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
    //   startTime: '6:20 AM',
    //   endTime: '8:25 AM',
    //   mapTraceKey: 'ABC321e2',
    // ),
    // Trip(
    //   id: 2,
    //   route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
    //   passengerStop: Stop(
    //       id: 1,
    //       name: 'Sagian Pull',
    //       longitude: 1235.05,
    //       latitude: 78453,
    //       timeReached: '7:35 AM'),
    //   mode: TripMode.PICK_UP,
    //   drivers: [
    //     Driver(
    //         registrationID: 'EMP-DR-107',
    //         firstName: 'Mushtaq',
    //         lastName: 'Sidique'),
    //     Driver(
    //       registrationID: 'EMP-CD-108',
    //       firstName: 'Shakeel',
    //       lastName: 'Ahmed',
    //     )
    //   ],
    //   bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    //   passengersOnBoard: 45,
    //   meter: BusMeterReading(initialReading: 1720.3, finalReading: 1850.5),
    //   startTime: '6:20 AM',
    //   endTime: '8:25 AM',
    //   mapTraceKey: 'ABC321e2',
    // ),
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
    List<Driver> driversList = [];
    driversList.add(config.currentDriver);
    if (config.partnerDriver != null) driversList.add(config.partnerDriver);
    try {
      await MapHelper.updateDriverLocation(trackingKey, currentLocation);

      final requestBody = {
        "routeId": config.route.id,
        "busId": config.bus.id,
        "driversList": driversList.map((driver) => {"id": driver.id}).toList(),
        "tripMode": config.mode == TripMode.PICK_UP ? "PICK_UP" : "DROP_OFF",
        "mapTraceKey": trackingKey,
        "initialMeterReading": config.meter.initialReading
      };

      final response = await http.post(
        '$connectionString/trips',
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode(requestBody),
      );

      print(json.decode(response.body));
      print('status: ${response.statusCode}');
    } catch (error) {
      throw error;
    }

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
    // _driverCreatedTrip = null;
    _driverNextStopIndex = 0;
    notifyListeners();
  }

  Future<void> fetchSuggestedTrips(double latitude, double longitude) async {
    _suggestedTrips = [];
    var range = 5;
    try {
      final response = await http
          .get(
              '$connectionString/trips/suggest/latitude=$latitude,longitude=$longitude,range=$range')
          .timeout(requestTimeout);
      print(json.decode(response.body)['message']);
      final fetchedData = json.decode(response.body)['data'] as List;
      fetchedData.forEach((data) {
        var trip = Trip(
          id: data['trip']['id'],
          route: r.Route(
            id: data['trip']['route']['id'],
            name: data['trip']['route']['name'],
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
          mapTraceKey: data['mapTraceKey'],
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
    notifyListeners();
  }

  get getSuggestedTrips {
    _suggestedTrips.sort((t1, t2) => t1.passengerStop.distanceFromUser
        .compareTo(t2.passengerStop.distanceFromUser));
    return _suggestedTrips;
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

    _suggestedTrips = [];
    dummy_trips_on_server.map((trip) {
      if (trip.route.id == favorite.routeId) {
        trip.passengerStop = trip.route.stopList
            .firstWhere((stop) => stop.name == favorite.favoriteStop.name);
        if (trip.passengerStop != null) {
          _suggestedTrips.add(trip);
        }
      }
    }).toList();
    notifyListeners();
  }

  Future<void> fetchTripsRecord() async {
    // we send request to same url for both driver & passenger, just filter by userType variable for responding
    LoginMode userType = LoginMode.Driver;

    List<Trip> fetchedTrips = [];
    try {
      final response = await http
          .get(
              '$connectionString/trips/tripsRecord/userType=${userType == LoginMode.Driver ? "EMPLOYEE" : "PASSENGER"},userId=${13},limit=${30}')
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
              stopList: [],
            ),
            drivers: [],
            bus: Bus(
              id: data['bus']['id'],
              name: data['bus']['name'],
              plateNumber: data['bus']['plate'],
              capacity: data['bus']['capacity'],
            ),
            startTime: DateFormat('yyyy-MM-ddTHH:mm:ss', 'en_US')
                .parse(data['startTime']),
            endTime: DateFormat('yyyy-MM-ddTHH:mm:ss', 'en_US')
                .parse(data['endTime']),
            mapTraceKey: data['mapTraceKey'],
            passengersOnBoard: data['no_of_passengers']);

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
