import 'package:doctor_appointment/data/models/review_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ReviewRemoteDatasource {
  late final DatabaseReference _reviewRef;

  ReviewRemoteDatasource() {
    _reviewRef = FirebaseDatabase.instance.ref('Review');
  }

  Future<ReviewModel?> getReviewByID(String id) async {
    DataSnapshot snapshot = await _reviewRef.child(id).get();

    if (!snapshot.exists || snapshot.value == null) return null;
    return ReviewModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }

  Future<ReviewModel> addReview({
    required String appointment_id, 
    required double star, 
    String? review
    }) async {
      String key = _reviewRef.push().key!;
      ReviewModel reviewModel = ReviewModel(id: key, appointment_id: appointment_id, star: star, review: review);
      await _reviewRef.child(key).set(reviewModel.toMap());
      return reviewModel;
  }
}