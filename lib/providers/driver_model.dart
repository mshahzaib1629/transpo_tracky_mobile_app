import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'enums.dart';

class Driver {
  int id;
  String registrationID;
  String firstName;
  String lastName;
  Gender gender;
  String designationName;
  String cnic;
  String contactNum;
  String address;
  String password;

  Driver({
    this.id,
    this.registrationID,
    this.firstName,
    this.lastName,
    this.gender,
    this.designationName,
    this.cnic,
    this.contactNum,
    this.address,
    this.password,
  });
}

class DriverProvider with ChangeNotifier {
  List<Driver> dummy_available_drivers = [
    Driver(
      id: 1,
      registrationID: 'EMP-DR-1',
      firstName: 'Mushtaq',
      lastName: 'Ahmed',
    ),
    Driver(
      id: 2,
      registrationID: 'EMP-DR-2',
      firstName: 'Suleman',
      lastName: 'Shafique',
    ),
    Driver(
      id: 1,
      registrationID: 'EMP-DR-3',
      firstName: 'Ejaz',
      lastName: 'Khan',
    ),
  ];
}
