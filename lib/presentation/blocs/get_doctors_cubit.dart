import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetDoctorsCubit extends Cubit<GetDoctorsState> {
  late final DoctorRepository _doctorRepository;
  late final SpecialistRepository _specialistRepository;

  GetDoctorsCubit(): super(GetDoctorsInitial()) {
    _doctorRepository = locator.get<DoctorRepository>();
    _specialistRepository = locator.get<SpecialistRepository>();
  }

  getDoctors() async {
    final docsEither = await _doctorRepository.getDoctors();
    docsEither.fold(
      (failure) => emit(GetDoctorsFailure(failure.message)), 
      (docs) async {
        final List<String> errors = [];

        final specFutures = docs.map((doc) => _specialistRepository.getSpecialistById(doc.specialist_id)
          .then(((specEither) => specEither.fold(
            (failure) {
              errors.add(failure.message);
              return null;
            }, 
            (spec) => spec))));
        final List<SpecialistModel?> specialistList = await Future.wait(specFutures);
        if (specialistList.any((cond) => cond == null)) {
          emit(GetDoctorsFailure(errors));
        } else {
          emit(GetDoctorsSuccess(docs, specialistList.cast<SpecialistModel>().toList()));
        }
      });
  }
}

abstract class GetDoctorsState extends Equatable {
  @override
  List<Object?> get props => [];
}
class GetDoctorsInitial extends GetDoctorsState {}
class GetDoctorsLoading extends GetDoctorsState {}
class GetDoctorsSuccess extends GetDoctorsState {
  final List<DoctorModel> doctors;
  final List<SpecialistModel> specialists;

  GetDoctorsSuccess(this.doctors, this.specialists);

  @override
  List<Object?> get props => [doctors, specialists];
}
class GetDoctorsFailure extends GetDoctorsState {
  final dynamic message;

  GetDoctorsFailure(this.message);

  @override
  List<Object?> get props => [message];
}