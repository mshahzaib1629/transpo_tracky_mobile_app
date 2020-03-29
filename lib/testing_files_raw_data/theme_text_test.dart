import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/login_page.dart';
import '../size_config.dart';
import '../styling.dart';

class TestingThemeText extends StatelessWidget {
  const TestingThemeText({Key key}) : super(key: key);

  Widget _buildSample(BuildContext context, String data, TextStyle style) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Text(
        data,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Font Testing'),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildSample(context, 'Title, titleLight',
                      Theme.of(context).textTheme.title),
                  _buildSample(context, 'Sub Title, subTitleLight',
                      Theme.of(context).textTheme.subtitle),
                  _buildSample(context, 'SubHead, for tiles',
                      Theme.of(context).textTheme.subhead),
                  _buildSample(context, 'Button, button',
                      Theme.of(context).textTheme.button),
                  _buildSample(context, 'HeadLine, headline, dateTime',
                      Theme.of(context).textTheme.headline),
                  _buildSample(context, 'Display 1, largeTextLight',
                      Theme.of(context).textTheme.display1),
                  _buildSample(context, 'Display 2, flatButtonTextLight',
                      Theme.of(context).textTheme.display2),
                  _buildSample(context, 'Display 3, cardTitleLight',
                      Theme.of(context).textTheme.display3),
                  _buildSample(context, 'body 1, bodyLight1',
                      Theme.of(context).textTheme.body1),
                  _buildSample(context, 'body 2, bodyLight2',
                      Theme.of(context).textTheme.body2),
                ],
              ),
            ),
            RaisedButton(
                child: Text('Test Here'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage())))
          ],
        )),
      ),
    );
  }
}
