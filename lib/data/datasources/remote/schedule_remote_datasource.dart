import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ScheduleRemoteDatasource {
  late final DatabaseReference _scheduleRef;

  ScheduleRemoteDatasource() {
    _scheduleRef = FirebaseDatabase.instance.ref('Schedule');
  }

  Future<ScheduleModel?> getScheduleByID(String id) async {
    DataSnapshot snapshot = await _scheduleRef.child(id).get();

    if (!snapshot.exists || snapshot.value == null) return null;
    return ScheduleModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }

  Future<List<ScheduleModel>?> getSchedules() async {
    DataSnapshot snapshot = await _scheduleRef.get();
    
    if (!snapshot.exists || snapshot.value == null) return null;
    return (snapshot.value as Map<Object?, Object?>).values
      .map((mapSche) => ScheduleModel.fromMap(mapSche as Map<Object?, Object?>))
      .toList();
  }

  Future<void> updateSchedule(ScheduleModel schedule) {
    return _scheduleRef.child(schedule.id).update(schedule.toMap());
  }
}