import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/widgets/route_info_card.dart';
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.28 * SizeConfig.widthMultiplier,
          color: Colors.black12,
        ),
        borderRadius:
            BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            // Let user enter location manually
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Here',
              ),
              onSubmitted: (vale) {},
            ),
          ),
          // For Fetching User's Location automatically
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('All'),
                    ),
                    PopupMenuItem(
                      child: Text('Morning'),
                    ),
                    PopupMenuItem(
                      child: Text('Evening'),
                    ),
                  ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 2.2 * SizeConfig.widthMultiplier,
          vertical: 1.25 * SizeConfig.heightMultiplier,
        ),
        child: Column(
          children: <Widget>[
            _buildTopBar(context),
            SizedBox(height: 0.93 * SizeConfig.heightMultiplier),
            Expanded(
              child: Consumer<r.RouteProvider>(
                builder: (context, routeConsumer, child) => ListView.builder(
                  itemCount: routeConsumer.dummy_routes.length,
                  itemBuilder: (context, index) {
                    r.Route route = routeConsumer.dummy_routes[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RouteDetailPage(
                                        route: route,
                                      )));
                        },
                        child: RouteInfoCard(route: route));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
