import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import '../helpers/size_config.dart';

class DriverNavigationPageDetail extends StatefulWidget {
  
  @override
  _DriverNavigationPageDetailState createState() =>
      _DriverNavigationPageDetailState();
}

class _DriverNavigationPageDetailState
    extends State<DriverNavigationPageDetail> {

  Trip currentTrip;
  bool _isExpanded = false;


  Widget _buildBusDetail(BuildContext context) {
    return Row(
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
              currentTrip.bus.plateNumber,
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            Container(
              width: 61.1 * SizeConfig.widthMultiplier,
              child: Text(
                currentTrip.bus.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          ],
        )
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

  Widget _buildDriversDetail(BuildContext context) {
    return Row(
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
          children: getDriversList(context, currentTrip.drivers),
        ),
      ],
    );
  }

  List<Widget> getStopList(context, List stops) {
    List<Widget> childs = [];
    for (var i = 0; i < stops.length; i++) {
      Stop currentStop = stops[i];
      childs.add(Container(
          margin: EdgeInsets.only(bottom: 1.28 * SizeConfig.heightMultiplier),
          padding: EdgeInsets.symmetric(
            vertical: 0.56 * SizeConfig.heightMultiplier,
          ),
          decoration: BoxDecoration(
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
                      Text(currentStop.timeReached != null ? currentStop.timeReached : DateFormat.jm().format(currentStop.timeToReach)),
                      Text(
                        currentStop.timeReached != null ? 'Reached' : 'est. Time',
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

  Widget _buildRouteDetail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('On the way . . .',
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
          children: getStopList(context, currentTrip.route.stopList),
        )
      ],
    );
  }

  Widget _buildTopBarLead(BuildContext context) {
    return Center(
      heightFactor: 0,
      child: Container(
        width: 50 * SizeConfig.widthMultiplier,
        height: 7.81 * SizeConfig.heightMultiplier,
        padding: EdgeInsets.symmetric(
          vertical: 1.25 * SizeConfig.heightMultiplier,
          horizontal: 1.38 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius:
              BorderRadius.circular(8.33 * SizeConfig.imageSizeMultiplier),
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 38.8 * SizeConfig.widthMultiplier,
              child: Text(
                // -------------------------------------
                // here should come the next stop's name
                currentTrip.driverNextStop.name,
                // --------------------------------------
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.5 * SizeConfig.textMultiplier),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 0.15 * SizeConfig.heightMultiplier,
            ),
            Container(
              alignment: Alignment.center,
              width: 30.56 * SizeConfig.widthMultiplier,
              child: Text(
                currentTrip.route.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 1.73 * SizeConfig.textMultiplier,
                  letterSpacing: 0.167 * SizeConfig.widthMultiplier,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 6.25 * SizeConfig.heightMultiplier,
          bottom: 4.84 * SizeConfig.heightMultiplier),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    // --------------------------------------------------------
                    // here should come the next stop's estimated time to reach
                    DateFormat.jm().format(currentTrip.route.stopList[0].timeToReach),
                    // --------------------------------------------------------
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text('Estimated Time')
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    // --------------------------------------------------------------------
                    // here should come the google's calculated time to reach the next stop
                    '05 mins',
                    // --------------------------------------------------------------------
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text('are left')
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 5.56 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
            topRight: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
          ),
        ),
        child: Stack(
          children: <Widget>[
            _buildTopBarBody(context),
            _buildTopBarLead(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedDetail(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 5.56 * SizeConfig.widthMultiplier),
      child: Container(
        height: 57.8 * SizeConfig.heightMultiplier,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 1.8 * SizeConfig.heightMultiplier,
              ),
              _buildBusDetail(context),
              SizedBox(
                height: 1.8 * SizeConfig.heightMultiplier,
              ),
              _buildDriversDetail(context),
              SizedBox(
                height: 2.8 * SizeConfig.heightMultiplier,
              ),
              _buildRouteDetail(context)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final selectedTrip = Provider.of<TripProvider>(context).driverCreatedTrip;
    setState(() {
      this.currentTrip = selectedTrip;
    });

    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      top: _isExpanded
          ? 20.8 * SizeConfig.heightMultiplier
          : 78.8 * SizeConfig.heightMultiplier,
      child: Container(
        // height: 650.0,
        width: MediaQuery.of(context).size.width,
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
            Divider(),
            if (_isExpanded) _buildExpandedDetail(context),
          ],
        ),
      ),
    );
  }
}
