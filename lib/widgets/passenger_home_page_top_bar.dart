import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_route_selection_page.dart';
import '../helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

class PassengerHomePageTopBar extends StatefulWidget {
  final Trip selectedTrip;
  final Function setSelectedTrip;

  PassengerHomePageTopBar({this.selectedTrip, this.setSelectedTrip});
  @override
  _PassengerHomePageTopBarState createState() =>
      _PassengerHomePageTopBarState();
}

class _PassengerHomePageTopBarState extends State<PassengerHomePageTopBar> {
  bool _showFavoriteOption = false;
  bool _isInit = true;

  Widget _topBarShrinked(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showFavoriteOption = false;
      });
    });
    return Text(
      'Select Your Route',
      style: Theme.of(context)
          .textTheme
          .body2
          .copyWith(fontWeight: FontWeight.normal),
    );
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
        // margin: EdgeInsets.only(left: .32 * SizeConfig.widthMultiplier),
        width: 0.56 * SizeConfig.widthMultiplier,
        height: 2.87 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  Widget sideIcons(BuildContext context) {
    return Column(
      children: <Widget>[
        circle(context, filled: false),
        verticalLLine(context),
        circle(context, filled: true)
      ],
    );
  }

  void showFavoriteOption() {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    if (widget.selectedTrip != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (_isInit == true)
          setState(() {
            _showFavoriteOption =
                !routeProvider.isFavoriteFound(trip: widget.selectedTrip);
            _isInit = false;
          });
      });
    } else
      setState(() {
        _showFavoriteOption = false;
      });
  }

  Widget _topBarExpanded(BuildContext context) {
    showFavoriteOption();
    return Padding(
      padding: EdgeInsets.only(
          top: 1.56 * SizeConfig.heightMultiplier,
          bottom: 1.56 * SizeConfig.heightMultiplier,
          right: 2.78 * SizeConfig.widthMultiplier),
      child: Row(
        children: <Widget>[
          sideIcons(context),
          SizedBox(
            width: 2.78 * SizeConfig.widthMultiplier,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  width: 66.6 * SizeConfig.widthMultiplier,
                  padding: EdgeInsets.symmetric(
                      vertical: 0.78 * SizeConfig.heightMultiplier,
                      horizontal: 1.38 * SizeConfig.widthMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.28 * SizeConfig.widthMultiplier,
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(
                        1.38 * SizeConfig.imageSizeMultiplier),
                  ),
                  child: Text(
                    widget.selectedTrip.mode == TripMode.PICK_UP
                        ? widget.selectedTrip.passengerStop.name
                        : widget.selectedTrip.route.stopList[0].name,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 0.93 * SizeConfig.heightMultiplier,
                ),
                Container(
                  width: 66.5 * SizeConfig.widthMultiplier,
                  padding: EdgeInsets.symmetric(
                      vertical: 0.78 * SizeConfig.heightMultiplier,
                      horizontal: 1.38 * SizeConfig.widthMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.28 * SizeConfig.widthMultiplier,
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(
                        1.38 * SizeConfig.imageSizeMultiplier),
                  ),
                  child: Text(
                    widget.selectedTrip.mode == TripMode.PICK_UP
                        ? widget.selectedTrip
                            .route
                            .stopList[widget.selectedTrip.route.stopList.length - 1]
                            .name
                        : widget.selectedTrip.passengerStop.name,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteOptionBar(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              2.78 * SizeConfig.imageSizeMultiplier,
            ),
            bottomRight: Radius.circular(2.78 * SizeConfig.imageSizeMultiplier),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.times,
                  color: Theme.of(context).accentColor,
                  size: 5 * SizeConfig.imageSizeMultiplier,
                ),
                onPressed: () {
                  setState(() {
                    _showFavoriteOption = false;
                  });
                }),
            FlatButton(
                onPressed: () {
                  Provider.of<RouteProvider>(context, listen: false)
                      // --------------------------------------------------------------------------------
                      // Modification required here, pass the id of current logged in passenger, currently
                      // passing '1' as the dummy id
                      .addFavorite(
                          trip: widget.selectedTrip,
                          currentPassengerId: 1);
                  // --------------------------------------------------------------------------------
                  setState(() {
                    _showFavoriteOption = false;
                  });
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${widget.selectedTrip.passengerStop.name} added to favorites'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  '+ Mark Favorite',
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: Theme.of(context).accentColor),
                ))
          ],
        ),
      );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      crossAxisAlignment: widget.selectedTrip == null
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        Expanded(
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassengerRouteSelectionPage(
                            widget.setSelectedTrip)));
              },
              child: widget.selectedTrip == null
                  ? _topBarShrinked(context)
                  : _topBarExpanded(context)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
              blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
              blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
            ),
          ]),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildTopBar(context),
              if (_showFavoriteOption == true) _favoriteOptionBar(context),
            ],
          ),
        ],
      ),
    );
  }
}
