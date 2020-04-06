import 'dart:convert';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyBFbTO9skrhisSOPt5AoV5TJU4LpqlFbW0';

class MapHelper {
  static String generateMapPreviewImage({List<Stop> stopList}) {
    String stopListGenerated = _generateStopListString(stopList);
    return 'https://maps.googleapis.com/maps/api/staticmap?&size=600x300&maptype=roadmap&$stopListGenerated&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
      final response = await http.get(url).timeout(requestTimeout);
      return json.decode(response.body)['results'][0]['formatted_address'];
    } catch (error) {
      throw error;
    }
  }
}

String _generateStopListString(List<Stop> stopList) {
  String generatedString = '';
  for (int i = 0; i < stopList.length; i++) {
    if (i != 0) generatedString = generatedString + '&';
    generatedString = generatedString +
        'markers=color:${i == stopList.length - 1 ? "green" : "red"}%7Clabel:${i + 1}%7C${stopList[i].latitude},${stopList[i].longitude}';
  }
  return generatedString;
}
