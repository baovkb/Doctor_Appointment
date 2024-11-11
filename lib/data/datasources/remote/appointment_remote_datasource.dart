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

  Future<AppointmentModel> addAppointment({
    required String schedule_id, 
    required String uid, 
    String? message,
    required AppointmentStatus status}) async {
      String key = _appointmentRef.push().key!;
      AppointmentModel appointment = AppointmentModel(
        id: key, 
        schedule_id: schedule_id, 
        uid: uid, 
        message: message,
        status: status
      );

      await _appointmentRef.child(key).set(appointment.toMap());
      return appointment;
  }

  Future<void> updateAppointment({
    required String appointment_id, 
    String? schedule_id, 
    String? uid, 
    String? review_id,
    AppointmentStatus? status}) {
      Map<String, Object?> newVal = {
        if (schedule_id != null) 'schedule_id': schedule_id,
        if (uid != null) 'uid': uid,
        if (review_id != null) 'review_id': review_id,
        if (status != null) 'status': status.name
      };
      return _appointmentRef.child(appointment_id).update(newVal);
  }
}