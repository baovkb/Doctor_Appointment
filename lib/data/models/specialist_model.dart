// ignore_for_file: public_member_api_docs, sort_constructors_first
class SpecialistModel {
  String id;
  String name;
  List<String>? doctor_id;

  SpecialistModel({
    required this.id,
    required this.name,
    this.doctor_id,
  });

  SpecialistModel.fromMap(Map<Object?, Object?> map): 
  this(
    id: map['id'] as String,
    name: map['name'] as String,
    doctor_id: (map['doctor_id'] as List<Object?>?)?.cast<String>().toList()
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'doctor_id': doctor_id
    };
  }
}
