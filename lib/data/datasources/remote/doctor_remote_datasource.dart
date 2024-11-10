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
}