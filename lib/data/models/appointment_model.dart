// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppointmentModel {
  String id;
  String schedule_id;
  String uid;
  String? review_id;
  String? message;
  AppointmentStatus status;

  AppointmentModel({
    required this.id,
    required this.schedule_id,
    required this.uid,
    this.review_id,
    this.message,
    required this.status,
  });

  AppointmentModel.fromMap(Map<Object?, Object?> map): 
  this(
    id: map['id'] as String,
    schedule_id: map['schedule_id'] as String,
    uid: map['uid'] as String,
    review_id: map['review_id'] as String?,
    message: map['message'] as String?,
    status: AppointmentStatus.values.byName(map['status'] as String)
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'schedule_id': schedule_id,
      'uid': uid,
      'review_id': review_id,
      'message': message,
      'status': status.name
    };
  }
}

enum AppointmentStatus {
  done,
  pending,
  expired
}