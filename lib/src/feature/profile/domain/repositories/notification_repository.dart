import 'package:ai_transport/src/feature/home/data/data_sources/vehicle_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/vehicle_entity.dart';
import 'package:ai_transport/src/feature/home/data/models/vehicle_model.dart';

import '../../data/data_source/notification_data_source.dart';
import '../../data/models/notification_model.dart';
import '../entity/notification_entity.dart';

class NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepository(this.dataSource);

  Future<List<NotificationEntity>> registerNotification() async {
    try {
      final List<NotificationModel> models = await dataSource.getNotifications();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readNotification(int notificationId) async {
    try {
      final bool result = await dataSource.readNotification(notificationId);
      return result;
    } catch (e) {
      rethrow;
    }
  }

// Future<List<NotificationEntity>> getNotifications() async {
//   try {
//     final List<NotificationModel> models = await dataSource.getNotifications();
//     return models.map((model) => model.toEntity()).toList();
//   } catch (e) {
//     rethrow;
//   }
// }
}
