import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import '../size_config.dart';

class PassengerTrackingPageDetail extends StatefulWidget {
  final Trip trip;

  PassengerTrackingPageDetail({@required this.trip});
  @override
  _PassengerTrackingPageDetailState createState() => _PassengerTrackingPageDetailState();
}

class _PassengerTrackingPageDetailState extends State<PassengerTrackingPageDetail> {
  bool _isExpanded = false;

  Widget _buildTopBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 36.11 * SizeConfig.widthMultiplier,
                child: Text(
                  widget.trip.route.name,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: Theme.of(context).accentColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                Container(
                alignment: Alignment.topRight,
                width: 38.88 * SizeConfig.widthMultiplier,
                child: Text(
                  widget.trip.passengerStop.name,
                  style: TextStyle(
                    fontSize: 4.44 * SizeConfig.widthMultiplier,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ],)
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
            ),
            title: Text(widget.trip.bus.plateNumber),
            subtitle: Text(widget.trip.bus.name),
          ),
          Text('Estimated Time: ' + widget.trip.passengerStop.timeToReach),
        ],
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
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Drivers on Board',
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: Theme.of(context).accentColor)),
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
              children: getDriversList(context, widget.trip.drivers),
            ),
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _isExpanded
          ? 50.8 * SizeConfig.heightMultiplier
          : 72.8 * SizeConfig.heightMultiplier,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 8.3 * SizeConfig.imageSizeMultiplier,
            vertical: 8.3 * SizeConfig.imageSizeMultiplier),
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
