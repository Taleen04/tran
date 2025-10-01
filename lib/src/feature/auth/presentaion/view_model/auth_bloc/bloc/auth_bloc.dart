import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/feature/auth/presentaion/view_model/auth_bloc/bloc/auth_state.dart';
import 'package:ai_transport/src/feature/auth/repository/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  final AuthRepository authRepo;

  LogInBloc(this.authRepo) : super(LogInInitial()) {
    on<LogInButtonPressed>((event, emit) async {
      emit(LogInLoading());
      try {
        final response = await authRepo.login(event.phone, event.password,event.device_name,event.context);
        await SharedPrefHelper.setData(StorageKeys.token, response.token);
        emit(LogInSuccess(response.staff, response.token)); 
      } catch (e) {
        emit(LogFailure(e.toString()));
      }
    });
  }
}
class LogoutBloc extends Bloc<LogOutEvent, LogoutState> {
  final AuthRepository authRepo;

  LogoutBloc(this.authRepo) : super(LogoutInitial()) {
    on<LogOutButtonPressed>((event, emit) async {
      emit(LogoutLoading());
      try {
        final response = await authRepo.logout(event.token);
        
        emit(LogoutSuccess(response?.message ?? 'Logout successful')); 
      } catch (e) {
        emit(LogoutFailure(e.toString()));
      }
    });
  }
}


class UpdatePassword extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  final AuthRepository authRepo;

  UpdatePassword(this.authRepo) : super(UpdatePasswordInitial()) {
    on<UpdatePasswordButtonPressed>((event, emit) async {
      emit(UpdatePasswordLoading());
      try {
        final response = await authRepo.updatePassword(event.currentPassword, event.newPassword, event.newPasswordConfirmation);
        
        emit(UpdatePasswordSuccess(response.message)); 
      } catch (e) {
        emit(UpdatePasswordFailure(e.toString()));
      }
    });
  }
}

