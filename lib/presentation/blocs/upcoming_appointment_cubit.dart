// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/core/utils/time_converter.dart';
import 'package:doctor_appointment/data/repositories/appointment_repository.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/location_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';

class UpComingAppointmentCubit extends Cubit<GetUpcomingAppoinmentState> {
  late final UserRepository _userRepository;
  late final AppointmentRepository _appointmentRepository;
  late final ScheduleRepository _scheduleRepository;
  late final DoctorRepository _doctorRepository;
  late final SpecialistRepository _specialistRepository;
  late final LocationRepository _locationRepository;
  
  UpComingAppointmentCubit(): super(GetUpcomingAppointmentInitial()) {
    _userRepository = locator.get<UserRepository>();
    _appointmentRepository = locator.get<AppointmentRepository>();
    _scheduleRepository = locator.get<ScheduleRepository>();
    _doctorRepository = locator.get<DoctorRepository>();
    _specialistRepository = locator.get<SpecialistRepository>();
    _locationRepository = locator.get<LocationRepository>();
  }

  getUpcomingAppointment() async {
    emit(GetUpcomingAppointmentLoading());

    final eitherUser = await _userRepository.getCurrentUser();
    eitherUser.fold(
      (failure) => emit(GetUpcomingAppoinmentFailure(failure.message)), 
      (user) async {
        List<AppointmentModel> appointmentList = [];
        List<ScheduleModel> scheduleList = [];
        List<DoctorModel> doctorList = [];
        List<SpecialistModel> specialistList = [];
        List<LocationModel> locationList = [];

        final futures = user.appointment_id?.map((appm_id) async {
          final eitherApp = await _appointmentRepository.getAppointmentByID(appm_id);
          await eitherApp.fold(
            (failure) => null,
            (appointment) async {
              final eitherSche = await _scheduleRepository.getScheduleByID(appointment.schedule_id);
              await eitherSche.fold(
                (failure) => null,
                (schedule) async {
                  if (TimeConverter.compareTime(schedule.start_time, TimeConverter.getCurrentTime()) <= 0) {
                    return;
                  } 

                  final eitherDoct = await _doctorRepository.getDoctorByID(schedule.doctor_id);
                  await eitherDoct.fold(
                    (failure) => null, 
                    (doctor) async {
                      final eitherSpecFuture = _specialistRepository.getSpecialistById(doctor.specialist_id);
                      final eitherLocFuture = _locationRepository.getLocationByID(doctor.location_id);

                      final results = await Future.wait([eitherSpecFuture, eitherLocFuture]);
                      if (!results.any((result) => result.isLeft())) {
                        final specialist = results[0].fold(
                          (_) => null, 
                          (spec) => spec as SpecialistModel);
                        final location = results[1].fold(
                          (_) => null, 
                          (loc) => loc as LocationModel);

                        appointmentList.add(appointment);
                        scheduleList.add(schedule);
                        doctorList.add(doctor);
                        specialistList.add(specialist!);
                        locationList.add(location!);
                      }
                    }
                  );
                }
              );
            });
        });

        if (futures != null) await Future.wait(futures);
        
        List<List<Object>> arrays = [appointmentList, scheduleList, doctorList, specialistList, locationList];
        List<List<Object>> combined = List.generate(
          appointmentList.length, 
          (i) => arrays.map((array) => array[i]).toList()
        );
        combined.sort((a, b) => TimeConverter.compareTime((a[1] as ScheduleModel).start_time, (b[1] as ScheduleModel).start_time));
        for (int i = 0; i < arrays.length; i++) {
          for (int j = 0; j < arrays[i].length; j++) {
            arrays[i][j] = combined[j][i];
          }
        }

        emit(GetUpcomingAppointmentSuccess(
          appointmentList: appointmentList, 
          scheduleList: scheduleList, 
          doctorList: doctorList, 
          specialistList: specialistList, 
          locationList: locationList));
      }
    );  
  }
}

abstract class GetUpcomingAppoinmentState extends Equatable {
  @override
  List<Object?> get props => [];
}
class GetUpcomingAppointmentInitial extends GetUpcomingAppoinmentState {}
class GetUpcomingAppointmentLoading extends GetUpcomingAppoinmentState {}
class GetUpcomingAppointmentSuccess extends GetUpcomingAppoinmentState {
  final List<AppointmentModel> appointmentList;
  final List<ScheduleModel> scheduleList;
  final List<DoctorModel> doctorList;
  final List<SpecialistModel> specialistList;
  final List<LocationModel> locationList;

  GetUpcomingAppointmentSuccess({
    required this.appointmentList,
    required this.scheduleList,
    required this.doctorList,
    required this.specialistList,
    required this.locationList,
  });

  @override
  List<Object?> get props => [appointmentList, scheduleList, doctorList, specialistList, locationList];
}
class GetUpcomingAppoinmentFailure extends GetUpcomingAppoinmentState {
  final dynamic message;
  GetUpcomingAppoinmentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
