import 'dart:developer';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/profile/data/models/profile_models.dart';
import 'package:dio/dio.dart';

import '../../../../../main.dart';
import '../../../../core/database/cache/shared_pref_helper.dart';
import '../models/notification_model.dart';
class NotificationDataSource {
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await ApiClient.dio.get(
        ApiConstants.notifications,
        queryParameters: {
          "unread_only" : true
        }
      );

      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data["data"]['notifications'] ?? [];
        return notificationsData
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();
      } else {
        throw Exception('Failed to get notifications: ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readNotification(int notificationId) async {
    try {
      final response = await ApiClient.dio.post(
        ApiConstants.readNotification(notificationId),

      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to get notifications: ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

}
