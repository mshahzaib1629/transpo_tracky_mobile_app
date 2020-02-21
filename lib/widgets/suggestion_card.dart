import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/providers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import '../size_config.dart';

class SuggestionCard extends StatefulWidget {
  final Trip prefTrip;
  final Stop prefStop;
  // time required by the bus to reach the stop. If driver hasn't shared live location yet, pass estimated time to reach that stop
  final String approxTime;
  // Walking distance time from passenger's current postion to the stop
  final String walkingTime;

  SuggestionCard({
    @required this.prefTrip,
    @required this.prefStop,
    this.approxTime,
    @required this.walkingTime,
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SuggestionCardState();
  }
}

class _SuggestionCardState extends State<SuggestionCard> {
  bool _expanded = false;

  int _passengerStrength() {
    int difference =
        widget.prefTrip.bus.capacity - widget.prefTrip.passengersOnBoard;
    return difference;
  }

  Widget _liveStatus(BuildContext context, {bool live}) => Container(
        width: 4.0 * SizeConfig.widthMultiplier,
        height: 2.1 * SizeConfig.heightMultiplier,
        padding: EdgeInsets.all(
          0.3 * SizeConfig.imageSizeMultiplier,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.26 * SizeConfig.widthMultiplier,
            color: Theme.of(context).accentColor,
          ),
        ),
        child: live
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor),
              )
            : Container(),
      );

  Widget _buildHead(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('do something!');
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 61.1 * SizeConfig.widthMultiplier,
                child: Text(
                  widget.prefTrip.route.name,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(fontSize: 2.8 * SizeConfig.textMultiplier),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    widget.approxTime != null
                        ? widget.approxTime
                        : widget.prefTrip.route.stopList
                            .where((stop) => stop.id == widget.prefStop.id)
                            .elementAt(0)
                            .timeToReach,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    widget.approxTime != null ? '' : 'Est. Time',
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                right: 5.56 * SizeConfig.widthMultiplier,
                top: 0.93 * SizeConfig.heightMultiplier),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 61.1 * SizeConfig.widthMultiplier,
                  child: Text(
                    widget.prefStop.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.display3,
                  ),
                ),
                _liveStatus(context, live: widget.prefTrip.shareLiveLocation),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 3.05 * SizeConfig.widthMultiplier),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.directions_walk,
                  size: 5.56 * SizeConfig.imageSizeMultiplier,
                ),
                SizedBox(
                  width: 1.67 * SizeConfig.widthMultiplier,
                ),
                Text('${widget.walkingTime} from your location'),
              ],
            ),
            Icon(
              _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedDetail(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightMultiplier),
      child: Column(
        children: <Widget>[
          Row(
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
                    widget.prefTrip.bus.plateNumber,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                  Container(
                    width: 61.1 * SizeConfig.widthMultiplier,
                    child: Text(
                      widget.prefTrip.bus.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
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
                '${widget.prefTrip.passengersOnBoard}/${widget.prefTrip.bus.capacity}',
                style: Theme.of(context).textTheme.body2.copyWith(
                    color: _passengerStrength() < 2
                        ? Colors.red
                        : Theme.of(context).accentColor),
              ),
              Text(' Passengers on Board'),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Icon(
                Icons.pin_drop,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 5.56 * SizeConfig.widthMultiplier,
              ),
              Text(
                widget.prefTrip.mode == TripMode.PICK_UP
                    ? 'Pick Up Mode'
                    : 'Drop Off Mode',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 1.28 * SizeConfig.heightMultiplier),
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
          _buildHead(context),
          Divider(),
          _buildFooter(context),
          if (_expanded == true) _buildExpandedDetail(context),
        ],
      ),
    );
  }
}