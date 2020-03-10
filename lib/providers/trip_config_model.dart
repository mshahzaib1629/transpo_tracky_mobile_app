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
  List<TripConfig> _savedTripConfigs = [];

  List<TripConfig> get savedTripConfigs {
    return [..._savedTripConfigs];
  }

  void addTripConfig(TripConfig config) {
    TripConfig newTripConfig = TripConfig(
      configName: config.configName,
      route: config.route,
      bus: config.bus,
      mode: config.mode,
      currentDriver: config.currentDriver,
      partnerDriver: config.partnerDriver,
    );
    _savedTripConfigs.add(newTripConfig);
    notifyListeners();
  }
}
