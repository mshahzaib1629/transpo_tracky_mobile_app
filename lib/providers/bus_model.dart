import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Bus {
  int id;
  String plateNumber;
  String name;
  int capacity;

  Bus({
    this.id,
    this.plateNumber,
    this.name,
    this.capacity,
  });
}

class BusProvider with ChangeNotifier {
  List<Bus> dummy_avalialbeBuses = [
    Bus(
      id: 1,
      plateNumber: 'LEZ 2327',
      name: 'HINO Coaster',
      capacity: 45,
    ),
    Bus(
      id: 2,
      plateNumber: 'LOY 2135',
      name: 'HINO Bus',
      capacity: 65,
    ),
    Bus(
      id: 3,
      plateNumber: 'LZF 8218',
      name: 'Hiace Coaster',
      capacity: 50,
    ),
  ];

  Bus getBus(int id) {
    return dummy_avalialbeBuses.firstWhere((bus) => bus.id == id, orElse: () {
      return null;
    });
  }
}

// ----------- For Meter Readings -----------

class BusMeterReading {
  double initialReading;
  double finalReading;

  BusMeterReading({
    this.initialReading,
    this.finalReading,
  });
}
