import 'package:flutter/cupertino.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart' as r;

import 'bus_model.dart';
import 'enums.dart';

class TripConfig {
  String configName;
  r.Route route;
  Driver currentDriver;
  Driver partnerDriver;
  Bus bus;
  BusMeterReading meter;
  String mapTraceKey;
  TripMode mode;
  DateTime startTime;

  TripConfig(
      {this.configName,
      this.route,
      this.currentDriver,
      this.partnerDriver,
      this.bus,
      this.meter,
      this.mapTraceKey,
      this.mode,
      this.startTime});
}

class TripConfigProvider with ChangeNotifier {
  List<TripConfig> _dummyTripConfigs = [
    TripConfig(
      configName: 'Morning',
      route: r.Route(id: 1),
      currentDriver: Driver(id: 1),
      partnerDriver: Driver(id: 2),
      bus: Bus(
        id: 1,
      ),
      mode: TripMode.PICK_UP,
    ),
    TripConfig(
      configName: 'Evening',
      route: r.Route(id: 1),
      currentDriver: Driver(id: 1),
      partnerDriver: Driver(id: 2),
      bus: Bus(id: 1),
      mode: TripMode.DROP_OFF,
    ),
  ];

  List<TripConfig> get dummyTripConfigs {
    return [..._dummyTripConfigs];
  }

  void addTripConfig(TripConfig newTripConfig) {
    dummyTripConfigs.forEach((config) {
      print(config.configName +
          ' ' +
          config.bus.id.toString() +
          ' ' +
          config.mode.toString());
    });
    _dummyTripConfigs.add(newTripConfig);
    notifyListeners();
  }
}
