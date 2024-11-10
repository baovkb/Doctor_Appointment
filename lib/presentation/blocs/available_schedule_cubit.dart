import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/location_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';

class AvailableScheduleCubit extends Cubit<ScheduleState>{
  late final ScheduleRepository _scheduleRepository;
  late final DoctorRepository _doctorRepository;
  late final LocationRepository _locationRepository;
  late final SpecialistRepository _specialistRepository;

  AvailableScheduleCubit(): super(ScheduleInitial()) {
    _scheduleRepository = locator.get<ScheduleRepository>();
    _doctorRepository = locator.get<DoctorRepository>();
    _locationRepository = locator.get<LocationRepository>();
    _specialistRepository = locator.get<SpecialistRepository>();
  }

  getAvailableSchedules() async {
    emit(GetAvailableSchedulesLoading());
    final either = await _scheduleRepository.getAvailableSchedules();
    either.fold(
      (failure) => emit(GetAvailableSchedulesFailure(failure.message)), 
      (scheduleValues) async {
        List<DoctorModel> doctorList = [];
        List<LocationModel> locationList = [];
        List<SpecialistModel> specialistList = [];
        List<ScheduleModel> scheduleList = [];

        List<Future> futures = scheduleValues.map((schedule) async {
          final eitherDoc = await _doctorRepository.getDoctorByID(schedule.doctor_id);

          await eitherDoc.fold(
            (failure) => null, 
            (doctor) async {
              final specFuture = _specialistRepository.getSpecialistById(doctor.specialist_id)
                .then((eitherSpec) => 
                  eitherSpec.fold(
                    (failure) => null, 
                    (specialist) => specialist
                  )
                );

              final locFuture = _locationRepository.getLocationByID(doctor.location_id)
                .then((eitherLoc) =>
                  eitherLoc.fold(
                    (failure) => null, 
                    (location) => location
                  )
                );

              final resultsFuture = await Future.wait([specFuture, locFuture]); 
              if (resultsFuture.any((result) => result == null)) return;

              doctorList.add(doctor);
              specialistList.add(resultsFuture[0] as SpecialistModel);
              locationList.add(resultsFuture[1] as LocationModel);
              scheduleList.add(schedule);
            });
        }).toList();

        await Future.wait(futures);
        emit(GetAvailableSchedulesSuccess(scheduleList, doctorList, locationList, specialistList));
      });
  }

  
}

abstract class ScheduleState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ScheduleInitial extends ScheduleState {}
class GetAvailableSchedulesLoading extends ScheduleState {}
class GetAvailableSchedulesSuccess extends ScheduleState {
  final List<ScheduleModel> scheduleList;
  final List<DoctorModel> doctorList;
  final List<LocationModel> locationList;
  final List<SpecialistModel> specialistList;

  GetAvailableSchedulesSuccess(this.scheduleList, this.doctorList, this.locationList, this.specialistList);

  @override
  List<Object?> get props => [scheduleList, doctorList, locationList, specialistList];
}
class GetAvailableSchedulesFailure extends ScheduleState {
  final dynamic message;
  GetAvailableSchedulesFailure(this.message);

  @override
  List<Object?> get props => [message];
}