import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_navigation_page.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/custom_text_form_field.dart';
import '../providers/route_model.dart' as r;

import '../size_config.dart';

class DriverConfigurationPage extends StatefulWidget {
  bool isExpanded;
  DriverConfigurationPage({this.isExpanded});

  createState() => _DriverConfigurationPageState();
}

class _DriverConfigurationPageState extends State<DriverConfigurationPage> {
  // r.Route selectedRoute;
  // TripMode selectedMode = TripMode.PICK_UP;
  // Bus selectedBus;
  // Driver partnerDriver;
  bool takingParnterDriver = false;

  var _tripConfig = TripConfig(
      route: null,
      currentDriver: null,
      partnerDriver: null,
      bus: null,
      meter: null,
      mapTraceKey: null,
      mode: TripMode.PICK_UP,
      startTime: null);

// this object is used to initialize the values from autoconfigs (which are created by the users)
  var _autoConfig = TripConfig(
    route: null,
    currentDriver: null,
    partnerDriver: null,
    bus: null,
    mode: null,
  );

  final _driverConfigKey = GlobalKey<FormState>();
  final _driverFocusNode = FocusNode();

  final busPlateController = TextEditingController();
  final partnerIdController = TextEditingController();

  void initState() {
    super.initState();
    _tripConfig.route =
        Provider.of<RouteProvider>(context, listen: false).dummy_routes[0];
  }

  void _saveForm() {
    _driverConfigKey.currentState.save();
  }

