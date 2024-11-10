import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/core/utils/time_converter.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulesByIDsCubit extends Cubit<GetSchedulesByIDsState> {
  late final ScheduleRepository _scheduleRepository;

  SchedulesByIDsCubit(): super(GetAvailableSchedulesByIDsInitial()) {
    _scheduleRepository = locator.get<ScheduleRepository>();
  }

  getAvailableSchedulesByIDs(List<String> schedule_id) async {
    emit(GetAvailableSchedulesByIDsLoading());
    final scheFutures = schedule_id.map(
      (sche_id) => _scheduleRepository.getScheduleByID(sche_id)
        .then((either) => either.fold((failure) => null, (sche) => sche)));
    final results = await Future.wait(scheFutures);

    final schedules = results.where((result) => result != null
      && result.appointment_id == null 
      && TimeConverter.compareTime(result.start_time, TimeConverter.getCurrentTime()) > 0)
    .cast<ScheduleModel>()
    .toList();

    schedules.sort((a, b) => TimeConverter.compareTime(a.start_time, b.start_time));
    emit(GetAvailableSchedulesByIDsSuccess(schedules));
  }
}

abstract class GetSchedulesByIDsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetAvailableSchedulesByIDsInitial extends GetSchedulesByIDsState {}
class GetAvailableSchedulesByIDsLoading extends GetSchedulesByIDsState {}
class GetAvailableSchedulesByIDsSuccess extends GetSchedulesByIDsState {
  final List<ScheduleModel> schedules;
  GetAvailableSchedulesByIDsSuccess(this.schedules);

  @override
  // TODO: implement props
  List<Object?> get props => [schedules];
}
class GetAvailableSchedulesByIDsFailure extends GetSchedulesByIDsState {
  final dynamic message;
  GetAvailableSchedulesByIDsFailure(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}