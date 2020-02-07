import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/login_page.dart';

class TestingThemeColor extends StatefulWidget {
  TestingThemeColor({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestingThemeColor();
  }
}

class _TestingThemeColor extends State<TestingThemeColor> {
  Widget _buildSamples(String title, Color themeColor) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      height: 150.0,
      color: themeColor,
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _buildSamples(
                        'Primary Color', Theme.of(context).primaryColor),
                    _buildSamples(
                        'Accent Color', Theme.of(context).accentColor),
                    _buildSamples('Scaffold Background Color',
                        Theme.of(context).scaffoldBackgroundColor),
                    _buildSamples(
                        'AppBar Color', Theme.of(context).appBarTheme.color),
                    _buildSamples(
                        'Button Color', Theme.of(context).buttonColor),
                    _buildSamples(
                        'Icon Color', Theme.of(context).iconTheme.color),
                    _buildSamples(
                        'Indicator Color', Theme.of(context).indicatorColor),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
