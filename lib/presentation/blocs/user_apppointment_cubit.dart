// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/data/repositories/appointment_repository.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/user_model.dart';

class UserAppointmentCubit extends Cubit<UserAppointmentState> {
  late final UserRepository _userRepository;
  late final AppointmentRepository _appointmentRepository;
  late final ScheduleRepository _scheduleRepository;
  late final DoctorRepository _doctorRepository;
  late final SpecialistRepository _specialistRepository;

  UserAppointmentCubit() : super(UserAppointmentInitial()) {
    _userRepository = locator.get<UserRepository>();
    _appointmentRepository = locator.get<AppointmentRepository>();
    _scheduleRepository = locator.get<ScheduleRepository>();
    _doctorRepository = locator.get<DoctorRepository>();
    _specialistRepository = locator.get<SpecialistRepository>();
  }

  Future<void> _getAppm(
    String appointment_id, 
    List<AppointmentModel> appointmentList,
    List<ScheduleModel> scheduleList,
    List<DoctorModel> doctorList,
    List<SpecialistModel> specialistList) async {
      final eitherAppm = await _appointmentRepository.getAppointmentByID(appointment_id);
      await eitherAppm.fold(
        (failure) => null, 
        (appointment) async {
          final eitherSche = await _scheduleRepository.getScheduleByID(appointment.schedule_id);
          await eitherSche.fold(
            (failure) => null,
            (schedule) async {
              final eitherDoct = await _doctorRepository.getDoctorByID(schedule.doctor_id);
              await eitherDoct.fold(
                (failure) => null, 
                (doctor) async {
                  final eitherSpec = await _specialistRepository.getSpecialistById(doctor.specialist_id);
                  eitherSpec.fold(
                    (failure) => null, 
                    (sepcialist) {
                      appointmentList.add(appointment);
                      scheduleList.add(schedule);
                      doctorList.add(doctor);
                      specialistList.add(sepcialist);
                    }
                  );
                }
              );
            }
          );
        });
  }

  getUserAppointment() async {
    emit(UserAppointmentLoading());
    final eitherUser = await _userRepository.getCurrentUser();
    eitherUser.fold(
      (failure) => emit(UserAppointmentFailure(failure.message)), 
      (user) async {
        List<AppointmentModel> appointmentList = [];
        List<ScheduleModel> scheduleList = [];
        List<DoctorModel> doctorList = [];
        List<SpecialistModel> specialistList = [];

        List<Future<void>>? futures = user.appointment_id?.map((id) => _getAppm(id, appointmentList, scheduleList, doctorList, specialistList)).toList();

        if (futures != null) await Future.wait(futures);
        emit(UserAppointmentSuccess(
          user: user, 
          appointmentList: appointmentList, 
          scheduleList: scheduleList, 
          doctorList: doctorList,
          specialistList: specialistList));
      });
  }
}

abstract class UserAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}
class UserAppointmentInitial extends UserAppointmentState {}
class UserAppointmentLoading extends UserAppointmentState {}
class UserAppointmentSuccess extends UserAppointmentState {
  final UserModel user;
  final List<AppointmentModel> appointmentList;
  final List<ScheduleModel> scheduleList;
  final List<DoctorModel> doctorList;
  final List<SpecialistModel> specialistList;

  UserAppointmentSuccess({
    required this.user,
    required this.appointmentList,
    required this.scheduleList,
    required this.doctorList,
    required this.specialistList
  });

  @override
  List<Object?> get props => [user, appointmentList, scheduleList, doctorList, specialistList];
  
}
class UserAppointmentFailure extends UserAppointmentState {
  final dynamic message;
  UserAppointmentFailure(this.message);
}
