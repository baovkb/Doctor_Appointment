import 'package:doctor_appointment/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:doctor_appointment/data/datasources/remote/doctor_remote_datasource.dart';
import 'package:doctor_appointment/data/datasources/remote/location_remote_datasource.dart';
import 'package:doctor_appointment/data/datasources/remote/review_remote_datasource.dart';
import 'package:doctor_appointment/data/datasources/remote/schedule_remote_datasource.dart';
import 'package:doctor_appointment/data/datasources/remote/specialist_remote_datasource.dart';
import 'package:doctor_appointment/data/datasources/remote/user_remote_datasource.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:doctor_appointment/data/repositories/appointment_repository.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/location_repository.dart';
import 'package:doctor_appointment/data/repositories/review_repository.dart';
import 'package:doctor_appointment/data/repositories/schedule_repository.dart';
import 'package:doctor_appointment/data/repositories/specialist_repository.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final GetIt locator = GetIt.instance;

configDependencies(Box<UserModel> box) async {
  locator.registerSingleton<Box<UserModel>>(box);

  locator.registerLazySingleton<UserRemoteDatasource>(() => UserRemoteDatasource());
  locator.registerLazySingleton<AppointmentRemoteDatasource>(() => AppointmentRemoteDatasource());
  locator.registerLazySingleton<DoctorRemoteDatasource>(() => DoctorRemoteDatasource());
  locator.registerLazySingleton<LocationRemoteDatasource>(() => LocationRemoteDatasource());
  locator.registerLazySingleton<ReviewRemoteDatasource>(() => ReviewRemoteDatasource());
  locator.registerLazySingleton<ScheduleRemoteDatasource>(() => ScheduleRemoteDatasource());
  locator.registerLazySingleton<SpecialistRemoteDatasource>(() => SpecialistRemoteDatasource());

  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<AppointmentRepository>(() => AppointmentRepository());
  locator.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  locator.registerLazySingleton<LocationRepository>(() => LocationRepository());
  locator.registerLazySingleton<ReviewRepository>(() => ReviewRepository());
  locator.registerLazySingleton<ScheduleRepository>(() => ScheduleRepository());
  locator.registerLazySingleton<SpecialistRepository>(() => SpecialistRepository());
}