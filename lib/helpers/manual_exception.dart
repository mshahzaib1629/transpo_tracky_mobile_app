import 'package:flutter/foundation.dart';

class ManualException implements Exception {
  String title;
  String message;
  ManualException({this.title, @required this.message});
}
