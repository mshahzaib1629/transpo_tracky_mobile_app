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

// ----------- For Meter Readings -----------

class BusMeterReading {
  double initialReading;
  double finalReading;

  BusMeterReading({
    this.initialReading,
    this.finalReading,
  });
}
