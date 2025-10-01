import 'dart:io';

import 'package:ai_transport/src/feature/profile/domain/entity/profile_entity.dart';


abstract class EditProfileEvent {}

class UpdateProfile extends EditProfileEvent {
  final StaffProfileEntity updatedUser;
  UpdateProfile(this.updatedUser);
}

class UploadProfilePhoto extends EditProfileEvent {
  final File imageFile;

  UploadProfilePhoto(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}
