import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_home_page.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_signup_page.dart';
import 'package:transpo_tracky_mobile_app/helpers/manual_exception.dart';
import 'package:transpo_tracky_mobile_app/helpers/styling.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_home_page.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_signup_page.dart';
import 'package:transpo_tracky_mobile_app/providers/auth.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';

import '../helpers/enums.dart';
import '../helpers/size_config.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginMode _loginMode = LoginMode.Passenger;
  final _passwordFocusNode = FocusNode();

  Map<String, String> _authData = {
    'regId': '',
    'password': '',
  };
  final _inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        ),
        borderRadius:
            BorderRadius.circular(3.33 * SizeConfig.imageSizeMultiplier),
        gapPadding: 5),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.accentColor,
          width: 2,
        ),
        borderRadius:
            BorderRadius.circular(3.33 * SizeConfig.imageSizeMultiplier),
        gapPadding: 5),
  );

  void _toggleLoginMode() {
    if (_loginMode == LoginMode.Passenger)
      setState(() {
        _loginMode = LoginMode.Driver;
      });
    else
      setState(() {
        _loginMode = LoginMode.Passenger;
      });
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: _inputDecoration.copyWith(
              hintText: _loginMode == LoginMode.Passenger
                  ? 'Enter Passenger ID'
                  : 'Enter Driver ID',
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            onSaved: (value) {
              _authData['regId'] = value;
            },
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_passwordFocusNode),
            // onChanged: (value) => _regController.text = value,
          ),
          SizedBox(
            height: 3.1 * SizeConfig.heightMultiplier,
          ),
          TextFormField(
            focusNode: _passwordFocusNode,
            cursorColor: Colors.black,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
            ),
            onSaved: (value) {
              _authData['password'] = value;
            },
            decoration: _inputDecoration.copyWith(hintText: 'Enter Password'),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    // print('${_authData['regId']}, ${_authData['password']}');
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['regId'], _authData['password'], _loginMode);
    } on ManualException catch (error) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Align(
                alignment: Alignment.centerLeft, child: Text(error.title)),
            content: Text(error.message),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          ));
    } catch (error) {
      showDialog(
          context: context,
          child: AlertDialog(
            title:
                Align(alignment: Alignment.centerLeft, child: Text('Oh no!')),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          ));
    }
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        // if (_loginMode == LoginMode.Driver) {
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(builder: (context) => DriverHomePage()));
        // } else {
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(builder: (context) => PassengerHomePage()));
        // }

        _submitForm();
      },
      child: Container(
        height: 7.81 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFF0F55F),
            borderRadius:
                BorderRadius.circular(3.33 * SizeConfig.imageSizeMultiplier),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 0.5),
                blurRadius: 4.16 * SizeConfig.imageSizeMultiplier,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -0.5),
                blurRadius: 15,
              ),
            ]),
        child: Center(
            child: Text(
          'LOGIN',
          style:
              Theme.of(context).textTheme.button.copyWith(color: Colors.black),
        )),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        _buildLoginButton(),
        SizedBox(
          height: 0.78 * SizeConfig.heightMultiplier,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FittedBox(
              child: FlatButton(
                child: Text(
                  _loginMode == LoginMode.Passenger
                      ? "Login as Driver?"
                      : "Login as Passenger?",
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .copyWith(color: Colors.white),
                ),
                onPressed: () => _toggleLoginMode(),
                padding: EdgeInsets.symmetric(
                    horizontal: 0.78 * SizeConfig.heightMultiplier),
              ),
            ),
            FittedBox(
              child: FlatButton(
                child: Text("Forgot Password?",
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(color: Colors.white)),
                onPressed: () {},
                padding:
                    EdgeInsets.only(left: 0.78 * SizeConfig.heightMultiplier),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return FlatButton(
      padding: EdgeInsets.only(
        bottom: 1.5 * SizeConfig.heightMultiplier,
        top: 3.12 * SizeConfig.heightMultiplier,
      ),
      onPressed: () {
        final _sessionProvider =
            Provider.of<SessionProvider>(context, listen: false);
        showDialog(
            context: context,
            child: AlertDialog(
              content: Text('Sign up as?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverSignUpPage()));
                  },
                  child: Text('Driver'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _sessionProvider.currentSession != null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassengerSignUpPage()))
                        : showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Text('No Active Session found.'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                )
                              ],
                            ),
                          );
                  },
                  child: Text('Passenger'),
                )
              ],
            ));
      },
      child: Text('SIGN UP',
          style: Theme.of(context)
              .textTheme
              .display2
              .copyWith(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: 12.5 * SizeConfig.widthMultiplier,
            right: 12.5 * SizeConfig.widthMultiplier,
            top: 9.84 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/logo_files/portrait.png'),
                  width: 61.1 * SizeConfig.widthMultiplier,
                  height: 34.4 * SizeConfig.heightMultiplier,
                ),
                alignment: Alignment.center,
                // margin: EdgeInsets.only(top: 50, bottom: 30),
              ),
              SizedBox(
                height: 4.1 * SizeConfig.heightMultiplier,
              ),
              _buildForm(),
              SizedBox(
                height: 3.9 * SizeConfig.heightMultiplier,
              ),
              _buildButtons(),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}
