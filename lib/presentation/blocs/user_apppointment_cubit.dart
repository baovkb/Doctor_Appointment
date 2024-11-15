// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/core/utils/time_converter.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/review_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/data/repositories/appointment_repository.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/location_repository.dart';
import 'package:doctor_appointment/data/repositories/review_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';

class UserAppointmentCubit extends Cubit<UserAppointmentState> {
  late final UserRepository _userRepository;
  late final AppointmentRepository _appointmentRepository;
  late final ScheduleRepository _scheduleRepository;
  late final DoctorRepository _doctorRepository;
  late final SpecialistRepository _specialistRepository;
  late final LocationRepository _locationRepository;
  late final ReviewRepository _reviewRepository;

  UserAppointmentCubit() : super(UserAppointmentInitial()) {
    _userRepository = locator.get<UserRepository>();
    _appointmentRepository = locator.get<AppointmentRepository>();
    _scheduleRepository = locator.get<ScheduleRepository>();
    _doctorRepository = locator.get<DoctorRepository>();
    _specialistRepository = locator.get<SpecialistRepository>();
    _locationRepository = locator.get<LocationRepository>();
    _reviewRepository = locator.get<ReviewRepository>();
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
        List<LocationModel> locationList = [];
        List<ReviewModel?> reviewList = [];

        final futures = user.appointment_id?.map((appm_id) async {
          final eitherApp = await _appointmentRepository.getAppointmentByID(appm_id);
          await eitherApp.fold(
            (failure) => null,
            (appointment) async {
              final reviewFuture = appointment.review_id != null ? _reviewRepository.getReviewByID(appointment.review_id!) : null;

              final eitherSche = await _scheduleRepository.getScheduleByID(appointment.schedule_id);
              await eitherSche.fold(
                (failure) => null,
                (schedule) async {
                  final eitherDoct = await _doctorRepository.getDoctorByID(schedule.doctor_id);
                  await eitherDoct.fold(
                    (failure) => null, 
                    (doctor) async {
                      final eitherSpecFuture = _specialistRepository.getSpecialistById(doctor.specialist_id);
                      final eitherLocFuture = _locationRepository.getLocationByID(doctor.location_id);

                      final results = await Future.wait([eitherSpecFuture, eitherLocFuture, if (reviewFuture != null) reviewFuture]);
                      if (!results.any((result) => result.isLeft())) {
                        final specialist = results[0].fold(
                          (_) => null, 
                          (spec) => spec as SpecialistModel);
                        final location = results[1].fold(
                          (_) => null, 
                          (loc) => loc as LocationModel);
                        final ReviewModel? review = results.length == 3 
                          ? results[2].fold(
                            (_) => null, 
                            (review) => review as ReviewModel)
                          : null;

                        appointmentList.add(appointment);
                        scheduleList.add(schedule);
                        doctorList.add(doctor);
                        specialistList.add(specialist!);
                        locationList.add(location!);
                        reviewList.add(review);
                      }
                    }
                  );
                }
              );
            });
        });

        if (futures != null) await Future.wait(futures);

        //sorty by time - asc
        List<List<dynamic>> arrays = [appointmentList, scheduleList, doctorList, specialistList, locationList, reviewList];
        List<List<dynamic>> combined = List.generate(
          appointmentList.length, 
          (i) => arrays.map((array) => array[i]).toList()
        );
        combined.sort((a, b) => TimeConverter.compareTime((a[1] as ScheduleModel).start_time, (b[1] as ScheduleModel).start_time));

        //divide into upcoming and past
        List<List<dynamic>> pastCombine =[];
        List<List<dynamic>> upcomingCombine = [];
        for (int i = 0; i < combined.length; ++i) {
          if (TimeConverter.compareTime((combined[i][1] as ScheduleModel).start_time, TimeConverter.getCurrentTime()) > 0) {
            upcomingCombine.add(combined[i]);
          } else {
            pastCombine.add(combined[i]);
          }
        }

        final List<Map<String, dynamic>> pastResult = [];
        for (int i = 0; i < pastCombine.length; ++i) {
          pastResult.add({});
          for (int j = 0; j < pastCombine[i].length; ++j) {
            pastResult[i].addAll({'${pastCombine[i][j].runtimeType}': pastCombine[i][j]});
          }
        }

        final List<Map<String, dynamic>> upcomingResult = [];
        for (int i = 0; i < upcomingCombine.length; ++i) {
          upcomingResult.add({});
          for (int j = 0; j < upcomingCombine[i].length; ++j) {
            upcomingResult[i].addAll({'${upcomingCombine[i][j].runtimeType}': upcomingCombine[i][j]});
          }
        }

        emit(UserAppointmentSuccess(
          upcomingAppms: upcomingResult, 
          pastAppms: pastResult));
      }
    );
  }
}

abstract class UserAppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}
class UserAppointmentInitial extends UserAppointmentState {}
class UserAppointmentLoading extends UserAppointmentState {}
class UserAppointmentSuccess extends UserAppointmentState {
  final List<Map<String, dynamic>> upcomingAppms;
  final List<Map<String, dynamic>> pastAppms;

  UserAppointmentSuccess({
    required this.upcomingAppms,
    required this.pastAppms,
  });

  @override
  List<Object?> get props => [upcomingAppms, pastAppms];
  
}
class UserAppointmentFailure extends UserAppointmentState {
  final dynamic message;
  UserAppointmentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
