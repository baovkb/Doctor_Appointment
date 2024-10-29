import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/specialist_remote_datasource.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';

class SpecialistRepository {
  late final SpecialistRemoteDatasource _datasource;

  SpecialistRepository() {
    _datasource = locator.get<SpecialistRemoteDatasource>();
  }

  Future<Either<Failure, SpecialistModel>> getSpecialistById(String id) async {
    try {
      SpecialistModel? specialist = await _datasource.getSpecialistByID(id);
      return specialist == null ? Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(specialist);
    } catch (e) {
      return Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, List<SpecialistModel>>> getSpecialists() async {
    try {
      List<SpecialistModel>? specList = await _datasource.getSpecialists();
      return specList == null ? Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(specList);
    } catch (e) {
      return Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }
}