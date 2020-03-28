import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import '../providers/route_model.dart' as r;


class RouteInfoCard extends StatefulWidget {
  // In this card, we check either driver is logged in to the app or passenger, bases on that we share the details accordingly
  LoginMode loginMode = LoginMode.Driver;
  final r.Route route;

  RouteInfoCard({
    @required this.route,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RouteInfoCardState();
  }
}

class _RouteInfoCardState extends State<RouteInfoCard> {
  Stop origin;
  Stop destination;

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
        width: 0.56 * SizeConfig.widthMultiplier,
        height: 2.27 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  Widget _locationWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        circle(context, filled: false),
        verticalLLine(context),
        circle(context, filled: true),
      ],
    );
  }

  Widget bottomVerticalLLine(BuildContext context) => Container(
        width: 0.26 * SizeConfig.widthMultiplier,
        height: 5.87 * SizeConfig.heightMultiplier,
        color: Colors.white38,
      );

  void setPoints() {
    setState(() {
      origin = widget.route.stopList[0];
      destination = widget.route.stopList[widget.route.stopList.length - 1];
    });
  }

  Widget _buildTopBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.56 * SizeConfig.heightMultiplier,
        horizontal: 2.78 * SizeConfig.widthMultiplier,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.route.name,
            style: Theme.of(context).textTheme.body2,
          ),
          SizedBox(height: 1.56 * SizeConfig.heightMultiplier),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          right: 2.2 * SizeConfig.widthMultiplier),
                      child: Text(origin.timeToReach)),
                  SizedBox(
                    height: 1.97 * SizeConfig.heightMultiplier,
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          right: 2.2 * SizeConfig.widthMultiplier),
                      child: Text(destination.timeToReach)),
                ],
              ),
              _locationWidget(context),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          left: 2.2 * SizeConfig.widthMultiplier),
                      child: Text(
                        origin.name,
                        style: Theme.of(context).textTheme.body1.copyWith(
                            fontSize: 2.4 * SizeConfig.textMultiplier),
                        overflow: TextOverflow.ellipsis,
                      )),
                  SizedBox(
                    height: 1.87 * SizeConfig.heightMultiplier,
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: 2.2 * SizeConfig.widthMultiplier),
                      child: Text(
                        destination.name,
                        style: Theme.of(context).textTheme.body1.copyWith(
                            fontSize: 2.4 * SizeConfig.textMultiplier),
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.56 * SizeConfig.heightMultiplier),
        ],
      ),
    );
  }

  Widget _buildBottomBody(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.88 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(2.78 * SizeConfig.imageSizeMultiplier),
            bottomRight: Radius.circular(2.78 * SizeConfig.imageSizeMultiplier),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 1.36 * SizeConfig.heightMultiplier,
              ),
              child: Column(
                children: <Widget>[
                  Text('PICK-UP',
                      style: TextStyle(fontSize: 9, color: Colors.white)),
                  Text(widget.route.pickUpTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            bottomVerticalLLine(context),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 1.36 * SizeConfig.heightMultiplier,
              ),
              child: Column(
                children: <Widget>[
                  Text('DROP-OFF',
                      style: TextStyle(fontSize: 9, color: Colors.white)),
                  Text(widget.route.dropOffTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    setPoints();
    return Container(
      margin: EdgeInsets.only(top: 1.28 * SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius:
            BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTopBody(context),
          _buildBottomBody(context),
        ],
      ),
    );
  }
}
