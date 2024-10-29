import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  final dynamic message;
  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message]);
}

class FileFailure extends Failure {
  const FileFailure([super.message]);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message]);
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure([super.message]);
}