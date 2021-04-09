import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';

class FavoriteRouteCard extends StatelessWidget {
  final favorite;
  Function fetchFavoriteTrips;

  FavoriteRouteCard(this.favorite, this.fetchFavoriteTrips);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fetchFavoriteTrips(favorite);
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content:
                      Text('Delete \'${favorite.favoriteStop.name}\' card?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                    FlatButton(
                      onPressed: () {
                        Provider.of<RouteProvider>(context, listen: false)
                            .deleteConfig(favorite.id);
                        Navigator.pop(context);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ));
      },
      child: Container(
        // width: 140.0,
        margin: EdgeInsets.only(right: 2.02 * SizeConfig.widthMultiplier),
        padding: EdgeInsets.symmetric(
          vertical: 0.78 * SizeConfig.heightMultiplier,
          horizontal: 1.38 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            // width: 1.0,
            color: Colors.black12,
          ),
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 22.2 * SizeConfig.widthMultiplier,
                  child: Text(
                    favorite.routeName,
                    style: Theme.of(context).textTheme.body2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(DateFormat.jm()
                        .format(favorite.favoriteStop.timeToReach)),
                    Text(
                      'Est. Time',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 0.93 * SizeConfig.textMultiplier),
                    )
                  ],
                ),
              ],
            ),
            Container(
              width: 33.3 * SizeConfig.widthMultiplier,
              child: Text(
                favorite.favoriteStop.name,
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontSize: 2.18 * SizeConfig.textMultiplier),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
