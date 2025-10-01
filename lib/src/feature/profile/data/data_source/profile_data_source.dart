import 'dart:developer';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/profile/data/models/profile_models.dart';
class UserProfileDataSource {
  Future<StaffProfileModel?> userProfile() async {
    try {
 
      final res = await ApiClient.dio.get(
        ApiConstants.userProfile,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        if (data is Map) {
          return StaffProfileModel.fromJson(
              Map<String, dynamic>.from(data));
        }
        log('Unexpected response format: ${data.runtimeType}');
        return null;
      } else {
        log('Fetch profile failed: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error during fetch profile: $e');
      return null;
    }
  }
  Future<StaffProfileModel?> updateUserStatus(
  bool onlineStatus,
  bool isOnline
) async {
  final body = {'online_status': onlineStatus,'is_online':isOnline};

  try {
    final res = await ApiClient.dio.patch(
      ApiConstants.onlineStatus,
      data: body,
     
    );

    if (res.statusCode == 200) {
      // تحويل الـ response إلى StaffProfileModel
      return StaffProfileModel.fromJson(res.data);
    } else {
      throw Exception('فشل في تحديث الحالة: ${res.statusCode}');
    }
  } catch (e) {
    log('Failed to update user status: $e');
    rethrow;
  }
}

}
