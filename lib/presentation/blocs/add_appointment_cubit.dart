import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/repositories/appointment_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAppointmentCubit extends Cubit<AddAppointmentState> {
  late final AppointmentRepository _appointmentRepository;
  late final ScheduleRepository _scheduleRepository;
  late final UserRepository _userRepository;

  AddAppointmentCubit(): super(AddAppointmentInitial()) {
    _appointmentRepository = locator.get<AppointmentRepository>();
    _scheduleRepository = locator.get<ScheduleRepository>();
    _userRepository = locator.get<UserRepository>();
  }

  addAppointment({
    required String schedule_id, 
    required String uid, 
    String? message,
    required AppointmentStatus status}) async {

    emit(AddAppointmentLoading());

    final eitherUserFuture = _userRepository.getCurrentUser(forceUpdate: true);

    final eitherSche = await _scheduleRepository.getScheduleByID(schedule_id);

    eitherSche.fold(
      (failure) => emit(AddAppointmentFailure(failure.message)), 
      (schedule) async {
        if (schedule.appointment_id != null)
          emit(AddAppointmentFailure(AppStrings.bookedAppmError));
        else {
          final either = await _appointmentRepository.addAppointment(
            schedule_id: schedule_id, 
            uid: uid, 
            message: message,
            status: status
          );
          either.fold(
            (failure) => emit(AddAppointmentFailure(failure.message)), 
            (appointment) async {
              //update schedule
              schedule.appointment_id = appointment.id;
              final eitherUpdateScheFuture = _scheduleRepository.updateSchedule(schedule);

              //update user
              final eitherUpdateUserFuture = eitherUserFuture.then<Either<Failure, void>>((either) => either.fold(
                (failure) => Left(failure), 
                (user) {
                  if (user.appointment_id == null)
                    user.appointment_id = [appointment.id];
                  else
                    user.appointment_id!.add(appointment.id);
                  return _userRepository.updateUser(user);
                }));

              final resultsUpdate = await Future.wait([eitherUpdateScheFuture, eitherUpdateUserFuture]);

              if (resultsUpdate.any((result) => result.isLeft())) {
                List<String> msgList = 
                  resultsUpdate
                    .where((element) => element.isLeft())
                    .map<String>((either) => either.fold(
                      (failure) => failure.message, 
                      (_) => "")).toList();

                emit(AddAppointmentFailure(msgList));
              } else {
                emit(AddAppointmentSuccess(appointment));
              }
            }
          );
        }
      });
  }
}

abstract class AddAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AddAppointmentInitial extends AddAppointmentState {}
class AddAppointmentLoading extends AddAppointmentState {}
class AddAppointmentSuccess extends AddAppointmentState {
  final AppointmentModel appointment;
  AddAppointmentSuccess(this.appointment);

  @override
  List<Object?> get props => [appointment];
}
class AddAppointmentFailure extends AddAppointmentState {
  final dynamic message;
  AddAppointmentFailure(this.message);

  @override
  List<Object?> get props => [message];
}