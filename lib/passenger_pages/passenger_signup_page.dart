import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/auth.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/passenger_model.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';
import '../helpers/size_config.dart';

class PassengerSignUpPage extends StatefulWidget {
  PassengerSignUpPage({Key key}) : super(key: key);

  @override
  _PassengerSignUpPageState createState() => _PassengerSignUpPageState();
}

class _PassengerSignUpPageState extends State<PassengerSignUpPage> {
  int _pageCounter = 1;
  final _passengerSignupKey = GlobalKey<FormState>();

  final _registrationIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  var _passengerForm = Passenger(
      registrationID: '',
      firstName: '',
      lastName: '',
      gender: Gender.Male,
      contact: '',
      email: '',
      password: '',
      session: null);

// common configurations through out the pages:
  double _topPadding = 3.75 * SizeConfig.heightMultiplier;
  double _paddingAfterTitle = 18.75 * SizeConfig.heightMultiplier;
  double _titleSize = 4.5 * SizeConfig.textMultiplier;

  void _saveForm() {
    final isValid = _passengerSignupKey.currentState.validate();
    if (isValid) {
      _passengerSignupKey.currentState.save();
    }
  }

  @override
  void dispose() {
    _registrationIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_passengerSignupKey.currentState.validate()) {
      _saveForm();

      Provider.of<Auth>(context, listen: false)
          .passengerSignup(
            regId: _passengerForm.registrationID,
            firstName: _passengerForm.firstName,
            lastName: _passengerForm.lastName,
            contact: _passengerForm.contact,
            email: _passengerForm.email,
            gender: _passengerForm.gender,
            currentSession: _passengerForm.session,
            password: _passengerForm.password,
          )
          .then((value) => showDialog(
              context: context,
              child: AlertDialog(
                title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Thanks for your time')),
                content: Text(
                    'Your request is pending for admin approval. You\'ll be notified soon.'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              )))
          .catchError((error) => showDialog(
              context: context,
              child: AlertDialog(
                title: Align(
                    alignment: Alignment.centerLeft, child: Text('Oh no!')),
                content: Text('Something is went wrong.'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'))
                ],
              )));
    }
  }

