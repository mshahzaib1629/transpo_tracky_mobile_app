import 'package:transpo_tracky_mobile_app/providers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';

class Passenger {
  int id;
  String registrationId;
  String firstName;
  String lastName;
  String password;
  Gender gender;
  String contact;
  String email;
  Session session;

  Passenger({
    int id,
    String registrationId,
    String firstName,
    String lastName,
    String password,
    Gender gender,
    String contact,
    String email,
    Session session,
  });
}
