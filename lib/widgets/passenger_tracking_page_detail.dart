import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

class PassengerTrackingPageDetail extends StatefulWidget {
  @override
  _PassengerTrackingPageDetailState createState() =>
      _PassengerTrackingPageDetailState();
}

class _PassengerTrackingPageDetailState
    extends State<PassengerTrackingPageDetail> {
  bool _isExpanded = false;
  Trip currentTrip;
  Widget _buildTopBarLead(BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 8.33 * SizeConfig.widthMultiplier,
      child: Center(
        heightFactor: 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.22 * SizeConfig.widthMultiplier,
            vertical: 1.25 * SizeConfig.heightMultiplier,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius:
                BorderRadius.circular(8.33 * SizeConfig.imageSizeMultiplier),
          ),
          width: 36.11 * SizeConfig.widthMultiplier,
          alignment: Alignment.center,
          child: Text(
            currentTrip.route.name,
            style:
                Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildBusDetail(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 1.56 * SizeConfig.heightMultiplier),
      child: Row(
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
                width: 43.1 * SizeConfig.widthMultiplier,
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
      ),
    );
  }

  Widget _buildTopBarBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.3 * SizeConfig.imageSizeMultiplier,
        // vertical: 6.3 * SizeConfig.imageSizeMultiplier,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 4.68 * SizeConfig.heightMultiplier),
            width: 74.88 * SizeConfig.widthMultiplier,
            child: Text(
              currentTrip.passengerStop.name,
              style: TextStyle(
                fontSize: 5.44 * SizeConfig.widthMultiplier,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildBusDetail(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    // DateFormat.jm().format(currentTrip.passengerStop.estToReachBus),
                    '07 mins',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                  Text('are left'),
                ],
              ),
            ],
          ),
          // ---------------------------------------------------------------------------
          // Here goes the estimated time defined by the institute to reach current stop
          Text('Estimated Time: ' +
              DateFormat.jm().format(currentTrip.passengerStop.timeToReach)),
          // ---------------------------------------------------------------------------
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
        color: Theme.of(context).accentColor.withOpacity(0.0),
        child: Stack(
          children: <Widget>[
            _buildTopBarBody(context),
            _buildTopBarLead(context),
          ],
        ),
      ),
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

  Widget _buildExpandedDetail(BuildContext context) {
    return Container(
        height: 34.37 * SizeConfig.heightMultiplier,
        padding: EdgeInsets.symmetric(
          horizontal: 8.3 * SizeConfig.widthMultiplier,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 1.78 * SizeConfig.heightMultiplier,
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
                  children: getDriversList(context, currentTrip.drivers),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final joinedTrip = Provider.of<TripProvider>(context).passengerSelectedTrip;
    setState(() {
      this.currentTrip = joinedTrip;
    });
    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      top: _isExpanded
          ? 55.8 * SizeConfig.heightMultiplier
          : 74.8 * SizeConfig.heightMultiplier,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
            topRight: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
          ),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTopBar(context),
            SizedBox(
              height: 0.93 * SizeConfig.heightMultiplier,
            ),
            Divider(),
            SizedBox(
              height: 0.93 * SizeConfig.heightMultiplier,
            ),
            if (_isExpanded) _buildExpandedDetail(context),
          ],
        ),
      ),
    );
  }
}
