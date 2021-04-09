import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_broadcast_screen.dart';
import 'package:transpo_tracky_mobile_app/google_maps/driver_navigation_map.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/driver_navigation_page_detail.dart';

import '../helpers/size_config.dart';

class DriverNavigationPage extends StatefulWidget {
  @override
  _DriverNavigationPageState createState() => _DriverNavigationPageState();
}

class _DriverNavigationPageState extends State<DriverNavigationPage> {
  Widget _buildFloatingButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.44 * SizeConfig.widthMultiplier,
        vertical: 2.44 * SizeConfig.heightMultiplier,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back,
                size: 8.26 * SizeConfig.imageSizeMultiplier),
            onPressed: () {
              _showEndTripDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.chat, size: 8.26 * SizeConfig.imageSizeMultiplier),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverBroadCastScreen(),
                  ));
            },
          )
        ],
      ),
    );
  }

  Future<bool> _showEndTripDialog() {
    final meterReadingController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                          labelText: 'Final Meter Reading',
                          contentPadding: EdgeInsets.all(0)),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      var meterReading = BusMeterReading(
                          finalReading:
                              double.parse(meterReadingController.text));
                      Provider.of<TripProvider>(context, listen: false)
                          .driverEndTrip(meterReading)
                          .then((_) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }).catchError((error) {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Oh no!'),
                                  content: Text('Something went wrong.'),
                                  actions: [
                                    FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Okay'))
                                  ],
                                ));
                      });
                    },
                    child: Text('End Now'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _showEndTripDialog,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              DriverNavigationMap(_showEndTripDialog),
              DriverNavigationPageDetail(),
              _buildFloatingButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
