abstract class EditProfileState {}
// EditProfile
class EditProfileInitial extends EditProfileState {}
class EditProfileLoading extends EditProfileState {}
class EditProfileSuccess extends EditProfileState {}
class EditProfileFailure extends EditProfileState {
  final String error;
  EditProfileFailure(this.error);
}

//UploadProfilePhoto
class UploadProfilePhotoLoading extends EditProfileState {}

class UploadProfilePhotoSuccess extends EditProfileState {
  final String photoUrl;
  UploadProfilePhotoSuccess(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}

class UploadProfilePhotoFailure extends EditProfileState {
  final String error;
  UploadProfilePhotoFailure(this.error);

  @override
  List<Object?> get props => [error];
}
