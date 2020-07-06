import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:transpo_tracky_mobile_app/helpers/server_config.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyBFbTO9skrhisSOPt5AoV5TJU4LpqlFbW0';

class MapHelper {
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

  static Future<LatLng> getPlaceLatLng(String placeId) async {
    try {
      LatLng placeLatLng;
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_API_KEY';
      final http.Response response =
          await http.get(url).timeout(requestTimeout);
      final dataFetched = json.decode(response.body)['result'];
      placeLatLng = LatLng(dataFetched['geometry']['location']['lat'],
          dataFetched['geometry']['location']['lng']);
      return placeLatLng;
    } catch (error) {
      throw error;
    }
  }

  static Future<List> getLocationAutoFills(String input) async {
    if (input.isEmpty) {
      return [];
    }
    try {
      final baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      final components = 'country:pk';
      // TODO Add session token
      print('location auto-fill api called');
      final request =
          '$baseURL?input=$input&key=$GOOGLE_API_KEY&components=$components';
      final response = await http.get(request).timeout(requestTimeout);
      final predictions = json.decode(response.body)['predictions'];
      return predictions;
    } catch (error) {
      throw error;
    }
  }

  static Future<void> updateDriverLocation(
      String trackingKey, LocationData location) async {
    try {
      var url =
          "https://transpo-tracky.firebaseio.com/trackings/$trackingKey.json";
      await http
          .post(url,
              body: json.encode(
                  {'lat': location.latitude, 'lng': location.longitude}))
          .timeout(requestTimeout);
    } catch (error) {
      throw error;
    }
  }

  // under testing mode
  static Future<dynamic> getDirections(
      LocationData currentPosition, Stop nextStop) async {
    try {
      final baseURL = 'https://maps.googleapis.com/maps/api/directions/json';
      print('directions api called');
      final request =
          '$baseURL?origin=${currentPosition.latitude},${currentPosition.longitude}&destination=${nextStop.latitude},${nextStop.longitude}&key=$GOOGLE_API_KEY';
      final response = await http.get(request).timeout(requestTimeout);
      final routeData = json.decode(response.body);
      return routeData;
    } catch (error) {
      print(error);
    }
  }

  // This function converts the decoded list of points received from Google's Directions API
  static List<LatLng> convertToLatLng(String poly) {
    List points = decodePoly(poly);
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // This function decodes the string recevied from the Google's Directions API into the list of decimal points
  static List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    return lList;
  }

  static String generateMapPreviewImage({List<Stop> stopList}) {
    String stopListGenerated = _generateStopListString(stopList);
    return 'https://maps.googleapis.com/maps/api/staticmap?&size=600x300&maptype=roadmap&$stopListGenerated&key=$GOOGLE_API_KEY';
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
