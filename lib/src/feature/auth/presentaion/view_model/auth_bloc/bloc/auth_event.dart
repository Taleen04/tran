part of 'auth_bloc.dart';

@immutable
abstract class LogInEvent {} // Base class


class LogInButtonPressed extends LogInEvent {
  final String phone;
  final String password;
  final String device_name;
  final String fcm;
  final context;

   LogInButtonPressed(this.phone,  this.password, this.device_name,this.fcm,this.context);
}


@immutable
abstract class LogOutEvent {} // Base class for logout events

class LogOutButtonPressed extends LogOutEvent {
  final String token;

  LogOutButtonPressed(this.token);
}

@immutable
abstract class UpdatePasswordEvent {} // Base class for updatePassword events

class UpdatePasswordButtonPressed extends UpdatePasswordEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  UpdatePasswordButtonPressed(this.currentPassword, this.newPassword, this.newPasswordConfirmation);
}