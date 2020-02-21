import 'bus_model.dart';
import 'enums.dart';

class TripConfig {
  String configName;
  int routeID;
  String routeName;
  int currentDriverID;
  int partnerDriverID;
  String partnerDriverReg;
  String partnerDriverName;
  Bus bus;
  BusMeterReading meter;
  String mapTraceKey;
  TripMode mode;
  DateTime startTime;

  TripConfig(
      {this.configName,
      this.routeID,
      this.routeName,
      this.currentDriverID,
      this.partnerDriverID,
      this.partnerDriverReg,
      this.partnerDriverName,
      this.bus,
      this.meter,
      this.mapTraceKey,
      this.mode,
      this.startTime});
}

List<TripConfig> dummy_trip_configs = [
  TripConfig(
    configName: 'Morning',
    routeID: 1,
    routeName: 'Route# 1',
    currentDriverID: 1,
    partnerDriverID: 2,
    partnerDriverReg: 'EMP-DR-2',
    partnerDriverName: 'Mushtaq',
    bus: Bus(
      id: 1,
      plateNumber: 'LEZ 2327',
      name: 'HINO',
    ),
    mode: TripMode.PICK_UP,
  ),
  TripConfig(
    configName: 'Evening',
    routeID: 1,
    routeName: 'Route# 1',
    currentDriverID: 1,
    partnerDriverID: 2,
    partnerDriverReg: 'EMP-DR-2',
    partnerDriverName: 'Mushtaq',
    bus: Bus(
      id: 1,
      plateNumber: 'LEZ 2327',
      name: 'HINO',
    ),
    mode: TripMode.DROP_OFF,
  ),
];
