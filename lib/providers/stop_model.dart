import 'package:intl/intl.dart';

class Stop {
  int id;
  String name;
  double longitude;
  double latitude;
  DateTime timeToReach;
  // EstToReachBus (estimated time to reach bus) &
  // estWalkTime (estimated time to walk towards stop) is for trip suggestions to passengers
  // these times will be calculated by 3rd party API's
  DateTime estToReachBus;
  String estWalkTime;
  // timeReached attribute is only for record trips, it is not necessary for trip suggestion routes
  String timeReached;

  Stop({
    this.id,
    this.name,
    this.longitude,
    this.latitude,
    this.timeToReach,
    this.estToReachBus,
    this.estWalkTime,
    this.timeReached,
  });
}

List<Stop> dummy_stops_1 = [
  Stop(
      id: 1,
      name: 'Muridke',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '6:50 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Rana Town',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '6:55 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Shadrah Round About',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:10 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Ahmed Travel',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:20 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Sanda',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:30 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Shera Kot',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:45 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Motorway Babu Sabu',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:50 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Thokar Niaz Baig',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:55 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'EME Canal Road',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:10 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Bahira Chowk',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:15 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'COMSATS',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
];

List<Stop> dummy_stops_2 = [
  Stop(
      id: 1,
      name: 'Bhati Chowk',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '6:45 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Yadgar',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '6:55 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Bhatti',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:15 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'MAO College',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:20 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Chuburji',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:30 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Samnabad Mor',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:50 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Chowk Yateem Khana',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:55 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Scheme Mor',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:58 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Raiwind Road',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:10 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'LDA Chowk',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:20 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'COMSATS',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
];

List<Stop> dummy_stops_3 = [
  Stop(
      id: 1,
      name: 'Gulshan Ravi',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Samnabad Mor',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Chowk Yateem Khana',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Scheme Mor',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Moon Market',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Multan Chungi',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Motorway Babu Sabu',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Thokar Niaz Baig',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Jublee Town',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Shahkam Chowk',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'COMSATS',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
];

List<Stop> dummy_stops_4 = [
  Stop(
      id: 1,
      name: 'Railway Station',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '6:40 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Shimla Hill',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '6:50 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Assembly Hall',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:20 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Ganga Ram Hospital',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Ichra',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:40 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Muslim Town Mor',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:45 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Jinnah Hospital',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:45 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Allah Ho Chowk',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '7:55 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'University of Central Punjab',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:10 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'Rehman Chowk',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:20 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
  Stop(
      id: 1,
      name: 'COMSATS',
      longitude: 123.4222,
      latitude: 4556.32,
      timeToReach: DateFormat('Hms', 'en_US').parse('14:23:01'),
      timeReached: '8:25 AM',
      estToReachBus: DateFormat('Hms', 'en_US').parse('7:23:01'),
      estWalkTime: '8 mins'),
];
