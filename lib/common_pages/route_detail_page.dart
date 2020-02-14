import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/size_config.dart';
import '../providers/route_model.dart' as r;

class RouteDetailPage extends StatelessWidget {
  final r.Route route;
  RouteDetailPage(this.route);

  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 32.8125 * SizeConfig.heightMultiplier,
    );
  }

  Widget _buildCard(BuildContext context, Stop stop) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 0.078 * SizeConfig.heightMultiplier),
      padding: EdgeInsets.symmetric(
          horizontal: 5.56 * SizeConfig.widthMultiplier,
          vertical: 3.125 * SizeConfig.heightMultiplier),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 63.89 * SizeConfig.widthMultiplier,
                child: Text(
                  stop.name,
                  style: Theme.of(context).textTheme.display3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(stop.timeToReach,
                  style: Theme.of(context).textTheme.headline),
              Text(
                'Est. Time',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
      ),
      body: Column(
        children: <Widget>[
          _buildMap(context),
          Expanded(
            child: ListView.builder(
                itemCount: route.stopList.length,
                itemBuilder: (context, index) {
                  Stop stop = route.stopList[index];
                  return _buildCard(context, stop);
                }),
          )
        ],
      ),
    );
  }
}
