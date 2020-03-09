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
  r.Route selectedRoute;
  TripMode selectedMode = TripMode.PICK_UP;
  Bus selectedBus;
  Driver partnerDriver;
  bool takingParnterDriver = false;

  var _tripConfig = TripConfig(
      route: null,
      currentDriver: null,
      partnerDriver: null,
      bus: null,
      meter: null,
      mapTraceKey: null,
      mode: null,
      startTime: null);

  final _driverConfigKey = GlobalKey<FormState>();
  final _driverFocusNode = FocusNode();

  void initState() {
    super.initState();
    selectedRoute =
        Provider.of<RouteProvider>(context, listen: false).dummy_routes[0];
  }

  void _saveForm() {
    _driverConfigKey.currentState.save();
    _tripConfig.mode = selectedMode;
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
        print(config.configName + ' ' + config.bus.id.toString() + ' ' + config.mode.toString());
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
      builder: (context, configConsumer, child) => Container(
        height: 13.28 * SizeConfig.heightMultiplier,
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
                itemCount: configConsumer.dummyTripConfigs.length,
                itemBuilder: (context, index) {
                  TripConfig config = configConsumer.dummyTripConfigs[index];
                  return _buildAutoConfigCard(context, config);
                },
              ),
            ),
          ],
        ),
      ),
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
            value: selectedRoute.name,
            items:
                availableRoutes.map<DropdownMenuItem<String>>((r.Route route) {
              return DropdownMenuItem<String>(
                value: route.name,
                child: Text(route.name),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                selectedRoute = availableRoutes.firstWhere((r.Route route) {
                  return route.name == newValue;
                });
              });
              print(selectedRoute.name);
            },
            onSaved: (_) {
              _tripConfig.route = selectedRoute;
            }));
  }

  Widget _toggleMode(BuildContext context) => Container(
      alignment: selectedMode == TripMode.PICK_UP
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
          if (selectedMode == TripMode.PICK_UP)
            selectedMode = TripMode.DROP_OFF;
          else
            selectedMode = TripMode.PICK_UP;
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
                  style: selectedMode == TripMode.PICK_UP
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
                  style: selectedMode == TripMode.DROP_OFF
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

  Widget _partnerDriverDetail(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Checkbox(
                  value: takingParnterDriver,
                  onChanged: (val) {
                    setState(() {
                      takingParnterDriver = !takingParnterDriver;
                    });
                  },
                ),
                Text(
                  'Partner Driver?',
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
          ],
        ),
        if (takingParnterDriver == true)
          Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Parner ID',
                    border: InputBorder.none,
                  ),
                  focusNode: _driverFocusNode,
                  onFieldSubmitted: (value) {
                    setState(() {
                      partnerDriver = driverProvider.dummy_available_drivers
                          .firstWhere((Driver driver) {
                        return driver.registrationID == value;
                      });
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      partnerDriver = driverProvider.dummy_available_drivers
                          .firstWhere((Driver driver) {
                        return driver.registrationID == value;
                      });
                    });
                    _tripConfig.partnerDriver = partnerDriver;
                  },
                ),
              ),
            ],
          ),
        if (takingParnterDriver == true && partnerDriver != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black54),
                borderRadius: BorderRadius.circular(8.0)),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Text(
              partnerDriver.firstName + ' ' + partnerDriver.lastName,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
      ],
    );
  }

  Widget _busDetail(BuildContext context) {
    final busProvider = Provider.of<BusProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 120,
          child: TextFormField(
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Bus Plate',
            ),
            textInputAction: takingParnterDriver
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (value) {
              setState(() {
                selectedBus =
                    busProvider.dummy_avalialbeBuses.firstWhere((Bus bus) {
                  return bus.plateNumber == value;
                });
              });
              FocusScope.of(context).requestFocus(_driverFocusNode);
            },
            onSaved: (value) {
              setState(() {
                selectedBus =
                    busProvider.dummy_avalialbeBuses.firstWhere((Bus bus) {
                  return bus.plateNumber == value;
                });
              });
              _tripConfig.bus = selectedBus;
            },
          ),
        ),
        if (selectedBus != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black54),
                borderRadius: BorderRadius.circular(8.0)),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Text(
              selectedBus.name,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
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
    String _autofillName;
    final configNameController = TextEditingController();
    showDialog(
        context: context,
        child: AlertDialog(
          content: TextField(
              controller: configNameController,
              decoration: InputDecoration(labelText: 'Auto-Fill Name'),
              onSubmitted: (value) {
                setState(() {
                  _autofillName = value;
                });
                _tripConfig.configName = _autofillName;
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
                    Divider(),
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
