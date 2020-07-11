import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/common_pages/last_trips_detail_page.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import '../helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/widgets/trip_record_card.dart';

class LastTripsPage extends StatefulWidget {
  @override
  _LastTripsPageState createState() => _LastTripsPageState();
}

class _LastTripsPageState extends State<LastTripsPage> {
  bool _isInit = true;
  bool _isLoading = false;
  String _title = 'Last 30 Trips';

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<Trip> trips = [];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final tripProvider = Provider.of<TripProvider>(context, listen: false);

      tripProvider.fetchTripsRecord().catchError((error) {
        print(error);
        setState(() {
          trips = [];
        });
      }).then((_) {
        setState(() {
          trips = tripProvider.getTripsRecord;
          _isLoading = false;
          _isInit = false;
          // print('trips I got: ');
          // print(trips);
        });
      });
    }
    super.didChangeDependencies();
  }

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
            child: Text(
              _title,
              style: Theme.of(context).textTheme.display3,
            ),
          ),
          // For Fetching Trips w.r.t selected date
          IconButton(
            icon: Icon(FontAwesomeIcons.calendarAlt),
            onPressed: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime(2020, 02, 24),
                  firstDate: DateTime(2020, 01, 01),
                  lastDate: DateTime(2060, 02, 29));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    try {
      await tripProvider.fetchTripsRecord();
      setState(() {
        trips = tripProvider.getTripsRecord;
        _title = 'Last 30 Trips';
      });
    } catch (error) {
      setState(() {
        trips = [];
      });
    }
  }

  Widget _buildTripsList(BuildContext context) {
    return Expanded(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _onRefresh,
              child: trips.length == 0
                  ? _showErrorMessage()
                  : ListView.builder(
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        Trip trip = trips[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LastTripsDetailPage(trip: trip)));
                            },
                            child: TripRecordCard(trip: trip));
                      }),
            ),
    );
  }

  Widget _showErrorMessage() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 28.3 * SizeConfig.heightMultiplier,
        ),
        Center(
            child: Column(
          children: <Widget>[
            Text(
              'No Record Found!',
              style: TextStyle(fontSize: 2.63 * SizeConfig.textMultiplier),
            ),
            SizedBox(
              height: 1.54 * SizeConfig.heightMultiplier,
            ),
            Text(
              'PULL DOWN TO REFRESH',
              style: TextStyle(
                  fontSize: 2.43 * SizeConfig.textMultiplier,
                  color: Theme.of(context).accentColor),
            ),
          ],
        )),
      ],
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
            _buildTripsList(context),
          ],
        ),
      ),
    ));
  }
}
