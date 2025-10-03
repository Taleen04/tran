import 'dart:developer';

import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/core/utils/snack_bar_helper.dart';
import 'package:ai_transport/src/feature/auth/data/models/login_res_model.dart';
import 'package:ai_transport/src/feature/auth/data/models/logout_res_model.dart';
import 'package:ai_transport/src/feature/auth/data/models/update_password_model.dart';
import 'package:dio/dio.dart';

class AuthDataSource {
  //convert models to json and call api
  Future<LoginResponse?> login(
    String phone, String password, String deviceName, String fcm, context) async {
  final data = {
    'phone': phone,
    'password': password,
    'device_name': deviceName,
    "fcm" : fcm
  };

  try {
    final res = await ApiClient.dio.post(ApiConstants.login, data: data);
    log("Raw response: ${res.data}");

    if (res.statusCode == 200) {
      final loginRes = LoginResponse.fromJson(res.data);
      return loginRes;
    } else {
      final message = res.data['message'] ?? 'فشل تسجيل الدخول';
      log('Login failed: ${res.statusCode} - $message');
      SnackbarUtils.showError(context, message);
      return null;
    }
  } on DioException catch (e) {
    // التعامل مع خطأ الـ API أو الرسائل من السيرفر
    final message = e.response?.data['message'] ?? 'حدث خطأ ما';
    log('Dio error during login: $message');
    SnackbarUtils.showError(context, message);
    return null;
  } catch (e) {
    log('Unexpected error during login: $e');
    SnackbarUtils.showError(context, 'حدث خطأ ما');
    return null;
  }
}

Future<UpdatePasswordModel> updatePassword( {
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = SharedPrefHelper.getString(StorageKeys.token);
  
    if (token.isEmpty) {
      log('Error: Token is missing');
      return UpdatePasswordModel(message: 'User not authenticated', status: false);
    }

    final data = {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };

    try {
      final res = await ApiClient.dio.post(
        ApiConstants.updatePassword,
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.statusCode == 200) {
        log('Password updated successfully');
        return UpdatePasswordModel.fromJson(res.data);
      } else {
        log('Update password failed: ${res.statusCode}');
        return UpdatePasswordModel(message: 'Failed', status: false);
      }
    } catch (e) {
      log('Error during update password: $e');
      return UpdatePasswordModel(message: 'Error', status: false);
    }
  }

  Future<LogoutResponseModel?> logout(String token) async {
    try {
      final logoutRes = await ApiClient.dio.get(
        ApiConstants.logout,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (logoutRes.statusCode == 200) {
        return LogoutResponseModel.fromJson(logoutRes.data);
      } else {
        log('logout failed: ${logoutRes.statusCode}');
        return null;
      }
    } on Exception catch (e) {
      log('Error during login: $e');
      return null;
    }
  }

}
