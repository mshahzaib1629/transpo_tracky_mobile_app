import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/view_all_routes_page.dart';
import 'package:transpo_tracky_mobile_app/login_page.dart';

class DriverAppDrawer extends StatelessWidget {
  const DriverAppDrawer({Key key}) : super(key: key);

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
            title: Text('All Routes'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewAllRoutesPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Last 30 Trips'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('Rate The App'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Log out'),
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
