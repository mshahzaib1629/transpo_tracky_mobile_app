import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart' as r;
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import '../helpers/local_db_helper.dart';
import 'bus_model.dart';
import '../helpers/enums.dart';

class TripConfig {
  int id;
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
      {this.id,
      this.configName,
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
    LocalDatabase.insert('auto_configs', {
      'configName': config.configName,
      'currentDriverId': config.currentDriver.id,
      'routeId': config.route.id,
      'busId': config.bus.id,
      'mode': config.mode.toString(),
      'partnerDriverId':
          config.partnerDriver != null ? config.partnerDriver.id : null,
    });
    notifyListeners();
  }

  Future<void> fetchAndSetConfigs({int currentDriverId}) async {
    final dataList = await LocalDatabase.getDriverConfigs(currentDriverId);
    _savedTripConfigs = dataList
        .map((config) => TripConfig(
            id: config['id'],
            configName: config['configName'],
            currentDriver: Driver(id: config['currentDriverId']),
            route: r.Route(id: config['routeId'], name: config['routeName']),
            bus: Bus(id: config['busId']),
            mode: config['mode'] == 'TripMode.PICK_UP'
                ? TripMode.PICK_UP
                : TripMode.DROP_OFF,
            partnerDriver: config['partnerDriverId'] != null
                ? Driver(id: config['partnerDriverId'])
                : null))
        .toList();
    notifyListeners();
  }

  void deleteConfig(int id) {
    LocalDatabase.delete('auto_configs', id);
    notifyListeners();
  }
}
