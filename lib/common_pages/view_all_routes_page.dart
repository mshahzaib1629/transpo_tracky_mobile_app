import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './route_detail_page.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart' as r;
import 'package:transpo_tracky_mobile_app/size_config.dart';

class ViewAllRoutesPage extends StatelessWidget {
  const ViewAllRoutesPage({Key key}) : super(key: key);

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
        margin: EdgeInsets.only(left: 1.72 * SizeConfig.widthMultiplier),
        width: 0.56 * SizeConfig.widthMultiplier,
        height: 1.87 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 9.37 * SizeConfig.heightMultiplier,
      // margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.only(
        left: 4.28 * SizeConfig.widthMultiplier,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            // Let user enter route manually
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Here',
              ),
              onSubmitted: (vale) {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, r.Route route) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => RouteDetailPage(route))),
      child: Container(
          margin: EdgeInsets.only(
            bottom: 1.28 * SizeConfig.heightMultiplier,
          ),
          height: 23.56 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius:
                BorderRadius.circular(4.17 * SizeConfig.imageSizeMultiplier),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.56 * SizeConfig.widthMultiplier,
              vertical: 2.34 * SizeConfig.heightMultiplier,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 72.2 * SizeConfig.widthMultiplier,
                  child: Text(
                    route.name,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 2.8 * SizeConfig.textMultiplier),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 0.78 * SizeConfig.heightMultiplier,
                ),
                Row(
                  children: <Widget>[
                    circle(context, filled: false),
                    SizedBox(
                      width: 1.38 * SizeConfig.widthMultiplier,
                    ),
                    Container(
                      width: 72.2 * SizeConfig.widthMultiplier,
                      child: Text(
                        route.stopList[0].name,
                        style: Theme.of(context).textTheme.display3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                verticalLLine(context),
                Row(
                  children: <Widget>[
                    circle(context, filled: true),
                    SizedBox(
                      width: 1.38 * SizeConfig.widthMultiplier,
                    ),
                    Container(
                      width: 72.2 * SizeConfig.widthMultiplier,
                      child: Text(
                        route.stopList[route.stopList.length - 1].name,
                        style: Theme.of(context).textTheme.display3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.56 * SizeConfig.heightMultiplier,
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(
                //       vertical: 0.63 * SizeConfig.heightMultiplier),
                //   child: Divider(
                //     thickness: 0.16 * SizeConfig.heightMultiplier,
                //   ),
                // ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.78 * SizeConfig.widthMultiplier,
                        vertical: 0.78 * SizeConfig.heightMultiplier,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(
                            1.38 * SizeConfig.imageSizeMultiplier),
                      ),
                      child: Text(
                        'PICK UP: ' + route.pickUpTime,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                    SizedBox(width: 2.22 * SizeConfig.widthMultiplier),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.78 * SizeConfig.widthMultiplier,
                        vertical: 0.78 * SizeConfig.heightMultiplier,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(
                            1.38 * SizeConfig.imageSizeMultiplier),
                      ),
                      child: Text(
                        'DROP OFF: ' + route.dropOffTime,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Routes'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ],
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2.2 * SizeConfig.widthMultiplier,
            vertical: 1.25 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            children: <Widget>[
              _buildTopBar(context),
              Expanded(
                child: Consumer<r.RouteProvider>(
                  builder: (context, routeConsumer, child) => ListView.builder(
                    itemCount: routeConsumer.dummy_routes.length,
                    itemBuilder: (context, index) {
                      r.Route route = routeConsumer.dummy_routes[index];
                      return _buildCard(context, route);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
