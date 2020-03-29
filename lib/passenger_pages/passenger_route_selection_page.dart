import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/suggestion_card.dart';
import '../helpers/size_config.dart';

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
              onSubmitted: (value) {
                // --------------------------------------------------------------------------------
                // Modification required here, we should pass user's entered locations cordinates to
                // this method, currently sending dummy values 12, 32
                Provider.of<TripProvider>(context, listen: false)
                    .fetchSuggestedTrips(12, 32);
                // --------------------------------------------------------------------------------
              },
            ),
          ),
          // For Fetching User's Location automatically
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // --------------------------------------------------------------------------------
              // Modification required here, we should pass user's current locations cordinates to
              // this method, currently sending dummy values 12, 32
              Provider.of<TripProvider>(context, listen: false)
                  .fetchSuggestedTrips(12, 32);
              // --------------------------------------------------------------------------------
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteRouteCard(BuildContext context, FavoriteRoute favorite) {
    return GestureDetector(
      onTap: () {
        Provider.of<TripProvider>(context, listen: false)
            .fetchFavoriteSuggested(favorite);
      },
      onLongPress: () {
        showDialog(
            context: context,
            child: AlertDialog(
              content: Text('Delete \'${favorite.favoriteStop.name}\' card?'),
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
                    Text(favorite.favoriteStop.timeToReach),
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

  Widget _buildFavoriteRoutes(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);

    return FutureBuilder(
      // --------------------------------------------------------------------------------
      // Modification required here, pass the id of current logged in passenger, currently
      // passing '1' as the dummy id
      future: routeProvider.fetchAndSetFavorites(currentPassengerId: 1),
      // --------------------------------------------------------------------------------
      builder: (context, snapshot) => Container(
        // height: 15.28 * SizeConfig.heightMultiplier,
        child: routeProvider.passengerFavoriteRoutes.length == 0
            ? SizedBox(
                height: 0.0,
                width: 0.0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Favorite Routes',
                    style: Theme.of(context).textTheme.display2,
                  ),
                  SizedBox(
                    height: 0.78 * SizeConfig.heightMultiplier,
                  ),
                  Container(
                    height: 8.59 * SizeConfig.heightMultiplier,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: routeProvider.passengerFavoriteRoutes.length,
                      itemBuilder: (context, index) {
                        FavoriteRoute route =
                            routeProvider.passengerFavoriteRoutes[index];
                        return _buildFavoriteRouteCard(context, route);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1.56 * SizeConfig.heightMultiplier,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSuggestedRoutes(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    return Expanded(
      child: tripProvider.trips_suggested.length != 0
          ? ListView.builder(
              itemCount: tripProvider.trips_suggested.length,
              itemBuilder: (context, index) {
                Trip trip = tripProvider.trips_suggested[index];
                // Add searching logics here
                // Pass the nearest stop and times to reach them accordingly in future
                return SuggestionCard(
                  prefTrip: trip,
                );
              },
            )
          : Center(
              child: Text(
                'No Routes to suggest!',
                style: TextStyle(
                  fontSize: 2.63 * SizeConfig.textMultiplier,
                ),
              ),
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
            _buildSuggestedRoutes(context),
          ],
        ),
      )),
    );
  }
}
