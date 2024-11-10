// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable{
  String id;
  String doctor_id;
  String? appointment_id;
  String start_time;
  String end_time;
  double price;

    @override
  // TODO: implement props
  List<Object?> get props => [id, doctor_id, appointment_id, start_time, end_time, price];

  ScheduleModel({
    required this.id,
    required this.doctor_id,
    this.appointment_id,
    required this.start_time,
    required this.end_time,
    required this.price,
  });

  ScheduleModel.fromMap(Map<Object?, Object?> map):
  this(
    id: map['id'] as String,
    doctor_id: map['doctor_id'] as String,
    appointment_id: map['appointment_id'] as String?,
    start_time: map['start_time'] as String,
    end_time: map['end_time'] as String,
    price: (map['price'] as num).toDouble()
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'doctor_id': doctor_id,
      'appointment_id': appointment_id,
      'start_time': start_time,
      'end_time': end_time,
      'price': price
    };
  }
}
