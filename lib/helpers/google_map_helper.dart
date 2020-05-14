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
    try{
      LatLng placeLatLng;
      final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_API_KEY';
      final http.Response response = await http.get(url).timeout(requestTimeout);
      final dataFetched = json.decode(response.body)['result'];
      placeLatLng = LatLng(dataFetched['geometry']['location']['lat'], dataFetched['geometry']['location']['lng']);
      return placeLatLng;
    }catch(error) {
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

  static Future<void> updateDriverLocation(String trackingKey, LocationData location) async {
    try {
      var url =
          "https://transpo-tracky.firebaseio.com/trackings/$trackingKey.json";
      await http.post(url,
          body: json.encode({
            'lat': location.latitude,
            'lng': location.longitude
          })).timeout(requestTimeout);
    } catch (error) {
      throw error;
    }
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


