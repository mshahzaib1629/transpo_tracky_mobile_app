import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

class RestPage extends StatefulWidget {
  @override
  _RestPageState createState() => _RestPageState();
}

class _RestPageState extends State<RestPage> {
  TripProvider _tripProvider;
  Trip _currentTrip;
  Stop _currentStop;
  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tripProvider = Provider.of<TripProvider>(context, listen: false);
    _currentTrip = _tripProvider.driverCreatedTrip;
    _currentStop = _currentTrip.route.stopList[0];
  }

  List<Widget> getDriversList(context, List drivers) {
    List<Widget> childs = [];
    for (var i = 0; i < drivers.length; i++) {
      Driver currentDriver = drivers[i];
      childs.add(Padding(
        padding: EdgeInsets.only(bottom: 1.25 * SizeConfig.heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 38.9 * SizeConfig.widthMultiplier,
              child: Text(
                currentDriver.registrationID,
                style: Theme.of(context).textTheme.display1.copyWith(
                      color: Theme.of(context).accentColor,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Container(
              width: 38.9 * SizeConfig.widthMultiplier,
              child: Text(
                currentDriver.firstName + ' ' + currentDriver.lastName,
                style: Theme.of(context).textTheme.display3,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ));
    }
    return childs;
  }

  Widget _buildDriversDetail(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.person_pin,
          color: Theme.of(context).accentColor,
        ),
        SizedBox(
          width: 5.56 * SizeConfig.widthMultiplier,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getDriversList(context, _currentTrip.drivers),
        ),
      ],
    );
  }

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
        width: 0.56 * SizeConfig.widthMultiplier,
        height: 2.77 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  Widget _locationWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.7 * SizeConfig.widthMultiplier),
      child: Column(
        children: <Widget>[
          circle(context, filled: false),
          verticalLLine(context),
          circle(context, filled: true),
        ],
      ),
    );
  }

  Widget _buildBusDetail(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.directions_bus,
          color: Theme.of(context).accentColor,
        ),
        SizedBox(
          width: 5.56 * SizeConfig.widthMultiplier,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 38.9 * SizeConfig.widthMultiplier,
              child: Text(
                _currentTrip.bus.plateNumber,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Theme.of(context).accentColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 38.9 * SizeConfig.widthMultiplier,
              child: Text(
                _currentTrip.bus.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.display3,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTrigger(BuildContext context) {
    return Positioned(
      top: 7.8 * SizeConfig.heightMultiplier,
      child: Container(
        height: 10.9 * SizeConfig.heightMultiplier,
        width: 13.8 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(4.16 * SizeConfig.imageSizeMultiplier),
        ),
        child: IconButton(
            icon: Icon(
              Icons.menu,
              size: 8.3 * SizeConfig.imageSizeMultiplier,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }),
      ),
    );
  }

  Widget _buildRouteSummary(BuildContext context) {
    return Row(
      children: [
        _locationWidget(context),
        SizedBox(
          width: 5.56 * SizeConfig.widthMultiplier,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 150,
                padding:
                    EdgeInsets.only(left: 2.2 * SizeConfig.widthMultiplier),
                child: Text(
                  _currentStop.name,
                  style: Theme.of(context).textTheme.display3,
                  overflow: TextOverflow.ellipsis,
                )),
            SizedBox(
              height: 1.87 * SizeConfig.heightMultiplier,
            ),
            Container(
              width: 41.66 * SizeConfig.widthMultiplier,
              padding: EdgeInsets.only(left: 2.2 * SizeConfig.widthMultiplier),
              child: Text(
                _currentTrip.route
                    .stopList[_currentTrip.route.stopList.length - 1].name,
                style: Theme.of(context).textTheme.display3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSideDrawerMenu(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 52.8 * SizeConfig.widthMultiplier,
            child: Text(
              _currentTrip.route.name,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Theme.of(context).accentColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(
          height: 3.125 * SizeConfig.heightMultiplier,
        ),
        _buildDriversDetail(context),
        SizedBox(
          height: 1.56 * SizeConfig.heightMultiplier,
        ),
        Divider(),
        SizedBox(
          height: 1.56 * SizeConfig.heightMultiplier,
        ),
        _buildBusDetail(context),
        SizedBox(
          height: 1.56 * SizeConfig.heightMultiplier,
        ),
        Divider(),
        SizedBox(
          height: 1.56 * SizeConfig.heightMultiplier,
        ),
        _buildRouteSummary(context),
      ],
    );
  }

  Future<void> _updateStatus() {
    return _tripProvider
        .setLiveStatus(_currentTrip.id)
        .then((value) => Navigator.pop(context))
        .catchError((error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Oh no!'),
                content: Text('Something went wrong.\nTry again please.'),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'))
                ],
              ));
    });
  }

  Widget _buildContinueButton(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : RaisedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _updateStatus();
              setState(() {
                _isLoading = false;
              });
            },
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.3 * SizeConfig.widthMultiplier,
              vertical: 2.3 * SizeConfig.heightMultiplier,
            ),
          );
  }

  Widget _buildBasePage() {
    return Padding(
      padding: EdgeInsets.only(
        right: 11.1 * SizeConfig.widthMultiplier,
        left: 5.5 * SizeConfig.widthMultiplier,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 2.2 * SizeConfig.widthMultiplier,
                vertical: 1.25 * SizeConfig.heightMultiplier,
              ),
              child: Text(
                'You are just about to reach the starting point',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Image(
                    height: 6.25 * SizeConfig.heightMultiplier,
                    width: 11.1 * SizeConfig.widthMultiplier,
                    image: AssetImage('assets/images/marker.png'),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    _currentStop.name,
                    style: TextStyle(
                      fontSize: 5.44 * SizeConfig.widthMultiplier,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 17.2 * SizeConfig.heightMultiplier,
            ),
            Image(
              height: 21.8 * SizeConfig.heightMultiplier,
              width: 38.8 * SizeConfig.widthMultiplier,
              image: AssetImage('assets/images/tea.png'),
            ),
            SizedBox(
              height: 17.2 * SizeConfig.heightMultiplier,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Grasp a cup of tea and continue!',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideDrawer() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      left: _isExpanded
          ? 22.2 * SizeConfig.widthMultiplier
          : 83.3 * SizeConfig.widthMultiplier,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 7 * SizeConfig.widthMultiplier),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(
                      -2.8 * SizeConfig.widthMultiplier,
                      0.078 * SizeConfig.heightMultiplier,
                    ),
                    blurRadius: 2.17 * SizeConfig.imageSizeMultiplier,
                  ),
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(
                      -2.8 * SizeConfig.widthMultiplier,
                      -0.078 * SizeConfig.heightMultiplier,
                    ),
                    blurRadius: 2.17 * SizeConfig.imageSizeMultiplier,
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width -
                  (26.3 * SizeConfig.widthMultiplier),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 9.7 * SizeConfig.widthMultiplier,
                  vertical: 10.9 * SizeConfig.heightMultiplier,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _buildSideDrawerMenu(context),
                    ),
                    _buildContinueButton(context),
                  ],
                ),
              ),
            ),
          ),
          _buildTrigger(context),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Continue to the trip?'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Not Now'),
          ),
          FlatButton(
            onPressed: () {
              _updateStatus();
              Navigator.pop(context);
            },
            child: Text('Sure'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Stack(
          children: [
            _buildBasePage(),
            _buildSideDrawer(),
          ],
        )),
      ),
    );
  }
}
