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
