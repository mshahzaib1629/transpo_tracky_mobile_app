import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/trip_record_card.dart';

import '../helpers/size_config.dart';

class LastTripsDetailPage extends StatelessWidget {
  // In this page, we check either driver is logged in to the app or passenger, bases on that we share the details accordingly
  final LoginMode loginMode = LoginMode.Driver;
  final Trip trip;

  LastTripsDetailPage({@required this.trip});

  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 32.8125 * SizeConfig.heightMultiplier,
    );
  }

  Widget horizontalLine(BuildContext context) => Container(
        // margin: EdgeInsets.only(left: 17.32 * SizeConfig.widthMultiplier),
        width: 40.87 * SizeConfig.widthMultiplier,
        height: 0.56 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius:
                BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier)),
      );

  int _passengerStrength() {
    int difference = trip.bus.capacity - trip.passengersOnBoard;
    return difference;
  }

  Widget _busAdditionalDetail(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 1.25 * SizeConfig.heightMultiplier,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 5.56 * SizeConfig.widthMultiplier,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(trip.startTime),
                    Text(trip.meter.initialReading.toStringAsFixed(1) + ' km'),
                  ],
                ),
                horizontalLine(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(trip.endTime),
                    Text(trip.meter.finalReading.toStringAsFixed(1) + ' km'),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 1.25 * SizeConfig.heightMultiplier,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.supervised_user_circle,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 5.56 * SizeConfig.widthMultiplier,
            ),
            Text(
              '${trip.passengersOnBoard}/${trip.bus.capacity}',
              style: Theme.of(context).textTheme.body2.copyWith(
                  color: _passengerStrength() < 2
                      ? Colors.red
                      : Theme.of(context).accentColor),
            ),
            Text(' Passengers were on Board'),
          ],
        ),
      ],
    );
  }

  Widget _buildBusDetail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (loginMode == LoginMode.Driver)
          Text('Bus Detail',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Theme.of(context).accentColor)),
        SizedBox(
          height: 0.78 * SizeConfig.heightMultiplier,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions_bus,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 5.56 * SizeConfig.widthMultiplier,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  trip.bus.plateNumber,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: Theme.of(context).accentColor),
                ),
                Container(
                  width: 61.1 * SizeConfig.widthMultiplier,
                  child: Text(
                    trip.bus.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
              ],
            )
          ],
        ),
        if (loginMode == LoginMode.Driver) _busAdditionalDetail(context),
      ],
    );
  }

  List<Widget> getDriversList(context, List drivers) {
    List<Widget> childs = [];
    for (var i = 0; i < drivers.length; i++) {
      Driver currentDriver = drivers[i];
      childs.add(Padding(
        padding: EdgeInsets.only(bottom: 1.25 * SizeConfig.heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              currentDriver.registrationID,
              style: Theme.of(context).textTheme.body2.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
            Text(
              currentDriver.firstName + ' ' + currentDriver.lastName,
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      ));
    }
    return childs;
  }

  List<Widget> getStopList(context, List stops) {
    List<Widget> childs = [];
    for (var i = 0; i < stops.length; i++) {
      Stop currentStop = stops[i];
      childs.add(Container(
          margin: EdgeInsets.only(bottom: 1.28 * SizeConfig.heightMultiplier),
          padding: EdgeInsets.symmetric(
            vertical: 0.56 * SizeConfig.heightMultiplier,
            // horizontal: 2.78 * SizeConfig.widthMultiplier,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.black12.withOpacity(0.12)),
            borderRadius:
                BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    currentStop.name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(currentStop.timeReached),
                      Text(
                        'Reached',
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontSize: 1.56 * SizeConfig.textMultiplier),
                      ),
                    ],
                  )
                ],
              ),
              Divider(),
            ],
          )));
    }
    return childs;
  }

  Widget _buildDriversDetail(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (loginMode == LoginMode.Driver)
          Text('Drivers on Board',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Theme.of(context).accentColor)),
        SizedBox(
          height: 0.78 * SizeConfig.heightMultiplier,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.person_pin,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 5.56 * SizeConfig.widthMultiplier,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getDriversList(context, trip.drivers),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDetail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Route Detail',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: Theme.of(context).accentColor)),
          ],
        ),
        SizedBox(
          height: 0.78 * SizeConfig.heightMultiplier,
        ),
        Column(
          children: getStopList(context, trip.route.stopList),
        )
      ],
    );
  }

  Widget _buildDetailCard(context) {
    return Container(
        // height: 420.0,
        margin:
            EdgeInsets.symmetric(vertical: 1.28 * SizeConfig.heightMultiplier),
        padding: EdgeInsets.symmetric(
          vertical: 1.56 * SizeConfig.heightMultiplier,
          horizontal: 2.78 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(color: Colors.black12),
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
        ),
        child: Column(
          children: <Widget>[
            _buildBusDetail(context),
            Divider(),
            SizedBox(
              height: 0.78 * SizeConfig.heightMultiplier,
            ),
            _buildDriversDetail(context),
            if (loginMode == LoginMode.Driver) Divider(),
            SizedBox(
              height: 0.78 * SizeConfig.heightMultiplier,
            ),
            if (loginMode == LoginMode.Driver) _buildRouteDetail(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Report Problem',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.white),
                  ),
                  color: Color(0xFFc20c12),
                )
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Trip Detail'),
      ),
      body: ListView(
        children: <Widget>[
          _buildMap(context),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 2.2 * SizeConfig.widthMultiplier,
              // vertical: 0.25 * SizeConfig.heightMultiplier,
            ),
            child: Column(
              children: <Widget>[
                TripRecordCard(
                  trip: trip,
                ),
                _buildDetailCard(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}
