import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:doctor_appointment/data/models/appointment_model.dart';

class AppointmentRepository {
  late final AppointmentRemoteDatasource _datasource;

  AppointmentRepository() {
    _datasource = locator.get<AppointmentRemoteDatasource>();
  }

  Future<Either<Failure, AppointmentModel>> getAppointmentByID(String id) async {
    try {
      AppointmentModel? appointment = await _datasource.getAppointmentByID(id);
      return appointment == null ? const Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(appointment);
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, AppointmentModel>> addAppointment ({
    required String schedule_id, 
    required String uid, 
    String? message,
    required AppointmentStatus status}) async {
      try {
        final appointment = await _datasource.addAppointment(
          schedule_id: schedule_id, 
          uid: uid, 
          message: message, 
          status: status
        );
        return Right(appointment);
      } catch (e) {
        return const Left(UnexpectedFailure(AppStrings.unexpectedError));
      }
    }
}
