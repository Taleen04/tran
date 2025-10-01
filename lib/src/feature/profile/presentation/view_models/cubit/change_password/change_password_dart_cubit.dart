import 'package:ai_transport/src/feature/profile/presentation/view_models/cubit/change_password/change_password_dart_state.dart';
import 'package:ai_transport/src/feature/profile/repo/change_password_repo.dart';
import 'package:bloc/bloc.dart';


class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo repo;

  ChangePasswordCubit({required this.repo}) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    try {
      await repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      emit(const ChangePasswordSuccess(message: "Password updated successfully"));
    } catch (e) {
      emit(ChangePasswordFailure(error: e.toString()));
    }
  }
}
