import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';

import 'driver_model.dart';
import 'enums.dart';
import 'route_model.dart' as r;
import 'bus_model.dart';

class Trip {
  int id;
  r.Route route;
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

List<Trip> dummy_trips_suggested = [
  Trip(
    id: 1,
    route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    passengersOnBoard: 45,
    shareLiveLocation: true,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 2,
    route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LEZ 4421', name: 'Coaseter VU', capacity: 40),
    passengersOnBoard: 36,
    shareLiveLocation: true,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 3,
    route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
    passengersOnBoard: 56,
    shareLiveLocation: false,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 1,
    route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    passengersOnBoard: 45,
    shareLiveLocation: true,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 2,
    route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LEZ 4421', name: 'Coaseter VU', capacity: 40),
    passengersOnBoard: 36,
    shareLiveLocation: true,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 3,
    route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
    passengersOnBoard: 56,
    shareLiveLocation: false,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 1,
    route: r.Route(id: 1, name: 'Route# 1', stopList: dummy_stops_1),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LEZ 2327', name: 'HINO 17', capacity: 65),
    passengersOnBoard: 45,
    shareLiveLocation: true,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 2,
    route: r.Route(id: 3, name: 'Route# 3', stopList: dummy_stops_3),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LEZ 4421', name: 'Coaseter VU', capacity: 40),
    passengersOnBoard: 36,
    shareLiveLocation: true,
    mapTraceKey: 'ABC321e2',
  ),
  Trip(
    id: 3,
    route: r.Route(id: 2, name: 'Route# 2', stopList: dummy_stops_2),
    mode: TripMode.PICK_UP,
    bus: Bus(id: 1, plateNumber: 'LOY 7741', name: 'Mazda 17', capacity: 55),
    passengersOnBoard: 56,
    shareLiveLocation: false,
    mapTraceKey: 'ABC321e2',
  ),
];
