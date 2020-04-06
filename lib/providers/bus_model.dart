import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';

class Bus {
  int id;
  String plateNumber;
  String name;
  String model;
  String type;
  int capacity;
  int onTrip;

  Bus({
    this.id,
    this.plateNumber,
    this.name,
    this.model,
    this.type,
    this.capacity,
    this.onTrip,
  });
}

class BusProvider with ChangeNotifier {
  List<Bus> avalialbeBuses = [];

  Future<void> fetchBuses() async {
    List<Bus> fetchedBuses = [];
    try {
      final response =
          await http.get('$connectionString/buses/available-buses').timeout(requestTimeout);
      final fetchedData = json.decode(response.body)['data'] as List;
      fetchedData.forEach((data) {
        var bus = Bus(
          id: data['id'],
          plateNumber: data['plate'],
          name: data['manufacturerName'],
          model: data['model'],
          type: data['type'],
          capacity: data['capacity'],
          onTrip: data['onTrip']
        );
        fetchedBuses.add(bus);
      });
      avalialbeBuses = fetchedBuses;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Bus getBus(int id) {
    return avalialbeBuses.firstWhere((bus) => bus.id == id, orElse: () {
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
