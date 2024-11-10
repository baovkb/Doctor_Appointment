class ReviewModel {
  String id;
  String appointment_id;
  double star;
  String? review;

  ReviewModel({
    required this.id,
    required this.appointment_id,
    required this.star,
    this.review,
  });

  ReviewModel.fromMap(Map<Object?, Object?> map):
  this(
    id: map['id'] as String,
    appointment_id: map['appointment_id'] as String,
    star: map['star'] as double,
    review: map['review'] as String?
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'appointment_id': appointment_id,
      'star': star,
      'review': review
    };
  }
}
