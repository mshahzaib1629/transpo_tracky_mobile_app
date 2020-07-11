import 'package:flutter/cupertino.dart';
import 'package:transpo_tracky_mobile_app/providers/designation.dart';
import './person.dart';

import '../helpers/enums.dart';

class Driver extends Person {
  Designation designation;
  String cnic;
  String address;
  bool onTrip;

  Driver(
      {int id,
      String registrationID,
      String firstName,
      String lastName,
      Gender gender,
      String contact,
      String password,
      this.designation,
      this.cnic,
      this.address,
      this.onTrip})
      : super(
          id: id,
          registrationID: registrationID,
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          contact: contact,
          password: password,
        );
}

class DriverProvider with ChangeNotifier {
  List<Driver> dummy_available_drivers = [
    Driver(
      id: 11,
      registrationID: 'EMP-CD-1',
      firstName: 'Mushtaq',
      lastName: 'Ahmed',
      designation: Designation(id: 1, name: 'Driver'),
    ),
    Driver(
      id: 4,
      registrationID: 'EMP-AD-01',
      firstName: 'Suleman',
      lastName: 'Shafique',
      designation: Designation(id: 1, name: 'Driver'),
    ),
  ];

  Driver getDriver(int id) {
    return dummy_available_drivers.firstWhere((driver) => driver.id == id,
        orElse: () {
      return null;
    });
  }
}
