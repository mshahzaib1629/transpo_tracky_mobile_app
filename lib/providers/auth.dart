import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo_tracky_mobile_app/helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import 'package:transpo_tracky_mobile_app/providers/designation.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/passenger_model.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';

import '../helpers/manual_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;
  dynamic _currentUser;
  LoginMode _loginMode;

  bool get isAuth {
    return token != null;
  }

  String get token {
    // if (_expiryDate != null &&
    //     _expiryDate.isAfter(DateTime.now()) &&
    //     _token != null)
    if (_token != null) {
      return _token;
    }
    return null;
  }

  LoginMode get loginMode {
    return _loginMode;
  }

  dynamic get currentUser {
    return _currentUser;
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {
  //   final url =
  //       'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {
  //           'email': email,
  //           'password': password,
  //           'returnSecureToken': true,
  //         },
  //       ),
  //     );
  //     final responseData = json.decode(response.body);
  //     if (responseData['error'] != null) {
  //       throw ManualException(message: responseData['error']['message']);
  //     }
  //     _token = responseData['idToken'];
  //     _userId = responseData['localId'];
  //     _expiryDate = DateTime.now().add(
  //       Duration(
  //         seconds: int.parse(
  //           responseData['expiresIn'],
  //         ),
  //       ),
  //     );
  //     _autoLogout();
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode(
  //       {
  //         'token': _token,
  //         'userId': _userId,
  //         'expiryDate': _expiryDate.toIso8601String(),
  //       },
  //     );
  //     prefs.setString('userData', userData);
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  String getGenderString(Gender gender) {
    if (gender == Gender.Male)
      return 'Male';
    else if (gender == Gender.Female)
      return 'Female';
    else
      return 'Other';
  }

  Gender getGenderEnum(String gender) {
    if (gender == 'Male')
      return Gender.Male;
    else if (gender == 'Female')
      return Gender.Female;
    else
      return Gender.Other;
  }

  Future<void> driverSignup(
      {String regId,
      Designation designation,
      String firstName,
      String lastName,
      String cnic,
      String address,
      Gender gender,
      String contact,
      String password}) async {
    try {
      final response = await http
          .post('$connectionString/employee/signup',
              headers: {
                "accept": "application/json",
                "content-type": "application/json",
                "connection": "keep-alive",
              },
              body: json.encode({
                "registrationId": regId,
                "firstName": firstName,
                "lastName": lastName,
                // ignore: missing_return
                "gender": getGenderString(gender),
                "password": password,
                "designationID": designation.id,
                "contact": contact,
                "cnic": cnic,
                "address": address
              }))
          .timeout(requestTimeout);

      print(json.decode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> passengerSignup({
    String regId,
    String firstName,
    String lastName,
    Gender gender,
    String contact,
    String email,
    String password,
    Session currentSession,
  }) {
    print('sign up ready to go!');
    print(regId +
        ' f-Name: ' +
        firstName +
        ' l-Name: ' +
        lastName +
        ' contact: ' +
        contact +
        ' gender: ' +
        gender.toString() +
        ' password: ' +
        password +
        ' session: ' +
        currentSession.name);
  }

  Future<void> login(String regId, String password, LoginMode mode) async {
    // return _authenticate(email, password, 'verifyPassword');

    _loginMode = mode;
    try {
      if (_loginMode == LoginMode.Driver) {
        final response = await http.post("$connectionString/employee/login",
            body: {
              "registrationId": regId,
              "password": password
            }).timeout(requestTimeout);
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        if (responseData['message'] == 'auth failed!')
          throw ManualException(
              title: 'Login Failed!',
              message: 'User id or password is incorrect.');

        
        _token = responseData['token'];
        _currentUser = Driver(
          id: responseData['data']['id']['employeeId'],
          registrationID: responseData['data']['id']['registrationId'],
          firstName: responseData['data']['name']['firstName'],
          lastName: responseData['data']['name']['lastName'],
          gender: getGenderEnum(responseData['data']['gender']),
          designation: Designation(
              id: responseData['data']['designation']['id'],
              name: responseData['data']['designation']['Type']),
          cnic: responseData['data']['Personal_details']['CNIC'],
          contact: responseData['data']['Personal_details']['contact'],
          address: responseData['data']['Personal_details']['Address'],
          password: responseData['data']['password'],
        );
        

      } else if (_loginMode == LoginMode.Passenger) {
        _token = '12345678';
        _currentUser = Passenger(
          id: 3,
          registrationID: regId,
          firstName: '',
          lastName: 'Khan',
        );

        // print('token: ' +
        // token +
        // ' user id: ' +
        // currentUser.id.toString() +
        // ' reg id: ' +
        // currentUser.registrationID +
        // ' f-Name: ' +
        // currentUser.firstName +
        // ' l-Name: ' +
        // currentUser.lastName +
        // ' contact: ' +
        // currentUser.contact +
        // ' gender: ' +
        // currentUser.gender.toString() +
        // ' password: ' +
        // currentUser.password +
        // ' address: ' +
        // currentUser.address +
        // ' designation: ' +
        // currentUser.designation.name);
      }
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;
  // }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
