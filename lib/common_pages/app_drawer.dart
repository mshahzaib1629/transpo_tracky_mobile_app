import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/common_pages/last_trips_page.dart';
import 'package:transpo_tracky_mobile_app/common_pages/settings_page.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import './view_all_routes_page.dart';
import './login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Transpo Tracky!'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(Icons.directions_bus),
            title:
                Text('All Routes', style: Theme.of(context).textTheme.subhead),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewAllRoutesPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Last 30 Trips',
                style: Theme.of(context).textTheme.subhead),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LastTripsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings', style: Theme.of(context).textTheme.subhead),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('Rate The App',
                style: Theme.of(context).textTheme.subhead),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Log out', style: Theme.of(context).textTheme.subhead),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
