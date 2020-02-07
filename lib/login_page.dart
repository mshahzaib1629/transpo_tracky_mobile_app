import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_home_page.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_home_page.dart';
import 'package:transpo_tracky_mobile_app/size_config.dart';
import 'package:transpo_tracky_mobile_app/styling.dart';

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
            decoration: InputDecoration(
              labelText: _loginMode == LoginMode.Passenger
                  ? 'Enter Passenger ID'
                  : 'Enter Driver ID',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(
            height: 3.1 * SizeConfig.heightMultiplier,
          ),
          TextFormField(
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Enter Password',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        if (_loginMode == LoginMode.Driver) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DriverHomePage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PassengerHomePage()));
        }
      },
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFF0F55F),
            borderRadius:
                BorderRadius.circular(0.78 * SizeConfig.heightMultiplier),
            boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.5),
              blurRadius: 15,
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
          style: Theme.of(context).textTheme.button.copyWith(color: Colors.black),
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
                  style: Theme.of(context).textTheme.display2.copyWith(color: Colors.white),
                ),
                onPressed: () => _toggleLoginMode(),
                padding: EdgeInsets.symmetric(
                    horizontal: 0.78 * SizeConfig.heightMultiplier),
              ),
            ),
            FittedBox(
              child: FlatButton(
                child: Text("Forgot Password?",
                    style: Theme.of(context).textTheme.display2.copyWith(color: Colors.white)),
                onPressed: () {},
                padding:
                    EdgeInsets.only(left: 0.78 * SizeConfig.heightMultiplier),
              ),
            ),
          ],
        )
      ],
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
          margin: EdgeInsets.symmetric(
              horizontal: 12.5 * SizeConfig.widthMultiplier,
              vertical: 9.94 * SizeConfig.heightMultiplier),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}

enum LoginMode { Passenger, Driver }
