import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:firebase_database/firebase_database.dart';

class LocationRemoteDatasource {
  late final DatabaseReference _locationRef;

  LocationRemoteDatasource() {
    _locationRef = FirebaseDatabase.instance.ref('Location');
  }

  Future<LocationModel?> getLocationByID(String id) async {
    DataSnapshot snapshot = await _locationRef.child(id).get();

    if (!snapshot.exists || snapshot.value == null) return null;
    return LocationModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }
}