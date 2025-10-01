


import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_event.dart';
import 'package:ai_transport/src/feature/profile/presentation/view_models/bloc/information_data_profile_bloc/get_user_profile_state.dart';
import 'package:ai_transport/src/feature/profile/repo/user_profile_repo.dart';
import 'package:bloc/bloc.dart';


class GetUserProfileBloc extends Bloc<GetUserProfileEvent, GetUserProfileState> {
  final UserProfileRepo userProfileRepo;

  GetUserProfileBloc(this.userProfileRepo) : super(GetUserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
  FetchUserProfile event,
  Emitter<GetUserProfileState> emit,
) async {
  emit(GetUserProfileLoading());

  try {
    final userProfile = await userProfileRepo.getUserProfile();

    if (userProfile != null) {
      emit(GetUserProfileSuccess(userProfile.copyWith(currentStatus: userProfile.currentStatus.toLowerCase())));
    } else {
      
      emit(GetUserProfileFailure("فشل في جلب بيانات المستخدم"));
    }
  } catch (e) {
     if (e.toString().contains("401") || e.toString().contains("unauthorized")) {
      await SharedPrefHelper.removeData(StorageKeys.token);
      emit(GetUserProfileFailure("انتهت صلاحية الجلسة، الرجاء تسجيل الدخول مرة أخرى"));
    } else {
      emit(GetUserProfileFailure("حدث خطأ أثناء الاتصال بالسيرفر"));
    }
  }
}

}
