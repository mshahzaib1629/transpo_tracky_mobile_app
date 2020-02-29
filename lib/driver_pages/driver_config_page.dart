import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_navigation_page.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';

import '../size_config.dart';

class DriverConfigurationPage extends StatefulWidget {
  bool isExpanded;
  DriverConfigurationPage({this.isExpanded});

  @override
  createState() => _DriverConfigurationPageState();
}

class _DriverConfigurationPageState extends State<DriverConfigurationPage> {
  Widget _horizontalLLine(BuildContext context) => Container(
        margin:
            EdgeInsets.symmetric(vertical: 2.82 * SizeConfig.widthMultiplier),
        width: 16.87 * SizeConfig.widthMultiplier,
        height: 0.56 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  Widget _buildTopBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isExpanded = !widget.isExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        color: Colors.grey.withOpacity(0.0),
        child: Column(
          children: <Widget>[
            _horizontalLLine(context),
            SizedBox(
              height: 0.78 * SizeConfig.heightMultiplier,
            ),
            Text(
              'CONFIGURATION',
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(letterSpacing: 0.15 * SizeConfig.textMultiplier),
            ),
            SizedBox(
              height: 0.78 * SizeConfig.heightMultiplier,
            ),
            Divider(
              thickness: 0.15 * SizeConfig.heightMultiplier,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAutoConfigCard(BuildContext context, TripConfig config) {
    return GestureDetector(
      onTap: () {
        print('hello');
      },
      child: Container(
        width: 22.2 * SizeConfig.widthMultiplier,
        margin: EdgeInsets.only(right: 2.02 * SizeConfig.widthMultiplier),
        padding: EdgeInsets.symmetric(
          horizontal: 2.38 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
        ),
        child: Center(
          child: Text(
            config.configName,
            style: Theme.of(context).textTheme.display2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildAutoConfigs(BuildContext context) {
    return Container(
      height: 13.28 * SizeConfig.heightMultiplier,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 0.8 * SizeConfig.widthMultiplier,
              top: 1.25 * SizeConfig.heightMultiplier,
              bottom: 0.625 * SizeConfig.heightMultiplier,
            ),
            child: Text(
              'AUTO-FILLS',
              style: Theme.of(context).textTheme.display2,
            ),
          ),
          SizedBox(
            height: 0.78 * SizeConfig.heightMultiplier,
          ),
          Container(
            height: 6.59 * SizeConfig.heightMultiplier,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dummy_trip_configs.length,
              itemBuilder: (context, index) {
                TripConfig config = dummy_trip_configs[index];
                return _buildAutoConfigCard(context, config);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
        Container(
          color: Colors.pink,
          height: 25.0,
          margin: EdgeInsets.only(top: 10.0),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 2.5 * SizeConfig.heightMultiplier),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                setState(() {
                  widget.isExpanded = false;
                });
              },
              child: Text('CANCEL', style: Theme.of(context).textTheme.body1)),
          FlatButton(
            onPressed: () {},
            child: Text('CREATE AUTO-FILL',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Theme.of(context).accentColor)),
          ),
          RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    content: Container(
                      height: 10.47 * SizeConfig.heightMultiplier,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Initial Meter Reading'),
                          TextFormField(
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DriverNavigationPage()));
                          },
                          child: Text('Lets Go'))
                    ],
                  ));
            },
            child: Text('LETS GO!',
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.isExpanded
          ? 3.125 * SizeConfig.heightMultiplier
          : 77.8 * SizeConfig.heightMultiplier,
      // top: 20.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (14.06 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
              blurRadius: 2.17 * SizeConfig.imageSizeMultiplier,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
              blurRadius: 2.17 * SizeConfig.imageSizeMultiplier,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
            topRight: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
          ),
        ),
        child: Column(
          children: <Widget>[
            _buildTopBar(context),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.6 * SizeConfig.widthMultiplier),
              child: Container(
                height: 75 * SizeConfig.heightMultiplier,
                child: ListView(
                  children: <Widget>[
                    _buildAutoConfigs(context),
                    Divider(),
                    _buildForm(context),
                    _buildBottomBar(context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
