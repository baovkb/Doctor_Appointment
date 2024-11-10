import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/core/utils/time_converter.dart';
import 'package:doctor_appointment/data/datasources/remote/schedule_remote_datasource.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';

class ScheduleRepository {
  late final ScheduleRemoteDatasource _datasource;
  
  ScheduleRepository() {
    _datasource = locator.get<ScheduleRemoteDatasource>();
  }

  Future<Either<Failure, ScheduleModel>> getScheduleByID(String id) async {
    try {
      ScheduleModel? schedule = await _datasource.getScheduleByID(id);
      return schedule == null ? Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(schedule);
    } catch (e) {
      return Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, List<ScheduleModel>>> getAvailableSchedules() async {
    try {
      List<ScheduleModel>? scheduleList = await _datasource.getSchedules();
      if (scheduleList == null) return Left(DataNotFoundFailure(AppStrings.dataNotFound));

      final result = scheduleList.where((schedule) => 
        schedule.appointment_id == null 
        && TimeConverter.compareTime(schedule.start_time, TimeConverter.getCurrentTime()) > 0).toList();
      return Right(result);
    } catch (e) {
      return Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, void>> updateSchedule(ScheduleModel schedule) async {
    try {
      await _datasource.updateSchedule(schedule);
      return Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}