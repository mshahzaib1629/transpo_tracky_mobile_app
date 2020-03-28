import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';


class TripRecordCard extends StatefulWidget {

  // In this card, we check either driver is logged in to the app or passenger, bases on that we share the details accordingly
  LoginMode loginMode = LoginMode.Driver;
  final Trip trip;

  TripRecordCard({
    @required this.trip,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TripRecordCardState();
  }
}

class _TripRecordCardState extends State<TripRecordCard> {
  Stop origin;
  Stop destination;

// here setting pick & drop points according to passenger/driver & PickUp/DropOff Mode
  void setPoints(TripMode mode) {
    if (widget.loginMode == LoginMode.Passenger) {
      if (mode == TripMode.PICK_UP) {
        setState(() {
          origin = widget.trip.passengerStop;
          destination =
              widget.trip.route.stopList[widget.trip.route.stopList.length - 1];
        });
      } else
        setState(() {
          origin = widget.trip.route.stopList[0];
          destination = widget.trip.passengerStop;
        });
    }
    else
    setState(() {
      origin = widget.trip.route.stopList[0];
      destination = widget.trip.route.stopList[widget.trip.route.stopList.length - 1];
    });
  }

  Widget circle(BuildContext context, {bool filled}) => Container(
        width: 4.0 * SizeConfig.widthMultiplier,
        height: 2.1 * SizeConfig.heightMultiplier,
        padding: EdgeInsets.all(
          0.56 * SizeConfig.imageSizeMultiplier,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.56 * SizeConfig.widthMultiplier,
            color: Theme.of(context).accentColor,
          ),
        ),
        child: filled
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor),
              )
            : Container(),
      );

  Widget verticalLLine(BuildContext context) => Container(
        margin: EdgeInsets.only(left: 16.45 * SizeConfig.widthMultiplier),
        width: 0.56 * SizeConfig.widthMultiplier,
        height: 1.87 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  @override
  Widget build(BuildContext context) {
    setPoints(widget.trip.mode);

    return Container(
      // height: 120.0,
      margin: EdgeInsets.only(top: 1.28 * SizeConfig.heightMultiplier),
      padding: EdgeInsets.symmetric(
        vertical: 1.56 * SizeConfig.heightMultiplier,
        horizontal: 2.78 * SizeConfig.widthMultiplier,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius:
            BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.trip.route.name,
                style: Theme.of(context).textTheme.body2,
              ),
              // date should be fetched from trip's startTime
              Text('17/02/2019'),
            ],
          ),
          SizedBox(height: 1.56 * SizeConfig.heightMultiplier),
          Row(
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.only(right: 2.2 * SizeConfig.widthMultiplier),
                  child: Text(origin.timeReached)),
              circle(context,
                  filled: widget.trip.mode == TripMode.PICK_UP ? false : true),
              Container(
                  padding:
                      EdgeInsets.only(left: 2.2 * SizeConfig.widthMultiplier),
                  child: Text(
                    origin.name,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 2.4 * SizeConfig.textMultiplier),
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
          verticalLLine(context),
          Row(
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.only(right: 2.2 * SizeConfig.widthMultiplier),
                  child: Text(destination.timeReached)),
              circle(context,
                  filled: widget.trip.mode == TripMode.PICK_UP ? true : false),
              Container(
                  padding:
                      EdgeInsets.only(left: 2.2 * SizeConfig.widthMultiplier),
                  child: Text(
                    destination.name,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 2.4 * SizeConfig.textMultiplier),
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
