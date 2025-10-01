import 'dart:developer';

import 'package:ai_transport/src/feature/auth/data/data_sources/auth_data_source.dart';
import 'package:ai_transport/src/feature/auth/domain/entites/login_res_entity.dart';
import 'package:ai_transport/src/feature/auth/domain/entites/logout_res_entity.dart';
import 'package:ai_transport/src/feature/auth/domain/entites/update_password_entity.dart';

class AuthRepository {
  final AuthDataSource dataSource;

  AuthRepository(this.dataSource);

  Future<LoginResponseEntity> login(
    String phone,
    String password,
    String deviceName,
    context
  ) async {
    // login
    final model = await dataSource.login(phone, password, deviceName,context);
    if (model == null) {
      log("Login failed: empty response");
    }
    return LoginResponseEntity(
      status: model!.status,
      message: model.message,
      staff: model.staff,
      token: model.token,
      tokenType: model.tokenType,
    );
  }

  Future<UpdatePasswordEntity> updatePassword(
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    // update password
    final model = await dataSource.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
    return UpdatePasswordEntity(message: model.message, status: model.status);
  }

  Future<LogoutResponse?> logout(String token) async {
    //logout
    final logoutModel = await dataSource.logout(token);
    if (logoutModel == null) return null;
    return LogoutResponse(
      message: logoutModel.message,
      status: logoutModel.status,
    );
  }
 
}
