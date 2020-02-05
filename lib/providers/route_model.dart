import 'stop_model.dart';

class Route {
  int id;
  String name;
  String pickUpTime;
  String dropOffTime;
  List<Stop> stopList;

  Route({
    this.id,
    this.name,
    this.pickUpTime,
    this.dropOffTime,
    this.stopList,
  });
}

List<Route> dummy_routes = [
  Route(
    id: 1,
    name: 'Route# 1',
    pickUpTime: '8:30 AM',
    dropOffTime: '5:30 PM',
    stopList: dummy_stops_1,
  ),
  Route(
    id: 2,
    name: 'Route# 2',
    pickUpTime: '8:30 AM',
    dropOffTime: '5:30 PM',
    stopList: dummy_stops_2,
  ),
  Route(
    id: 3,
    name: 'Route# 3',
    pickUpTime: '8:30 AM',
    dropOffTime: '5:30 PM',
    stopList: dummy_stops_3,
  ),
  Route(
    id: 4,
    name: 'Route# 4',
    pickUpTime: '8:30 AM',
    dropOffTime: '5:30 PM',
    stopList: dummy_stops_4,
  ),
];
