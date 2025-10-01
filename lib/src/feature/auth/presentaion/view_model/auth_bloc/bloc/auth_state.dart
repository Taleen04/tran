
import 'package:ai_transport/src/feature/auth/data/models/staff_model.dart';

abstract class LogInState {}

class LogInInitial extends LogInState {}
class LogInLoading extends LogInState {}
class LogInSuccess extends LogInState {
  final Staff user;
  final String token;
  LogInSuccess(this.user, this.token);
}
class LogFailure extends LogInState {
  final String error;
  LogFailure(this.error);
}

abstract class LogoutState {}
class LogoutInitial extends LogoutState {}
class LogoutLoading extends LogoutState {}
class LogoutSuccess extends LogoutState {
  final String message;
  LogoutSuccess(this.message);
}
class LogoutFailure extends LogoutState {
  final String error;
  LogoutFailure(this.error);
}

abstract class UpdatePasswordState {}
class UpdatePasswordInitial extends UpdatePasswordState {}
class UpdatePasswordLoading extends UpdatePasswordState {}
class UpdatePasswordSuccess extends UpdatePasswordState {
  final String message;
  UpdatePasswordSuccess(this.message);
}
class UpdatePasswordFailure extends UpdatePasswordState {
  final String error;
  UpdatePasswordFailure(this.error);
}

