import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/update_user_status/update_user_status_state.dart';
import 'package:ai_transport/src/feature/profile/repo/user_profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserStatusBloc extends Bloc<UpdateUserStatusEvent, UpdateUserProfileState> {
  final UserProfileRepo userProfileRepo;

  UpdateUserStatusBloc(this.userProfileRepo) : super(UpdateUserProfileInitial()) {
    on<UpdateUserStatusRequested>(_onUpdateUserStatusRequested);
  }

  Future<void> _onUpdateUserStatusRequested(
    UpdateUserStatusRequested event,
    Emitter<UpdateUserProfileState> emit,
  ) async {
    emit(UpdateUserProfileLoading());

    try {
      // تحديث الحالة على السيرفر
      final updatedProfile = await userProfileRepo.updateUserStatus(
      event.onlineStatus?true:false,
      event.isOnline ? true : false,

      );

      // إرسال الحالة الجديدة للـ UI
      emit(UpdateUserProfileSuccess(
        isOnline: event.isOnline,
        currentStatus: updatedProfile!.currentStatus,
      ));
    } catch (e) {
      emit(UpdateUserProfileFailure("فشل في تحديث حالة المستخدم"));
    }
  }
}
