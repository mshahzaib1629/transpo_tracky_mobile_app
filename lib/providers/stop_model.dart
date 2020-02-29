class Stop {
  int id;
  String name;
  double longitude;
  double latitude;
  String timeToReach;
  // timeReached attribute is only for record trips, it is not necessary for trip suggestion routes
  String timeReached;

  Stop({
    this.id,
    this.name,
    this.longitude,
    this.latitude,
    this.timeToReach,
    this.timeReached,
  });
}

List<Stop> dummy_stops_1 = [
  Stop(
    id: 1,
    name: 'Muridke',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '6:45 AM',
    timeReached: '6:50 AM',
  ),
  Stop(
    id: 1,
    name: 'Rana Town',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:00 AM',
    timeReached: '6:55 AM',
  ),
  Stop(
    id: 1,
    name: 'Shadrah Round About',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:15 AM',
    timeReached: '7:10 AM',
  ),
  Stop(
    id: 1,
    name: 'Ahmed Travel',
    longitude: 123.4222,
    latitude: 4556.32,
        timeToReach: '7:18 AM',
    timeReached: '7:20 AM',
  ),
  Stop(
    id: 1,
    name: 'Sanda',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:35 AM',
    timeReached: '7:30 AM',
  ),
  Stop(
    id: 1,
    name: 'Shera Kot',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:45 AM',
    timeReached: '7:45 AM',
  ),
  Stop(
    id: 1,
    name: 'Motorway Babu Sabu',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:47 AM',
    timeReached: '7:50 AM',
  ),
  Stop(
    id: 1,
    name: 'Thokar Niaz Baig',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:00 AM',
    timeReached: '7:55 AM',
  ),
  Stop(
    id: 1,
    name: 'EME Canal Road',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:05 AM',
    timeReached: '8:10 AM',
  ),
  Stop(
    id: 1,
    name: 'Bahira Chowk',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:15 AM',
    timeReached: '8:15 AM',
  ),
  Stop(
    id: 1,
    name: 'COMSATS',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:20 AM',
    timeReached: '8:25 AM',
  ),
];

List<Stop> dummy_stops_2 = [
  Stop(
    id: 1,
    name: 'Bhati Chowk',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '6:45 AM',
    timeReached: '6:45 AM',
  ),
  Stop(
    id: 1,
    name: 'Yadgar',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:00 AM',
    timeReached: '6:55 AM',
  ),
  Stop(
    id: 1,
    name: 'Bhatti',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:15 AM',
    timeReached: '7:15 AM',
  ),
  Stop(
    id: 1,
    name: 'MAO College',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:20 AM',
    timeReached: '7:20 AM',
  ),
  Stop(
    id: 1,
    name: 'Chuburji',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:35 AM',
    timeReached: '7:30 AM',
  ),
  Stop(
    id: 1,
    name: 'Samnabad Mor',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:45 AM',
    timeReached: '7:50 AM',
  ),
  Stop(
    id: 1,
    name: 'Chowk Yateem Khana',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:47 AM',
    timeReached: '7:55 AM',
  ),
  Stop(
    id: 1,
    name: 'Scheme Mor',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:00 AM',
    timeReached: '7:58 AM',
  ),
  Stop(
    id: 1,
    name: 'Raiwind Road',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:05 AM',
    timeReached: '8:10 AM',
  ),
  Stop(
    id: 1,
    name: 'LDA Chowk',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:15 AM',
    timeReached: '8:20 AM',
  ),
  Stop(
    id: 1,
    name: 'COMSATS',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:20 AM',
    timeReached: '8:25 AM',
  ),
];

List<Stop> dummy_stops_3 = [
  Stop(
    id: 1,
    name: 'Gulshan Ravi',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '6:45 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Samnabad Mor',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:00 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Chowk Yateem Khana',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:15 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Scheme Mor',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:20 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Moon Market',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:35 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Multan Chungi',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:45 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Motorway Babu Sabu',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:47 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Thokar Niaz Baig',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:00 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Jublee Town',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:05 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Shahkam Chowk',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:15 AM',
    timeReached: '8:25 AM',
  ),
  Stop(
    id: 1,
    name: 'COMSATS',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:20 AM',
    timeReached: '8:25 AM',
  ),
];

List<Stop> dummy_stops_4 = [
  Stop(
    id: 1,
    name: 'Railway Station',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '6:45 AM',
    timeReached: '6:40 AM',
  ),
  Stop(
    id: 1,
    name: 'Shimla Hill',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:00 AM',
    timeReached: '6:50 AM',
  ),
  Stop(
    id: 1,
    name: 'Assembly Hall',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:15 AM',
    timeReached: '7:20 AM',
  ),
  Stop(
    id: 1,
    name: 'Ganga Ram Hospital',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:20 AM',
    timeReached: '7:25 AM',
  ),
  Stop(
    id: 1,
    name: 'Ichra',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:35 AM',
    timeReached: '7:40 AM',
  ),
  Stop(
    id: 1,
    name: 'Muslim Town Mor',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:45 AM',
    timeReached: '7:45 AM',
  ),
  Stop(
    id: 1,
    name: 'Jinnah Hospital',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '7:47 AM',
    timeReached: '7:45 AM',
  ),
  Stop(
    id: 1,
    name: 'Allah Ho Chowk',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:00 AM',
    timeReached: '7:55 AM',
  ),
  Stop(
    id: 1,
    name: 'University of Central Punjab',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:05 AM',
    timeReached: '8:10 AM',
  ),
  Stop(
    id: 1,
    name: 'Rehman Chowk',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:15 AM',
    timeReached: '8:20 AM',
  ),
  Stop(
    id: 1,
    name: 'COMSATS',
    longitude: 123.4222,
    latitude: 4556.32,
    timeToReach: '8:20 AM',
    timeReached: '8:25 AM',
  ),
];
