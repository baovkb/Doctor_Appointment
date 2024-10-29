import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:firebase_database/firebase_database.dart';

class AppointmentRemoteDatasource {
  late final DatabaseReference _appointmentRef;

  AppointmentRemoteDatasource() {
    _appointmentRef = FirebaseDatabase.instance.ref('Appointment');
  }

  Future<AppointmentModel?> getAppointmentByID(String id) async {
    DataSnapshot snapshot = await _appointmentRef.child(id).get();
    if (!snapshot.exists || snapshot.value == null) return null;

    return AppointmentModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }
}