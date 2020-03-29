import 'package:flutter/cupertino.dart';

class Session {
  int id;
  String name;

  Session({
    this.id,
    this.name,
  });
}

class SessionProvider with ChangeNotifier {
  Session _dummy_currentSession = Session(id: 1, name: 'Spring-20');

  Session get currentSession {
    return _dummy_currentSession;
  }
}
