import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final UserRepository _userRepository;

  AuthBloc() : super(AuthInitial()) {
    _userRepository = locator.get<UserRepository>();

    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      var either = await _userRepository.signInWithEmailAndPassword(email: event.email, password: event.password);
      either.fold(
        (failure) {
          emit(AuthFailure(failure.message));
          emit(UnAuth());
        }, 
        (user) => emit(AuthSuccess(user))
      );
    },);

    on<AuthSignUpRequested> ((event, emit) async {
      emit(AuthLoading());
      var either = await _userRepository.signUpWithEmailPassword(
        name: event.name,
        email: event.email, 
        password: event.password);
      either.fold(
        (failure) {
          emit(AuthFailure(failure.message));
          emit(UnAuth());
        }, 
        (user) => emit(AuthSuccess(user))
      );
    },);

    on<AuthSignOutRequested> ((event, emit) {
      emit(AuthLoading());
      _userRepository.signOut();
      emit(UnAuth());
    },);

    on<AuthResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      var either = await _userRepository.sendPasswordResetEmail(event.email);
      either.fold(
        (failure) => emit(AuthFailure(failure.message)), 
        (isSuccess) => emit(AuthResetPasswordSuccess(isSuccess))
      );
    });
  }
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserCredential user;
  AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class AuthFailure extends AuthState {
  final dynamic message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
class UnAuth extends AuthState {}
class AuthResetPasswordSuccess extends AuthState {
  final bool success;
  AuthResetPasswordSuccess(this.success);

  @override
  List<Object?> get props => [success];
}

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? name;

  AuthSignUpRequested({required this.email, required this.password, this.name});

  @override
  List<Object?> get props => [email, password, name];
}
class AuthSignOutRequested extends AuthEvent {}
class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  AuthResetPasswordRequested(this.email);

  @override
  List<Object?> get props => [email];
}