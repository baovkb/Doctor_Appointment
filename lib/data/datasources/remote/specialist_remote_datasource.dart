import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:firebase_database/firebase_database.dart';

class SpecialistRemoteDatasource {
  late final DatabaseReference _specialistRef;

  SpecialistRemoteDatasource() {
    _specialistRef = FirebaseDatabase.instance.ref('Specialist');
  }

  Future<SpecialistModel?> getSpecialistByID(String id) async {
    DataSnapshot snapshot = await _specialistRef.child(id).get();

    if (!snapshot.exists || snapshot.value == null) return null;
    return SpecialistModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }

  Future<List<SpecialistModel>?> getSpecialists() async {
    DataSnapshot snapshot = await _specialistRef.get();
    if (!snapshot.exists || snapshot.value == null) return null;
    return (snapshot.value as Map<Object?, Object?>).values
      .map((mapSpec) => SpecialistModel.fromMap(mapSpec as Map<Object?, Object?>))
      .toList();
  }
}