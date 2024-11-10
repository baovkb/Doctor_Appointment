import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/location_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleSearchCubit extends Cubit<GetAvailableScheduleByKeywordState>{
  late final ScheduleRepository _scheduleRepository;
  late final DoctorRepository _doctorRepository;
  late final LocationRepository _locationRepository;
  late final SpecialistRepository _specialistRepository;
  
  ScheduleSearchCubit(): super(GetAvailableSchedulesByKeywordInitial()) {
    _scheduleRepository = locator.get<ScheduleRepository>();
    _doctorRepository = locator.get<DoctorRepository>();
    _locationRepository = locator.get<LocationRepository>();
    _specialistRepository = locator.get<SpecialistRepository>();
  }

  getAvailabelSchedulesByKeyWord(String keyword) async {
    emit(GetAvailableSchedulesByKeywordLoading());

    if (keyword.isEmpty) {
      emit(GetAvailableSchedulesByKeywordSuccess(
        doctorList: [], 
        scheduleList: [], 
        locationList: [], 
        specialistList: [], 
      ));
      return;
    }

    final eitherSche = await _scheduleRepository.getAvailableSchedules();
    eitherSche.fold(
      (failure) => emit(GetAvailableSchedulesByKeywordFailure(failure.message)), 
      (scheduleList) async {
        List<DoctorModel> doctorList = [];
        List<LocationModel> locationList = [];
        List<SpecialistModel> specialistList = [];
        List<ScheduleModel> resultSchedules = []; 

        List<Future> futures = scheduleList.map((schedule) async {
          final eitherDoc = await _doctorRepository.getDoctorByID(schedule.doctor_id);
          await eitherDoc.fold(
            (failure) => null, 
            (doctor) async {
              final specFuture = _specialistRepository.getSpecialistById(doctor.specialist_id)
                .then((eitherSpec) => eitherSpec.fold(
                  (failure) => null, 
                  (specialist) => specialist));
              final locFuture = _locationRepository.getLocationByID(doctor.location_id)
                .then((eitherLoc) => eitherLoc.fold(
                  (failure) => null, 
                  (location) => location));

              final resultFuture = await Future.wait([specFuture, locFuture]);
              if (resultFuture.any((result) => result == null)) {
                return;
              }    
              if (doctor.name.toLowerCase().contains(keyword)
              || (resultFuture[0] as SpecialistModel).name.toLowerCase().contains(keyword)) {
                doctorList.add(doctor);
                specialistList.add(resultFuture[0] as SpecialistModel);
                locationList.add(resultFuture[1] as LocationModel);
                resultSchedules.add(schedule);
              }
            });
        }).toList();

        await Future.wait(futures);
        emit(GetAvailableSchedulesByKeywordSuccess(
          doctorList: doctorList, 
          scheduleList: resultSchedules, 
          locationList: locationList, 
          specialistList: specialistList, 
        ));
      });
  }
}

abstract class GetAvailableScheduleByKeywordState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAvailableSchedulesByKeywordInitial extends GetAvailableScheduleByKeywordState {}
class GetAvailableSchedulesByKeywordLoading extends GetAvailableScheduleByKeywordState {}
class GetAvailableSchedulesByKeywordSuccess extends GetAvailableScheduleByKeywordState {
  final List<ScheduleModel> scheduleList;
  final List<DoctorModel> doctorList;
  final List<LocationModel> locationList;
  final List<SpecialistModel> specialistList;

  GetAvailableSchedulesByKeywordSuccess({
    required this.scheduleList,
    required this.doctorList,
    required this.locationList,
    required this.specialistList,
  });

  @override
  List<Object?> get props => [scheduleList, doctorList, locationList, specialistList];
}

class GetAvailableSchedulesByKeywordFailure extends GetAvailableScheduleByKeywordState{
  final dynamic message;
  GetAvailableSchedulesByKeywordFailure(this.message);

  @override
  List<Object?> get props => [message];
}