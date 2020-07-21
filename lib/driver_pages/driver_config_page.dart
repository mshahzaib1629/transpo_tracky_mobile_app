import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_navigation_page.dart';
import 'package:transpo_tracky_mobile_app/helpers/constants.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import '../providers/route_model.dart' as r;

import '../helpers/size_config.dart';

class DriverConfigurationPage extends StatefulWidget {
  bool isExpanded;
  Function checkIfOnTrip;
  DriverConfigurationPage({this.isExpanded, this.checkIfOnTrip});

  createState() => _DriverConfigurationPageState();
}

class _DriverConfigurationPageState extends State<DriverConfigurationPage> {
  bool takingParnterDriver = false;

  List<r.Route> availableRoutes = [];

  var _tripConfig = TripConfig(
      route: null,
      currentDriver: null,
      partnerDriver: null,
      bus: null,
      meter: null,
      mapTraceKey: null,
      mode: TripMode.PICK_UP,
      startTime: null);

  final _driverConfigFormKey = GlobalKey<FormState>();
  final _driverFocusNode = FocusNode();

  final busPlateController = TextEditingController();
  final partnerIdController = TextEditingController();

  bool _isInit = true;
  bool _isLoading = false;
  bool _errorEncountered = false;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<RouteProvider>(context, listen: false)
          .fetchRoutes()
          .then((_) {
        setState(() {
          availableRoutes =
              Provider.of<RouteProvider>(context, listen: false).routes;
        });

        _tripConfig.route = availableRoutes[0];
        setState(() {
          _errorEncountered = false;
          _isLoading = false;
          _isInit = false;
        });
      }).catchError((error) {
        setState(() {
          _errorEncountered = true;
          _isLoading = false;
          _isInit = false;
        });
      });
      Provider.of<BusProvider>(context, listen: false)
          .fetchBuses()
          .catchError((error) {
        setState(() {
          _errorEncountered = true;
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    _driverConfigFormKey.currentState.save();
    // -----------------------------------------
    // adding dummy driver here for now. Later we take current logged in driver into _tripConfig.currentDriver
    _tripConfig.currentDriver = Constants.dummyDriver;
    // -----------------------------------------
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
        widget.checkIfOnTrip();
        setState(() {
          widget.isExpanded = !widget.isExpanded;
          if (widget.isExpanded) {
            _isInit = true;
            didChangeDependencies();
          }
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

  r.Route getRoute(int id) {
    return availableRoutes.firstWhere((route) {
      return route.id == id;
    }, orElse: () {
      return null;
    });
  }

  Widget _buildAutoConfigCard(BuildContext context, TripConfig config) {
    return GestureDetector(
      onTap: () {
        final route = getRoute(config.route.id);
        final bus = Provider.of<BusProvider>(context, listen: false)
            .getBus(config.bus.id);
        final partnerDriver = config.partnerDriver != null
            ? Provider.of<DriverProvider>(context, listen: false)
                .getDriver(config.partnerDriver.id)
            : null;
        if (route == null) {
          showConfigError(context, config: config, route: route);
        } else {
          TripConfig _autoConfig = TripConfig(
            route: route,
            partnerDriver: partnerDriver,
            bus: bus,
            mode: config.mode,
          );
          _tripConfig.route = _autoConfig.route;
          _tripConfig.mode = _autoConfig.mode;
          _tripConfig.bus = _autoConfig.bus;

          _tripConfig.partnerDriver = _autoConfig.partnerDriver;
          if (_autoConfig.bus != null)
            busPlateController.text = _autoConfig.bus.plateNumber;
          else
            busPlateController.text = '';
          if (_autoConfig.partnerDriver != null) {
            _toggleTakingPartnerDriver(true);
            partnerIdController.text = _autoConfig.partnerDriver.registrationID;
          } else {
            _toggleTakingPartnerDriver(false);
          }
        }
      },
      onLongPress: () {
        showDialog(
            context: context,
            child: AlertDialog(
              content: Text('Delete auto-fill \'${config.configName}\'?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                FlatButton(
                  onPressed: () {
                    Provider.of<TripConfigProvider>(context, listen: false)
                        .deleteConfig(config.id);
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                ),
              ],
            ));
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
    return FutureBuilder(
        // here currently we are passing dummy id of Current Logged IN Driver
        // later, it should be passed of current logged in user
        // =====================================================================
        future: Provider.of<TripConfigProvider>(context, listen: false)
            .fetchAndSetConfigs(currentDriverId: Constants.dummyDriver.id),
        // =====================================================================
        builder: (context, snapshot) => Consumer<TripConfigProvider>(
              builder: (context, configConsumer, child) {
                return configConsumer.savedTripConfigs.length != 0
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0.94 * SizeConfig.heightMultiplier,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 0.8 * SizeConfig.widthMultiplier,
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
                                  // padding: EdgeInsets.only(bottom: 5),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        configConsumer.savedTripConfigs.length,
                                    itemBuilder: (context, index) {
                                      TripConfig config = configConsumer
                                          .savedTripConfigs[index];
                                      return _buildAutoConfigCard(
                                          context, config);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      )
                    : Container();
              },
            ));
  }

  Widget _routeDropdownButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.56 * SizeConfig.widthMultiplier,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.3125 * SizeConfig.imageSizeMultiplier,
            color: Colors.black12),
        borderRadius:
            BorderRadius.circular(2.5 * SizeConfig.imageSizeMultiplier),
      ),
      width: 55.125 * SizeConfig.widthMultiplier,
      child: DropdownButtonFormField<r.Route>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
        hint: Text('Select Route'),
        value: _tripConfig.route,
        items: availableRoutes.map<DropdownMenuItem<r.Route>>((r.Route route) {
          return DropdownMenuItem<r.Route>(
            value: route,
            child: Container(
                width: 30.125 * SizeConfig.widthMultiplier,
                child: Text(
                  route.name,
                  overflow: TextOverflow.ellipsis,
                )),
          );
        }).toList(),
        onChanged: (r.Route value) {
          setState(() {
            _tripConfig.route = value;
          });
          print(_tripConfig.route.name);
        },
        // onSaved: (r.Route value) {
        //   setState(() {
        //     _tripConfig.route = value;
        //   });
        // },
      ),
    );
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
        width: 3.125 * SizeConfig.widthMultiplier,
        height: 1.9 * SizeConfig.heightMultiplier,
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
              width: 3.125 * SizeConfig.widthMultiplier,
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
    } else {
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
          height: 1.9 * SizeConfig.heightMultiplier,
        ),
        if (takingParnterDriver == true)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.31 * SizeConfig.widthMultiplier,
                  color: Colors.black12),
              borderRadius:
                  BorderRadius.circular(2.5 * SizeConfig.imageSizeMultiplier),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 1.56 * SizeConfig.widthMultiplier,
              vertical: 0.94 * SizeConfig.heightMultiplier,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: partnerIdController,
                  textCapitalization: TextCapitalization.characters,
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
                      }, orElse: () {
                        return null;
                      });
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _tripConfig.partnerDriver = driverProvider
                          .dummy_available_drivers
                          .firstWhere((Driver driver) {
                        return driver.registrationID == value;
                      }, orElse: () {
                        return null;
                      });
                    });
                  },
                ),
                if (takingParnterDriver == true)
                  _tripConfig.partnerDriver != null
                      ? Text(
                          _tripConfig.partnerDriver.firstName +
                              ' ' +
                              _tripConfig.partnerDriver.lastName,
                          style: Theme.of(context).textTheme.body2,
                        )
                      : Text(
                          'No driver found',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: Colors.red),
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

  Widget _buildBusSubDetail() {
    Text message;
    if (_tripConfig.bus != null) {
      if (_tripConfig.bus.onTrip == 1)
        message = Text(
          'The bus is on another trip!',
          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.red),
        );
      else
        message = Text(
          _tripConfig.bus.name,
          style: Theme.of(context).textTheme.body2,
        );
    } else
      message = Text(
        'No bus found',
        style: Theme.of(context).textTheme.body2.copyWith(color: Colors.red),
      );
    return message;
  }

  Widget _busDetail(BuildContext context) {
    final busProvider = Provider.of<BusProvider>(context, listen: false);

    return Container(
      // width: 120,
      padding: EdgeInsets.symmetric(
        horizontal: 1.56 * SizeConfig.widthMultiplier,
        vertical: 0.94 * SizeConfig.heightMultiplier,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.31 * SizeConfig.widthMultiplier, color: Colors.black12),
        borderRadius:
            BorderRadius.circular(2.5 * SizeConfig.imageSizeMultiplier),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: busPlateController,
            textCapitalization: TextCapitalization.characters,
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
                    busProvider.avalialbeBuses.firstWhere((Bus bus) {
                  return bus.plateNumber == value;
                }, orElse: () {
                  return null;
                });
              });
              FocusScope.of(context).requestFocus(_driverFocusNode);
            },
            onSaved: (value) {
              setState(() {
                _tripConfig.bus =
                    busProvider.avalialbeBuses.firstWhere((Bus bus) {
                  return bus.plateNumber == value;
                }, orElse: () {
                  return null;
                });
              });
            },
          ),
          _buildBusSubDetail(),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      autovalidate: true,
      key: _driverConfigFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 0.94 * SizeConfig.heightMultiplier,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _routeDropdownButton(context),
              _selectMode(context),
            ],
          ),
          SizedBox(
            height: 1.9 * SizeConfig.heightMultiplier,
          ),
          _busDetail(context),
          _partnerDriverDetail(context)
        ],
      ),
    );
  }

  void _showGoDialog(BuildContext context) {
    final meterReadingController = TextEditingController();
    showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 14.47 * SizeConfig.heightMultiplier,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: meterReadingController,
                  keyboardType: TextInputType.number,
                  autovalidate: true,
                  validator: (value) {
                    if (value.isEmpty) return 'Reading must not be empty';
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Initial Meter Reading',
                      contentPadding: EdgeInsets.all(0)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveForm();
                  setState(() {
                    _isLoading = true;
                  });
                  _tripConfig.meter = BusMeterReading(
                      initialReading:
                          double.parse(meterReadingController.text));
                  Provider.of<TripProvider>(context, listen: false)
                      .startTrip(config: _tripConfig)
                      .then((_) {
                    setState(() {
                      widget.isExpanded = false;
                      _isLoading = false;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverNavigationPage()));
                  }).catchError((error) {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Oh no!'),
                          content: Text('Something went wrong.'),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Okay'))
                          ],
                        ));
                    setState(() {
                      _isLoading = false;
                    });
                  });
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
    if (_tripConfig.bus != null &&
        (takingParnterDriver == false ||
            (takingParnterDriver == true && _tripConfig.partnerDriver != null)))
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
                  busPlateController.text = '';
                  takingParnterDriver = false;
                  partnerIdController.text = '';
                  widget.isExpanded = false;
                  _tripConfig.bus = null;
                  _tripConfig.partnerDriver = null;
                  _tripConfig.mode = TripMode.PICK_UP;
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
              _saveForm();
              if (_tripConfig.bus != null &&
                  _tripConfig.bus.onTrip == 0 &&
                  (takingParnterDriver == false ||
                      (takingParnterDriver == true &&
                          _tripConfig.partnerDriver != null)))
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

  Widget _showErrorMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Something went wrong!',
            style: TextStyle(fontSize: 2.63 * SizeConfig.textMultiplier),
          ),
          FlatButton(
              onPressed: () {
                setState(() {
                  _isInit = true;
                });
                didChangeDependencies();
              },
              child: Text(
                'TRY AGAIN',
                style: TextStyle(color: Theme.of(context).accentColor),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      top: widget.isExpanded
          ? 3.125 * SizeConfig.heightMultiplier
          : 77.5 * SizeConfig.heightMultiplier,
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height -
        //     (14.06 * SizeConfig.heightMultiplier),
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
        child: Column(
          children: <Widget>[
            _buildTopBar(context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.6 * SizeConfig.widthMultiplier),
              child: Container(
                height: 75 * SizeConfig.heightMultiplier,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : (_errorEncountered
                        ? _showErrorMessage(context)
                        : Column(
                            children: <Widget>[
                              _buildAutoConfigs(context),
                              Expanded(child: _buildForm(context)),
                              _buildBottomBar(context),
                            ],
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showConfigError(context, {TripConfig config, r.Route route}) {
  print('route not found');
  showDialog(
    context: context,
    child: AlertDialog(
      title: Text('Delete \'${config.configName}\'?'),
      content: Text('Targeted Route is no more in the system.'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No Thanks'),
        ),
        FlatButton(
          onPressed: () {
            Provider.of<TripConfigProvider>(context, listen: false)
                .deleteConfig(config.id);
            Navigator.pop(context);
          },
          child: Text('Yes Sure'),
        ),
      ],
    ),
  );
}
