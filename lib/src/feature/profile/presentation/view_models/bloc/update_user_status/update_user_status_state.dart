
import 'package:equatable/equatable.dart';

sealed class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();

  @override
  List<Object> get props => [];
}

class UpdateUserProfileInitial extends UpdateUserProfileState {}

class UpdateUserProfileLoading extends UpdateUserProfileState {}

class UpdateUserProfileSuccess extends UpdateUserProfileState {
  final bool isOnline;
  final String currentStatus;

  const UpdateUserProfileSuccess({
    required this.isOnline,
    required this.currentStatus,
  });

  @override
  List<Object> get props => [isOnline, currentStatus];
}

class UpdateUserProfileFailure extends UpdateUserProfileState {
  final String message;

  const UpdateUserProfileFailure(this.message);

  @override
  List<Object> get props => [message];
}
