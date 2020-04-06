import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transpo_tracky_mobile_app/helpers/google_map_helper.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/widgets/route_info_card.dart';
import 'package:transpo_tracky_mobile_app/widgets/stop_card.dart';
import '../providers/route_model.dart' as r;

class RouteDetailPage extends StatefulWidget {
  final r.Route route;
  RouteDetailPage({this.route});

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  Widget _buildMap(BuildContext context) {
    final staticMapImageUrl =
        MapHelper.generateMapPreviewImage(stopList: widget.route.stopList);
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      height: 32.8125 * SizeConfig.heightMultiplier,
      child: staticMapImageUrl == null
          ? Text(
              'Something went wrong!',
              textAlign: TextAlign.center,
            )
          : Image.network(
              staticMapImageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  List<Widget> getStopList(context, List stops) {
    List<Widget> childs = [];
    for (var i = 0; i < stops.length; i++) {
      Stop currentStop = stops[i];
      childs.add(StopCard(
        index: i,
        currentStop: currentStop,
      ));
    }
    return childs;
  }

  Widget _buildRouteDetail(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 2.5 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 1.87 * SizeConfig.heightMultiplier,
          ),
          Text('Stops List',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: Theme.of(context).accentColor)),
          SizedBox(
            height: 0.78 * SizeConfig.heightMultiplier,
          ),
          Column(
            children: getStopList(context, widget.route.stopList),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Route Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildMap(context),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 2.2 * SizeConfig.widthMultiplier,
                // vertical: 0.25 * SizeConfig.heightMultiplier,
              ),
              child: Column(
                children: <Widget>[
                  RouteInfoCard(route: widget.route),
                  _buildRouteDetail(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
