import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:ai_transport/src/feature/profile/repo/edit_profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileRepository repository;

  EditProfileBloc(this.repository) : super(EditProfileInitial()) {
    //UpdateProfile
    on<UpdateProfile>((event, emit) async {
      emit(EditProfileLoading());
      try {
        final success = await repository.updateProfile(event.updatedUser);
        if (success) {
          emit(EditProfileSuccess());
          
        } else {
          emit(EditProfileFailure('Failed to update profile'));
        }
      } catch (e) {
        emit(EditProfileFailure(e.toString()));
      }
    });
    //UploadProfilePhoto
     on<UploadProfilePhoto>((event, emit) async {
      emit(UploadProfilePhotoLoading());
      try {
        final result = await repository.uploadProfilePhoto(event.imageFile);
        if (result['success'] == true) {
          final photoUrl = result['data']?['photo_url'] ?? '';
          emit(UploadProfilePhotoSuccess(photoUrl));
        } else {
          emit(UploadProfilePhotoFailure(result['message'] ?? 'Upload failed'));
        }
      } catch (e) {
        emit(UploadProfilePhotoFailure(e.toString()));
      }
    });
  }
}
