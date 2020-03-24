import '../helpers/enums.dart';
import './person.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';

class Passenger extends Person {
  String email;
  Session session;

  Passenger({
    int id,
    String registrationID,
    String firstName,
    String lastName,
    String password,
    Gender gender,
    String contact,
    this.email,
    this.session,
  }) : super(
            id: id,
            registrationID: registrationID,
            firstName: firstName,
            lastName: lastName,
            password: password,
            gender: gender,
            contact: contact);
}
