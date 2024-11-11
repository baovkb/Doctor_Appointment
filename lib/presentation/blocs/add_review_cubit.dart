// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/repositories/appointment_repository.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/review_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/review_model.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  late final DoctorRepository _doctorRepository;
  late final AppointmentRepository _appointmentRepository;
  late final ScheduleRepository _scheduleRepository;
  late final ReviewRepository _reviewRepository;

  AddReviewCubit(): super(AddReviewInitial()) {
    _doctorRepository = locator.get<DoctorRepository>();
    _appointmentRepository = locator.get<AppointmentRepository>();
    _scheduleRepository = locator.get<ScheduleRepository>();
    _reviewRepository = locator.get<ReviewRepository>();
  }

  addReview({
    required String appointment_id, 
    required double star, 
    required String? review, 
    required String doctor_id}) async {
      final eitherAppm = await _appointmentRepository.getAppointmentByID(appointment_id);
      eitherAppm.fold(
        (failure) => emit(AddReviewFailure(failure.message)), 
        (appointment) async {
          if (appointment.review_id != null) {
            emit(AddReviewFailure(AppStrings.reviewExist));
            return;
          }

          final eitherReview = await _reviewRepository.addReview(
            appointment_id: appointment_id, 
            star: star, 
            review: review);
          eitherReview.fold(
            (failure) => emit(AddReviewFailure(failure.message)), 
            (reviewModel) async {
              final updateAppmEither = await _appointmentRepository.updateAppointment(appointment_id: appointment_id, review_id: reviewModel.id);
              updateAppmEither.fold(
                (failure) => emit(AddReviewFailure(failure.message)), 
                (_) async {
                  appointment.review_id = reviewModel.id;

                  //re-calc a amount of doctor's star
                  final docEither = await _doctorRepository.getDoctorByID(doctor_id);
                  final docResult = docEither.fold(
                    (failure) => null, 
                    (doctor) => doctor);

                  final scheFutures = docResult?.schedule_id?.map(
                    (schedule_id) => _scheduleRepository.getScheduleByID(schedule_id)
                      .then((scheEither) => scheEither.fold((failure) => null, (sche) => sche)));
                  
                  final scheResults = scheFutures != null ? await Future.wait(scheFutures) : null;
                  
                  if (scheResults != null && !scheResults.any((cond) => cond == null)) {
                    final appmFutures = scheResults.where((sche) => sche!.appointment_id != null)
                      .map((schedule) => _appointmentRepository.getAppointmentByID(schedule!.appointment_id!)
                        .then((appmEither) => appmEither.fold((failure) => null, (appm) => appm)));

                    final appmResults = await Future.wait(appmFutures);
                    if (!appmResults.any((cond) => cond == null)) {
                      final reviewFutures = appmResults.where((appm) => appm!.review_id != null)
                        .map((appm) => _reviewRepository.getReviewByID(appm!.review_id!)
                          .then((reviewEither) => reviewEither.fold((failure) => null, (reviewModel) => reviewModel)));

                      final reviewResults = await Future.wait(reviewFutures);
                      double star = 0;
                      int count = 0;
                      reviewResults.forEach((reviewMode) {
                        if (reviewMode != null) {
                          star += reviewMode.star;
                          count++;
                        }
                      });
                      star = star / count;
                      star = double.parse(star.toStringAsFixed(1));

                      docResult!.star = star;
                      _doctorRepository.updateDoctor(id: docResult.id, star: star);
                      emit(AddReviewSuccess(doctor: docResult, appointment: appointment, review: reviewModel));
                    }
                  }
                });
            });
        });
  }
}

abstract class AddReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AddReviewInitial extends AddReviewState {}
class AddReviewLoading extends AddReviewState {}
class AddReviewSuccess extends AddReviewState {
  final DoctorModel doctor;
  final AppointmentModel appointment;
  final ReviewModel review;

  AddReviewSuccess({
    required this.doctor,
    required this.appointment,
    required this.review,
  });
  
  @override
  List<Object?> get props => [doctor, appointment, review];
}
class AddReviewFailure extends AddReviewState {
  final dynamic message;
  AddReviewFailure(this.message);

  @override
  List<Object?> get props => [message];
}