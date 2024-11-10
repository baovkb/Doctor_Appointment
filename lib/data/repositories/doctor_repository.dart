import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/doctor_remote_datasource.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';

class DoctorRepository {
  late final DoctorRemoteDatasource _datasource;

  DoctorRepository() {
    _datasource = locator.get<DoctorRemoteDatasource>();
  }

  Future<Either<Failure, DoctorModel>> getDoctorByID(String id) async {
    try {
      DoctorModel? doctor =  await _datasource.getDoctorByID(id);
      return doctor == null ? const Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(doctor);
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, List<DoctorModel>>> searchDoctorByName(String name) async {
    try {
      List<DoctorModel>? doctorList = await _datasource.getDoctors();
      if (doctorList == null) return const Left(DataNotFoundFailure(AppStrings.dataNotFound));

      List<DoctorModel> results = doctorList.where((doctor) => doctor.name.toLowerCase().contains(name)).toList();
      return Right(results);
      
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }
}