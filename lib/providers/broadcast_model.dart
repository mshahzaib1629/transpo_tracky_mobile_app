import 'package:flutter/cupertino.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';

class BroadCastMessage {
  Driver sender;
  String messageData;
  DateTime datetime;

  BroadCastMessage({this.sender, this.messageData, this.datetime});
}

class BroadCastProvider with ChangeNotifier{
  List<BroadCastMessage> _dummy_broadCastedMessages = [
    BroadCastMessage(
      sender: Driver(
        id: 1,
        registrationID: 'EMP-DR-1',
        firstName: 'Mushtaq',
        lastName: 'Ahmed',
      ),
      datetime: DateTime.now(),
      messageData: 'Hello there! bus will be late today because there is a huge traffic jam on band road, this one is a really big announcment',
    ),
    BroadCastMessage(
      sender: Driver(
        id: 1,
        registrationID: 'EMP-DR-1',
        firstName: 'Mushtaq',
        lastName: 'Ahmed',
      ),
      datetime: DateTime.now(),
      messageData: 'Hello there!',
    ),
    BroadCastMessage(
      sender: Driver(
        id: 1,
        registrationID: 'EMP-DR-1',
        firstName: 'Mushtaq',
        lastName: 'Ahmed',
      ),
      datetime: DateTime.now(),
      messageData: 'Hello there!',
    ),
    
  ];

  List<BroadCastMessage> get broadcastMessages {
    return _dummy_broadCastedMessages;
  }

  Future<void> sendNewMessage({BroadCastMessage message}) async {
    // -----------------------------------------
    // add server logic here
    // -----------------------------------------
    _dummy_broadCastedMessages.insert(0, message);
    notifyListeners();
  }
}
