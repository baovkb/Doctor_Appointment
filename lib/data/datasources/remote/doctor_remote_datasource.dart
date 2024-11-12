import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DoctorRemoteDatasource {
  late final DatabaseReference _doctorRef;

  DoctorRemoteDatasource () {
    _doctorRef = FirebaseDatabase.instance.ref('Doctor');
  }

  Future<DoctorModel?> getDoctorByID(String id) async {
    DataSnapshot snapshot = await _doctorRef.child(id).get();
    
    if (!snapshot.exists || snapshot.value == null) return null;
    return DoctorModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }

  Future<List<DoctorModel>?> getDoctors() async {
    DataSnapshot snapshot = await _doctorRef.get();
    if (!snapshot.exists || snapshot.value == null) return null;
    return (snapshot.value as Map<Object?, Object?>).values
      .map((mapDoc) => DoctorModel.fromMap(mapDoc as Map<Object?, Object?>))
      .toList();
  }

  Future<void> updateDoctor({
    required String id,
    String? name,
    String? description,
    String? photoURL,
    double? star,
    String? location_id,
    String? specialist_id,
    List<String>? schedule_id,
    List<String>? chat_id,
  }) {
    Map<String, dynamic> newVal = {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (photoURL != null) 'photoURL': photoURL,
      if (star != null) 'star': star,
      if (location_id != null) 'location_id': location_id,
      if (specialist_id != null) 'specialist_id': specialist_id,
      if (schedule_id != null) 'schedule_id': schedule_id,
      if (chat_id != null) 'chat_id': chat_id
    };
    return _doctorRef.child(id).update(newVal);
  }
}