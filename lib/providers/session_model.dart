import 'package:flutter/cupertino.dart';
import '../helpers/constants.dart';

class Session {
  int id;
  String name;

  Session({
    this.id,
    this.name,
  });
}

class SessionProvider with ChangeNotifier {
  Session _currentSession = Constants.dummyCurrentSession;

  Session get currentSession {
    return _currentSession;
  }
}
