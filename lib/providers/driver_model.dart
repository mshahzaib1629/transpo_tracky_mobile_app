import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/designation.dart';
import './person.dart';

import 'enums.dart';

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
      id: 1,
      registrationID: 'EMP-DR-1',
      firstName: 'Mushtaq',
      lastName: 'Ahmed',
      designation: Designation(id: 1, name: 'Driver'),
    ),
    Driver(
      id: 2,
      registrationID: 'EMP-DR-2',
      firstName: 'Suleman',
      lastName: 'Shafique',
      designation: Designation(id: 1, name: 'Driver'),
    ),
    Driver(
      id: 1,
      registrationID: 'EMP-DR-3',
      firstName: 'Ejaz',
      lastName: 'Khan',
      designation: Designation(id: 1, name: 'Conductor'),
    ),
  ];
}
