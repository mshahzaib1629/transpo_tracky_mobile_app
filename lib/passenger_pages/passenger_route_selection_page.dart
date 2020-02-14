import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/suggestionCard.dart';

import '../size_config.dart';

class PassengerRouteSelectionPage extends StatelessWidget {
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
                hintText: 'Enter Your Location',
              ),
              onSubmitted: (vale) {},
            ),
          ),
          // For Fetching User's Location automatically
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteRouteCard(BuildContext context, FavoriteRoute route) {
    return GestureDetector(
      onTap: () {
        print('hello');
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
                    route.routeName,
                    style: Theme.of(context).textTheme.body2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(route.favoriteStop.timeToReach),
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
                route.favoriteStop.name,
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

  Widget _buildFavoriteRoutes(BuildContext context) {
    return Container(
      height: 13.28 * SizeConfig.heightMultiplier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Favorite Routes',
            style: Theme.of(context).textTheme.display3,
          ),
          SizedBox(
            height: 0.78 * SizeConfig.heightMultiplier,
          ),
          Container(
            height: 8.59 * SizeConfig.heightMultiplier,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dummy_favorite_routes.length,
              itemBuilder: (context, index) {
                FavoriteRoute route = dummy_favorite_routes[index];
                return _buildFavoriteRouteCard(context, route);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedRoutes(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: dummy_trips_suggested.length,
        itemBuilder: (context, index) {
          Trip trip = dummy_trips_suggested[index];
          // Add searching logics here
          // Pass the nearest stop and times to reach them accordingly in future
          return SuggestionCard(
            prefTrip: trip,
            prefStop: Stop(
                id: trip.route.stopList[0].id,
                name: trip.route.stopList[0].name,
                latitude: trip.route.stopList[0].latitude,
                longitude: trip.route.stopList[0].longitude),
            approxTime: '12 mins',
            walkingTime: '10 mins',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            SizedBox(
              height: 1.56 * SizeConfig.heightMultiplier,
            ),
            _buildFavoriteRoutes(context),
            SizedBox(
              height: 1.56 * SizeConfig.heightMultiplier,
            ),
            _buildSuggestedRoutes(context),
          ],
        ),
      )),
    );
  }
}
