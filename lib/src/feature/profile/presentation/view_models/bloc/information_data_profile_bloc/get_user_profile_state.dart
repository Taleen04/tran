import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetUserProfileState extends Equatable {
  const GetUserProfileState();

  @override
  List<Object?> get props => [];
}

class GetUserProfileInitial extends GetUserProfileState {
  const GetUserProfileInitial();
}

class GetUserProfileLoading extends GetUserProfileState {
  const GetUserProfileLoading();
}

class GetUserProfileSuccess extends GetUserProfileState {
  final StaffProfileEntity  userProfile;

  const GetUserProfileSuccess(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class GetUserProfileFailure extends GetUserProfileState {
  final String error;

  const GetUserProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}
