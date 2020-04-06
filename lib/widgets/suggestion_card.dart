import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import '../helpers/size_config.dart';

class SuggestionCard extends StatefulWidget {
  final Trip prefTrip;

  SuggestionCard({
    @required this.prefTrip,
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SuggestionCardState();
  }
}

class _SuggestionCardState extends State<SuggestionCard> {
  bool _expanded = false;
  bool _isLoading = false;

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
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        tripProvider.setSelectedTrip(selectedTrip: widget.prefTrip);
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
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
                      widget.prefTrip.passengerStop.estToReachBus != null
                          ? DateFormat.jm().format(
                              widget.prefTrip.passengerStop.estToReachBus)
                          : DateFormat.jm().format(
                              widget.prefTrip.passengerStop.timeToReach),
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Text(
                      widget.prefTrip.passengerStop.estToReachBus != null
                          ? ''
                          : 'Est. Time',
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
                      widget.prefTrip.passengerStop.name,
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
      ),
    );
  }

  void _fetchLocationAddress() async {
    if (widget.prefTrip.passengerStop.stopAddress == null) {
      try {
        widget.prefTrip.passengerStop.stopAddress =
            await MapHelper.getPlaceAddress(
          widget.prefTrip.passengerStop.latitude,
          widget.prefTrip.passengerStop.longitude,
        );
      } catch (error) {
        widget.prefTrip.passengerStop.stopAddress = null;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
        if (_expanded) {
          setState(() {
            _isLoading = true;
          });
          _fetchLocationAddress();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 3.05 * SizeConfig.widthMultiplier),
        child: Container(
          color: Colors.transparent,
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
                  Text(
                      '${widget.prefTrip.passengerStop.estWalkTime} from your location'),
                ],
              ),
              Icon(
                _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
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
              Container(
                width: 72.9 * SizeConfig.widthMultiplier,
                child: _isLoading
                    ? Text('Loading...')
                    : Text(
                        widget.prefTrip.passengerStop.stopAddress != null
                            ? widget.prefTrip.passengerStop.stopAddress
                            : 'No address available',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.prefTrip.mode == TripMode.PICK_UP
                  ? 'Pick Up Mode'
                  : 'Drop Off Mode',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Theme.of(context).accentColor),
            ),
          ),
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