  Widget _horizontalLLine(BuildContext context) => Container(
        margin:
            EdgeInsets.symmetric(vertical: 2.82 * SizeConfig.widthMultiplier),
        width: 16.87 * SizeConfig.widthMultiplier,
        height: 0.56 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  Widget _buildTopBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isExpanded = !widget.isExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        color: Colors.grey.withOpacity(0.0),
        child: Column(
          children: <Widget>[
            _horizontalLLine(context),
            SizedBox(
              height: 0.78 * SizeConfig.heightMultiplier,
            ),
            Text(
              'CONFIGURATION',
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(letterSpacing: 0.15 * SizeConfig.textMultiplier),
            ),
            SizedBox(
              height: 0.78 * SizeConfig.heightMultiplier,
            ),
            Divider(
              thickness: 0.15 * SizeConfig.heightMultiplier,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAutoConfigCard(BuildContext context, TripConfig config) {
    return GestureDetector(
      onTap: () {
        _autoConfig = config;
        _tripConfig.route = _autoConfig.route;
        _tripConfig.mode = _autoConfig.mode;
        // setting bus & partner driver as null here bcz they will be automatically re-assigned on submitting the form
        _tripConfig.bus = null;
        _tripConfig.partnerDriver  = null;
        busPlateController.text = _autoConfig.bus.plateNumber;
        if (_autoConfig.partnerDriver != null) {
          _toggleTakingPartnerDriver(true);
          partnerIdController.text = _autoConfig.partnerDriver.registrationID;
        } else {
          _toggleTakingPartnerDriver(false);
        }
      },
      child: Container(
        width: 22.2 * SizeConfig.widthMultiplier,
        margin: EdgeInsets.only(right: 2.02 * SizeConfig.widthMultiplier),
        padding: EdgeInsets.symmetric(
          horizontal: 2.38 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
        ),
        child: Center(
          child: Text(
            config.configName,
            style: Theme.of(context).textTheme.display2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildAutoConfigs(BuildContext context) {
    return Consumer<TripConfigProvider>(
      builder: (context, configConsumer, child) =>
          configConsumer.savedTripConfigs.length != 0
              ? Container(
                  height: 14.78 * SizeConfig.heightMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.8 * SizeConfig.widthMultiplier,
                          top: 1.25 * SizeConfig.heightMultiplier,
                          bottom: 0.625 * SizeConfig.heightMultiplier,
                        ),
                        child: Text(
                          'AUTO-FILLS',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                      SizedBox(
                        height: 0.78 * SizeConfig.heightMultiplier,
                      ),
                      Container(
                        height: 6.59 * SizeConfig.heightMultiplier,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: configConsumer.savedTripConfigs.length,
                          itemBuilder: (context, index) {
                            TripConfig config =
                                configConsumer.savedTripConfigs[index];
                            return _buildAutoConfigCard(context, config);
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                )
              : Container(),
    );
  }

  Widget _routeDropdownButton(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    List<r.Route> availableRoutes = routeProvider.dummy_routes;
    return Container(
        width: 180,
        child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            hint: Text('Select Route'),
            value: _tripConfig.route.name,
            items:
                availableRoutes.map<DropdownMenuItem<String>>((r.Route route) {
              return DropdownMenuItem<String>(
                value: route.name,
                child: Text(route.name),
              );
            }).toList(),
            onChanged: (String value) {
              setState(() {
                _tripConfig.route = availableRoutes.firstWhere((r.Route route) {
                  return route.name == value;
                });
              });
              print(_tripConfig.route.name);
            },
            onSaved: (value) {
              _tripConfig.route = availableRoutes.firstWhere((r.Route route) {
                return route.name == value;
              });
            }));
  }

  Widget _toggleMode(BuildContext context) => Container(
      alignment: _tripConfig.mode == TripMode.PICK_UP
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      width: 5.4 * SizeConfig.widthMultiplier,
      height: 6.6 * SizeConfig.heightMultiplier,
      padding: EdgeInsets.all(
        0.56 * SizeConfig.imageSizeMultiplier,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 0.56 * SizeConfig.widthMultiplier,
          color: Theme.of(context).accentColor,
        ),
      ),
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).accentColor),
      ));

  Widget _selectMode(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_tripConfig.mode == TripMode.PICK_UP)
            _tripConfig.mode = TripMode.DROP_OFF;
          else
            _tripConfig.mode = TripMode.PICK_UP;
        });
      },
      child: Container(
        // color: Colors.pink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  'PICK UP',
                  style: _tripConfig.mode == TripMode.PICK_UP
                      ? TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 2.81 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold)
                      : TextStyle(
                          color: Colors.black54,
                          fontSize: 2.51 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold),
                ),
                Text(
                  'DROP OFF',
                  style: _tripConfig.mode == TripMode.DROP_OFF
                      ? TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 2.81 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold)
                      : TextStyle(
                          color: Colors.black54,
                          fontSize: 2.51 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            _toggleMode(context),
          ],
        ),
      ),
    );
  }

  void _toggleTakingPartnerDriver(bool taking) {
    if (taking == true) {
      setState(() {
        takingParnterDriver = true;
      });
    }else {
      setState(() {
        takingParnterDriver = false;
        partnerIdController.text = '';
        _tripConfig.partnerDriver = null;
      });
    }
  }

  Widget _partnerDriverDetail(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        if (takingParnterDriver == true)
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
                borderRadius: BorderRadius.circular(8.0)),
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: partnerIdController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: 'Parner ID',
                    border: InputBorder.none,
                  ),
                  focusNode: _driverFocusNode,
                  onFieldSubmitted: (value) {
                    setState(() {
                      _tripConfig.partnerDriver = driverProvider
                          .dummy_available_drivers
                          .firstWhere((Driver driver) {
                        return driver.registrationID == value;
                      });
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _tripConfig.partnerDriver = driverProvider
                          .dummy_available_drivers
                          .firstWhere((Driver driver) {
                        return driver.registrationID == value;
                      });
                    });
                  },
                ),
                if (takingParnterDriver == true &&
                    _tripConfig.partnerDriver != null)
                  Text(
                    _tripConfig.partnerDriver.firstName +
                        ' ' +
                        _tripConfig.partnerDriver.lastName,
                    style: Theme.of(context).textTheme.body2,
                  ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Checkbox(
              value: takingParnterDriver,
              onChanged: (val) {
               _toggleTakingPartnerDriver(!takingParnterDriver);
              },
            ),
            Text(
              'Partner Driver?',
              style: Theme.of(context).textTheme.body2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _busDetail(BuildContext context) {
    final busProvider = Provider.of<BusProvider>(context, listen: false);

    return Container(
      // width: 120,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black12),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: busPlateController,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
              border: InputBorder.none,
              labelText: 'Bus Plate',
            ),
            textInputAction: takingParnterDriver
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (value) {
              setState(() {
                _tripConfig.bus =
                    busProvider.dummy_avalialbeBuses.firstWhere((Bus bus) {
                  return bus.plateNumber == value;
                });
              });
              FocusScope.of(context).requestFocus(_driverFocusNode);
            },
            onSaved: (value) {
              setState(() {
                _tripConfig.bus =
                    busProvider.dummy_avalialbeBuses.firstWhere((Bus bus) {
                  return bus.plateNumber == value;
                });
              });
            },
          ),
          if (_tripConfig.bus != null)
            Text(
              _tripConfig.bus.name,
              style: Theme.of(context).textTheme.body2,
            ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      autovalidate: true,
      key: _driverConfigKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _routeDropdownButton(context),
              _selectMode(context),
            ],
          ),
          _busDetail(context),
          _partnerDriverDetail(context)
        ],
      ),
    );
  }

  void _showGoDialog(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 10.47 * SizeConfig.heightMultiplier,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Initial Meter Reading'),
                TextFormField(
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  _saveForm();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverNavigationPage()));
                },
                child: Text('Lets Go'))
          ],
        ));
  }

  void _createAutoFill(BuildContext context) {
    _saveForm();
    final configProvider =
        Provider.of<TripConfigProvider>(context, listen: false);

    final configNameController = TextEditingController();
    showDialog(
        context: context,
        child: AlertDialog(
          content: TextField(
              controller: configNameController,
              decoration: InputDecoration(labelText: 'Auto-Fill Name'),
              onSubmitted: (value) {
                _tripConfig.configName = configNameController.text;
                configProvider.addTripConfig(_tripConfig);
                Navigator.pop(context);
              }),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('CREATE'),
              onPressed: () {
                _tripConfig.configName = configNameController.text;
                configProvider.addTripConfig(_tripConfig);
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 2.5 * SizeConfig.heightMultiplier),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                setState(() {
                  widget.isExpanded = false;
                });
              },
              child: Text('CANCEL', style: Theme.of(context).textTheme.body1)),
          FlatButton(
            onPressed: () {
              _createAutoFill(context);
            },
            child: Text('CREATE AUTO-FILL',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Theme.of(context).accentColor)),
          ),
          RaisedButton(
            onPressed: () {
              _showGoDialog(context);
            },
            child: Text('LETS GO!',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.isExpanded
          ? 3.125 * SizeConfig.heightMultiplier
          : 77.8 * SizeConfig.heightMultiplier,
      // top: 20.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (14.06 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
              blurRadius: 2.17 * SizeConfig.imageSizeMultiplier,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
              blurRadius: 2.17 * SizeConfig.imageSizeMultiplier,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
            topRight: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
          ),
        ),
        child: ListView(
          children: <Widget>[
            _buildTopBar(context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.6 * SizeConfig.widthMultiplier),
              child: Container(
                height: 75 * SizeConfig.heightMultiplier,
                child: ListView(
                  children: <Widget>[
                    _buildAutoConfigs(context),
                    _buildForm(context),
                    _buildBottomBar(context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
