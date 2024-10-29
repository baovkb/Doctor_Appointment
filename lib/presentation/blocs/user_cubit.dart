// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState>{
  late final UserRepository _userRepository;

  UserCubit(): super(UserInitial()) {
    _userRepository = locator.get<UserRepository>();
  }

  checkEmail(String email) async {
    emit(CheckEmailLoading());
    bool result = await _userRepository.emailExist(email);
    emit(CheckEmailSuccess(result));
  }

  getUserByUID(String uid) async {
    emit(GetUserLoading());
    final either = await _userRepository.getUserByUID(uid);
    either.fold(
      (failure) => emit(GetUserFailure(failure.message)), 
      (user) => emit(GetUserSuccess(user)));
  }

  getCurrentUser({bool forceUpdate = false}) async {
    emit(GetUserLoading());
    final either = await _userRepository.getCurrentUser(forceUpdate: forceUpdate);
    either.fold(
      (failure) => emit(GetUserFailure(failure.message)), 
      (user) => emit(GetUserSuccess(user)));
  }
}

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}
class UserInitial extends UserState {}
class CheckEmailLoading extends UserState {}
class CheckEmailSuccess extends UserState {
  final bool result;
  CheckEmailSuccess(this.result);

  @override
  List<Object?> get props => [result];
}
class CheckEmailFailure extends UserState {
  final dynamic message;
  CheckEmailFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateProfileLoading extends UserState {}
class UpdateProfileSuccess extends UserState {}
class UpdateProfileFalure extends UserState {
  final dynamic message;
  UpdateProfileFalure(this.message);
  @override
  List<Object?> get props => [message];
}

class GetUserLoading extends UserState {}
class GetUserSuccess extends UserState {
  late final UserModel user;
  GetUserSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class GetUserFailure extends UserState {
  late final dynamic message;
  GetUserFailure(this.message);

  @override
  List<Object?> get props => [message];
}
