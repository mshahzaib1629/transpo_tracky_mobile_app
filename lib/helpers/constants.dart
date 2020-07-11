import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/passenger_model.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';

class Constants {
// [1]
  static const double thresholdDistance = 0.05;

// [2]
  static const double stopRadius = 0.5;

// [3]
  static const double passengerRange = 5;

// [4]
  static const double mapZoomHomePage = 18;
  static const double mapZoomNavPage = 18;
  static const double mapZoomTrackPage = 18;

// ------------ Dummy data for testing purpose -----------

  static Session dummyCurrentSession = Session(
    id: 1,
    name: 'Spring-20',
  );

  static Driver dummyDriver = Driver(
    id: 3,
    registrationID: 'EMP-DR-02',
    firstName: 'Afzal',
    lastName: 'Khan',
  );

  static Passenger dummyPassenger = Passenger(
      id: 1,
      registrationID: 'FA16-BCS-340',
      firstName: 'Shahzaib',
      lastName: 'Minhas');
}

// [1]
// _thresholdDistance is the value after which the coordinates in firebase, _lastCheckpoint and polylines are getting updated.
// e.g at _threshold = 0.02 (0.02 km / 20 m), update values whenever lastCheckpoint is 20 m away from current location.

// [2]
// whenever the driver is arriving any stop, trip's next stop gets updated if driver is having this minimum distance from
// current stop's radius.
// e.g. at stopRadius = 0.5 (km), driver will be considered reached to the stop if he has 0.5 km distance from the certain stop

// [3]
// Defining passenger's range (in km) in which nearby trips are meant to be suggested.

// [4]
// Level of zooming on maps
