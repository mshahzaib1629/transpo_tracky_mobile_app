import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/providers/user_location.dart';
import 'package:transpo_tracky_mobile_app/widgets/passenger_favorite_route_card.dart';
import 'package:transpo_tracky_mobile_app/widgets/passenger_route_selection_page_top_bar.dart';
import 'package:transpo_tracky_mobile_app/widgets/suggestion_card.dart';
import '../helpers/size_config.dart';

class PassengerRouteSelectionPage extends StatefulWidget {
  @override
  _PassengerRouteSelectionPageState createState() =>
      _PassengerRouteSelectionPageState();
}

class _PassengerRouteSelectionPageState
    extends State<PassengerRouteSelectionPage> {
  bool _isLoading = false;

  Future<void> fetchTrips(UserLocation userLocation) async {
    setState(() {
      _isLoading = true;
    });
    if (userLocation != null)
      Provider.of<TripProvider>(context, listen: false)
          .fetchSuggestedTrips(userLocation.latitude, userLocation.longitude);
    setState(() {
      _isLoading = false;
    });
    print('trips fetched');
  }

  Widget _buildFavoriteRoutes(BuildContext context) {
    return FutureBuilder(
      // --------------------------------------------------------------------------------
      // Modification required here, pass the id of current logged in passenger, currently
      // passing '1' as the dummy id
      future: Provider.of<RouteProvider>(context, listen: false)
          .fetchAndSetFavorites(currentPassengerId: 1),
      // --------------------------------------------------------------------------------
      builder: (context, snapshot) => Consumer<RouteProvider>(
        builder: (context, routeConsumer, child) => Container(
          child: routeConsumer.passengerFavoriteRoutes.length == 0
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
                        itemCount: routeConsumer.passengerFavoriteRoutes.length,
                        itemBuilder: (context, index) {
                          FavoriteRoute favoriteRoute =
                              routeConsumer.passengerFavoriteRoutes[index];
                          return FavoriteRouteCard(favoriteRoute);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1.56 * SizeConfig.heightMultiplier,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSuggestedRoutes(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    return Expanded(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (tripProvider.trips_suggested.length != 0)
              ? ListView.builder(
                  itemCount: tripProvider.trips_suggested.length,
                  itemBuilder: (context, index) {
                    Trip trip = tripProvider.trips_suggested[index];
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
            RouteSelectionTopBar(
              fetchTrips: fetchTrips,
            ),
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
