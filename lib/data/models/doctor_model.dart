class DoctorModel {
  String id;
  String name;
  String? description;
  String? photoURL;
  double star;
  String location_id;
  String specialist_id;
  List<String>? schedule_id;

  DoctorModel({
    required this.id,
    required this.name,
    this.description,
    this.photoURL,
    required this.star,
    required this.location_id,
    required this.specialist_id,
    this.schedule_id,
  });

  DoctorModel.fromMap(Map<Object?, Object?> map): 
    this(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      photoURL: map['photoURL'] as String?,
      star: (map['star'] as double?)??0,
      location_id: map['location_id'] as String,
      specialist_id: map['specialist_id'] as String,
      schedule_id: (map['schedule_id'] as List<Object?>?)?.cast<String>().toList()
    );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': name,
      'photoURL': photoURL,
      'star': star,
      'location_id': location_id,
      'specialist_id': specialist_id,
      'schedule_id': schedule_id
    };
  }
}
