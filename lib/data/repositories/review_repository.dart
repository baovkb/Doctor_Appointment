import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/review_remote_datasource.dart';
import 'package:doctor_appointment/data/models/review_model.dart';

class ReviewRepository {
  late final ReviewRemoteDatasource _datasource;

  ReviewRepository() {
    _datasource = locator.get<ReviewRemoteDatasource>();
  }

  Future<Either<Failure, ReviewModel>> getReviewByID(String id) async {
    try {
      ReviewModel? review = await _datasource.getReviewByID(id);
      return review == null ? Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(review);
    } catch (e) {
      return Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }
}