  Widget _welcomePage(BuildContext context) {
    Session currentSession =
        Provider.of<SessionProvider>(context, listen: false).currentSession;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: _topPadding,
              ),
              Text(
                'Welcome',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 4.5 * SizeConfig.textMultiplier),
              ),
              Text(
                'to',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontStyle: FontStyle.italic),
              ),
              Text(
                '${currentSession.name} Registration',
                style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 4.5 * SizeConfig.textMultiplier,
                    color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 9.38 * SizeConfig.heightMultiplier,
        ),
        Text('To proceed, click Next!'),
      ],
    );
  }

  Widget _registrationPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: _topPadding,
          ),
          Text('Enter Your Registration ID',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: _titleSize)),
          SizedBox(
            height: _paddingAfterTitle,
          ),
          _inputContainer(
            input: TextFormField(
              controller: _registrationIdController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                  border: InputBorder.none,
                  labelText: 'Registration ID *',
                  hintText: 'FA00-AAA-000'),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {},
              onSaved: (value) {
                setState(() {
                  _passengerForm.registrationID = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) return 'What is your Registration Id?';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _namePage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: _topPadding),
          Text('What should we call you?',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: _titleSize)),
          SizedBox(
            height: _paddingAfterTitle,
          ),
          _inputContainer(
            input: TextFormField(
              autofocus: false,
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                border: InputBorder.none,
                labelText: 'First Name *',
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_lastNameFocusNode);
              },
              onSaved: (value) {
                setState(() {
                  _passengerForm.firstName = value;
                });
              },
              validator: (value) {
                if (value.isEmpty) return 'What is your first name?';
                return null;
              },
            ),
          ),
          SizedBox(
            height: 1.8 * SizeConfig.heightMultiplier,
          ),
          _inputContainer(
            input: TextFormField(
              autofocus: false,
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              focusNode: _lastNameFocusNode,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                border: InputBorder.none,
                labelText: 'Last Name',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {},
              onSaved: (value) {
                setState(() {
                  _passengerForm.lastName = value;
                });
              },
            ),
          ),
          SizedBox(height: 1.8 * SizeConfig.heightMultiplier),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 28.125 * SizeConfig.widthMultiplier,
              child: DropdownButtonFormField<Gender>(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    errorMaxLines: 2),
                hint: Text('Gender'),
                value: _passengerForm.gender,
                items:
                    Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
                  return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(_extractGenderValue(value.toString())));
                }).toList(),
                validator: (value) {
                  if (value == null) return 'Please specify gender';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _passengerForm.gender = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _contactPage(BuildContext context) {
    final _emailFocusNode = FocusNode();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: _topPadding,
          ),
          Text('How should we contact you?',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: _titleSize)),
          SizedBox(
            height: _paddingAfterTitle,
          ),
          _inputContainer(
            input: TextFormField(
              autofocus: false,
              controller: _contactController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                  border: InputBorder.none,
                  labelText: 'Contact Number *',
                  hintText: '03XXXXXXXXX',
                  errorMaxLines: 2),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              validator: (value) {
                if (value.isEmpty)
                  return 'Please provide your contact number, we keep it confidential';
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _passengerForm.contact = value;
                });
              },
            ),
          ),
          SizedBox(
            height: 1.8 * SizeConfig.heightMultiplier,
          ),
          _inputContainer(
            input: TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                border: InputBorder.none,
                labelText: 'Email Id',
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {},
              validator: (value) {
                if (value.isNotEmpty && !value.contains('@'))
                  return 'Enter valid email id';
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _passengerForm.email = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: _topPadding,
          ),
          Text('Finally, set up your password!',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: _titleSize)),
          SizedBox(
            height: _paddingAfterTitle,
          ),
          _inputContainer(
            input: TextFormField(
              controller: _passwordController,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                border: InputBorder.none,
                labelText: 'Password *',
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) return 'Enter Password';
                return null;
              },
              onSaved: (value) {},
            ),
          ),
          SizedBox(
            height: 1.8 * SizeConfig.heightMultiplier,
          ),
          _inputContainer(
            input: TextFormField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                border: InputBorder.none,
                labelText: 'Confirm Password',
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {},
              onSaved: (value) {
                if (_passwordController.text == value) {
                  _passengerForm.password = value;
                }
              },
              validator: (value) {
                if (_passwordController.text != value)
                  return 'Password doesn\'t match!';

                return null;
              },
            ),
          ),
          SizedBox(
            height: 7.5 * SizeConfig.heightMultiplier,
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: _submitForm,
              child: Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPages(BuildContext context) {
    print('pagecounter: ' + _pageCounter.toString());
    switch (_pageCounter) {
      case 1:
        return _welcomePage(context);
        break;
      case 2:
        return _registrationPage(context);
        break;
      case 3:
        return _namePage(context);
        break;
      case 4:
        return _contactPage(context);
        break;
      case 5:
        return _passwordPage(context);
        break;
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: 1.5 * SizeConfig.heightMultiplier,
          left: 2.5 * SizeConfig.widthMultiplier,
          right: 2.5 * SizeConfig.widthMultiplier),
      child: Row(
          mainAxisAlignment: _pageCounter == 1
              ? MainAxisAlignment.end
              : MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_pageCounter > 1)
              FlatButton(
                  onPressed: () {
                    setState(() {
                      _pageCounter--;
                    });
                  },
                  child: Text(
                    '< Back',
                    style: TextStyle(
                        fontSize: 3.37 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w400),
                  )),
            if (_pageCounter < 5)
              FlatButton(
                  onPressed: () {
                    if (_pageCounter == 1) {
                      _passengerForm.session =
                          Provider.of<SessionProvider>(context).currentSession;
                      setState(() {
                        _pageCounter++;
                      });
                    } else {
                      if (_passengerSignupKey.currentState.validate()) {
                        _saveForm();
                        setState(() {
                          _pageCounter++;
                        });
                      }
                    }
                  },
                  child: Text(
                    'Next >',
                    style: TextStyle(
                        fontSize: 3.37 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w400),
                  ))
          ]),
    );
  }

  Widget _inputContainer({TextFormField input}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 3.56 * SizeConfig.widthMultiplier,
          vertical: 0.93 * SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.3125 * SizeConfig.imageSizeMultiplier,
            color: Colors.black12),
        borderRadius:
            BorderRadius.circular(2.5 * SizeConfig.imageSizeMultiplier),
      ),
      child: input,
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Exit registration form?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 3.75 * SizeConfig.heightMultiplier,
              horizontal: 3.125 * SizeConfig.widthMultiplier),
          child: Form(
            key: _passengerSignupKey,
            child: _buildPages(context),
          ),
        )),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
}

String _extractGenderValue(String value) {
  List<String> _dotSeparated = value.split('.');
  return _dotSeparated[1];
}
