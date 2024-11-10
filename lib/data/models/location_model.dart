class LocationModel {
  String id;
  String name;
  String longitude;
  String latitude;
  List<String>? doctor_id;

  LocationModel({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    this.doctor_id,
  });

  LocationModel.fromMap(Map<Object?, Object?> map): 
  this(
    id: map['id'] as String,
    name: map['name'] as String,
    longitude: map['longitude'] as String,
    latitude: map['latitude'] as String,
    doctor_id: (map['doctor_id'] as List<Object?>?)?.cast<String>().toList()
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'doctor_id': doctor_id
    };
  }
}