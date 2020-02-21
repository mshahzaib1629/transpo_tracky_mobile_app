import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transpo_tracky_mobile_app/common_pages/last_trips_detail_page.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/size_config.dart';
import 'package:transpo_tracky_mobile_app/widgets/trip_record_card.dart';

class LastTripsPage extends StatelessWidget {
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
          IconButton(
            icon: Icon(FontAwesomeIcons.calendarAlt),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTripsList(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
            itemCount: dummy_trips_record.length,
            itemBuilder: (context, index) {
              Trip trip = dummy_trips_record[index];
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
