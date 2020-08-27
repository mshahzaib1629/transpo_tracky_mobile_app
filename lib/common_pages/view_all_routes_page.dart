import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/route_info_card.dart';
import './route_detail_page.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart' as r;
import '../helpers/size_config.dart';

class ViewAllRoutesPage extends StatefulWidget {
  @override
  _ViewAllRoutesPageState createState() => _ViewAllRoutesPageState();
}

class _ViewAllRoutesPageState extends State<ViewAllRoutesPage> {
  bool _isInit = true;
  bool _isLoading = false;

  String _title = 'Morning Routes';
  List<r.Route> routes = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final routeProvider = Provider.of<RouteProvider>(context, listen: false);

      routeProvider.fetchRoutes().catchError((error) {
        setState(() {
          routes = [];
        });
      }).then((_) {
        setState(() {
          routes = routeProvider.getFilteredRoutes(RouteFilter.Morning);
          _isLoading = false;
          _isInit = false;
        });
      });
    }
    super.didChangeDependencies();
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
            child: Text(
              _title,
              style: Theme.of(context).textTheme.display3,
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Morning'),
                value: RouteFilter.Morning,
              ),
              PopupMenuItem(
                child: Text('Evening'),
                value: RouteFilter.Evening,
              ),
              PopupMenuItem(
                child: Text('Faculty'),
                value: RouteFilter.Faculty,
              ),
              PopupMenuItem(
                child: Text('Hostel'),
                value: RouteFilter.Hostel,
              ),
              PopupMenuItem(
                child: Text('Testing'),
                value: RouteFilter.Testing,
              ),
            ],
            onSelected: (value) {
              setState(() {
                routes = Provider.of<RouteProvider>(context, listen: false)
                    .getFilteredRoutes(value);
                setState(() {
                  if (value == RouteFilter.Morning) _title = 'Morning Routes';
                  if (value == RouteFilter.Evening) _title = 'Evening Routes';
                  if (value == RouteFilter.Faculty) _title = 'Faculty Routes';
                  if (value == RouteFilter.Hostel) _title = 'Hostel Routes';
                  if (value == RouteFilter.Testing) _title = 'Testing Routes';
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    final route = Provider.of<RouteProvider>(context, listen: false);
    try {
      await route.fetchRoutes();
      setState(() {
        routes = route.getFilteredRoutes(RouteFilter.Morning);
        _title = 'Morning Routes';
      });
    } catch (error) {
      setState(() {
        routes = [];
      });
    }
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
              'No Routes Found!',
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
            SizedBox(height: 0.93 * SizeConfig.heightMultiplier),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _onRefresh,
                      child: routes.length == 0
                          ? _showErrorMessage()
                          : ListView.builder(
                              itemCount: routes.length,
                              itemBuilder: (context, index) {
                                r.Route route = routes[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RouteDetailPage(
                                          route: route,
                                        ),
                                      ),
                                    );
                                  },
                                  child: RouteInfoCard(route: route),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    ));
  }
}
