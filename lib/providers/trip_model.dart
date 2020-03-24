import 'package:flutter/cupertino.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';

import 'driver_model.dart';
import '../helpers/enums.dart';
import 'route_model.dart' as r;
import 'bus_model.dart';

class Trip {
  int id;
  // pass trip's stops from DB to the route's stopList here
  r.Route route;
  Stop passengerStop;
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
  Trip _driverCreatedTrip;

  Trip get passengerSelectedTrip {
    return _passengerSelectedTrip;
  }

  Trip get driverCreatedTrip {
    return _driverCreatedTrip;
  }

  List<Trip> dummy_trips_suggested = [
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
      bus: Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
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
      bus: Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
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
      bus: Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
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
  ];

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
  void setSelectedTrip({Trip selectedTrip, Stop selectedStop}) {
    this._passengerSelectedTrip = selectedTrip;
    _passengerSelectedTrip.passengerStop = selectedStop;
    notifyListeners();
  }

// for driver
  void startTrip({TripConfig config}) {
    List<Driver> driversList = [];
    driversList.add(config.currentDriver);
    if (config.partnerDriver != null) driversList.add(config.partnerDriver);
    _driverCreatedTrip = Trip(
        route: config.route,
        bus: config.bus,
        meter: config.meter,
        mode: config.mode,
        drivers: driversList);
    // ---------------------
    // add server notify logic here
    // ---------------------
  }

  // for passenger
  void passengerEndTrip() {
    // ---------------------
    // add server notify / review logic here
    // ---------------------
    _passengerSelectedTrip = null;
  }

  void driverEndTrip(BusMeterReading reading) {
    _driverCreatedTrip.meter.finalReading = reading.finalReading;
    // ---------------------
    // add server notify logic here
    // ---------------------
    _driverCreatedTrip = null;
  }
}
