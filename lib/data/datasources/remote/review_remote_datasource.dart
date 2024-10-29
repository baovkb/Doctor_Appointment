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
}