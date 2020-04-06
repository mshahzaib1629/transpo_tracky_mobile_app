import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';

class StopCard extends StatefulWidget {
  final index;
  final Stop currentStop;

  StopCard({
    this.index,
    this.currentStop,
  });

  @override
  _StopCardState createState() => _StopCardState();
}

class _StopCardState extends State<StopCard> {
  bool _isExpanded = false;
  bool _isLoading = false;

  void _fetchLocationAddress() async {
    if (widget.currentStop.stopAddress == null) {
      try {
        widget.currentStop.stopAddress = await MapHelper.getPlaceAddress(
          widget.currentStop.latitude,
          widget.currentStop.longitude,
        );
      } catch (error) {
        widget.currentStop.stopAddress = null;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        if (_isExpanded) {
          setState(() {
            _isLoading = true;
          });
          _fetchLocationAddress();
        }
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 1.28 * SizeConfig.heightMultiplier),
        padding: EdgeInsets.symmetric(
          vertical: 0.56 * SizeConfig.heightMultiplier,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).accentColor),
                          shape: BoxShape.circle),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.17 * SizeConfig.heightMultiplier,
                        horizontal: 1.93 * SizeConfig.widthMultiplier,
                      ),
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 2.4 * SizeConfig.widthMultiplier,
                    ),
                    Text(
                      widget.currentStop.name,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        DateFormat.jm().format(widget.currentStop.timeToReach)),
                    Text(
                      'Est. Time',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(fontSize: 1.56 * SizeConfig.textMultiplier),
                    ),
                  ],
                ),
              ],
            ),
            if (_isExpanded)
              Container(
                margin: EdgeInsets.only(left: 37, top: 5),
                width: 330,
                child: _isLoading
                    ? Text('Loading...')
                    : Text(
                        widget.currentStop.stopAddress != null
                            ? widget.currentStop.stopAddress
                            : 'No address available',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
