// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppointmentModel {
  String id;
  String schedule_id;
  String uid;
  String? review_id;
  AppointmentStatus status;

  AppointmentModel({
    required this.id,
    required this.schedule_id,
    required this.uid,
    this.review_id,
    required this.status,
  });

  AppointmentModel.fromMap(Map<Object?, Object?> map): 
  this(
    id: map['id'] as String,
    schedule_id: map['schedule_id'] as String,
    uid: map['uid'] as String,
    review_id: map['review_id'] as String?,
    status: AppointmentStatus.values.byName(map['status'] as String)
  );

  Map<Object?, Object?> toMap(AppointmentModel appointment) {
    return {
      'id': id,
      'schedule_id': schedule_id,
      'uid': uid,
      'review_id': review_id,
      'status': status.name
    };
  }
}

enum AppointmentStatus {
  done,
  pending,
  expired
}