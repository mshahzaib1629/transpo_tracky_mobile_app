import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

// // collection reference
final CollectionReference trackingCollection =
    Firestore.instance.collection('trackings');

class FirebaseHelper {
  static Future<void> updateDriverLocation(
      String trackingKey, LocationData location) async {
    try {
      final uid = Uuid().v1();
      await trackingCollection
          .document(trackingKey)
          .setData({'lat': location.latitude, 'lng': location.longitude});
    } catch (error) {
      throw error;
    }
  }

  static Stream<DocumentSnapshot> getDriverLocation(String mapTraceKey) {
    return trackingCollection.document(mapTraceKey).snapshots();
  }
}
