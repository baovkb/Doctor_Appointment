import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/location_remote_datasource.dart';
import 'package:doctor_appointment/data/models/location_model.dart';

class LocationRepository {
  late final LocationRemoteDatasource _datasource;

  LocationRepository() {
    _datasource = locator.get<LocationRemoteDatasource>();
  }

  Future<Either<Failure, LocationModel>> getLocationByID(String id) async {
    try {
      LocationModel? location = await _datasource.getLocationByID(id);
      return location == null ? Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(location);
    } catch (e) {
      return Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
    
  }
}