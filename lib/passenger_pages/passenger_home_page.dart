import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/common_pages/app_drawer.dart';
import 'package:transpo_tracky_mobile_app/google_maps/passenger_hp_map.dart';
import 'package:transpo_tracky_mobile_app/helpers/manual_exception.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_tracking_page.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/passenger_home_page_top_bar.dart';
import '../helpers/size_config.dart';

class PassengerHomePage extends StatefulWidget {
  @override
  _PassengerHomePageState createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  Trip passengerSelectedTrip;

  void setSelectedTrip({Trip selectedTrip}) {
    setState(() {
      passengerSelectedTrip = selectedTrip;
    });
    print('trip selected');
  }

  Future<void> joinTrip(Trip passengerTrip) async {
    try {
      bool liveStatus = await Provider.of<TripProvider>(context, listen: false)
          .checkLiveStatus(passengerTrip.id);
      if (liveStatus == true) {
        await Provider.of<TripProvider>(context, listen: false)
            .joinTrip(selectedTrip: passengerTrip);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PassengerTrackingPage()));
      } else
        throw ManualException(
            title: 'Please Wait!',
            message: 'Your Captain has not allowed you yet to join the trip.');
    } on ManualException catch (error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(error.title),
                content: Text(error.message),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Okay'),
                  )
                ],
              ));
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Oh no!'),
                content: Text('Something went wrong.'),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Okay'),
                  )
                ],
              ));
    }
  }

  Widget _buildGoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (passengerSelectedTrip == null) {
          showDialog(
              context: context,
              child: AlertDialog(
                content: Text('Select a Route first'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Okay'))
                ],
              ));
        } else {
          joinTrip(passengerSelectedTrip);
          print(
              'id: ${passengerSelectedTrip.id}, stopId: ${passengerSelectedTrip.passengerStop.id}');
        }
      },
      child: Container(
        height: 7.03 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius:
                BorderRadius.circular(2.38 * SizeConfig.heightMultiplier),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
                blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
                blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
              ),
            ]),
        child: Center(
            child: Text(
          'LETS GO!',
          style: Theme.of(context).textTheme.button,
        )),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sure to Leave?'),
        content: Text('You are going to exit the app!'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Stack(
          children: <Widget>[
            PassengerHomePageMap(passengerSelectedTrip),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.5 * SizeConfig.widthMultiplier,
                vertical: 3.45 * SizeConfig.heightMultiplier,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PassengerHomePageTopBar(
                      selectedTrip: passengerSelectedTrip,
                      setSelectedTrip: setSelectedTrip),
                  _buildGoButton(context),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
