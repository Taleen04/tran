import 'package:ai_transport/src/feature/profile/data/data_source/notification_data_source.dart';
import 'package:ai_transport/src/feature/profile/domain/repositories/notification_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../../../data/models/notification_model.dart';
import '../../../../domain/entity/notification_entity.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository repository;

  NotificationsCubit(this.repository) : super(NotificationsInitial());

  List<NotificationEntity> notifications = [];

  void fetchNotifications() async {
    try {
      emit(GetNotificationsLoading());
      List<NotificationEntity> notifications =
          await repository.registerNotification();
      this.notifications = notifications;
      emit(GetNotificationsSuccess());
    } catch (e) {
      emit(GetNotificationsFailure(error: e.toString()));
    }
  }

  void readNotification(int notificationId) async {
    try {
      emit(ReadNotificationLoading());
      await repository.readNotification(notificationId);
      notifications.removeWhere(
        (notification) => notification.id == notificationId,
      );
      emit(ReadNotificationSuccess());
    } catch (e) {
      emit(ReadNotificationFailure(error: e.toString()));
    }
  }
}
