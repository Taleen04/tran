part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class GetNotificationsLoading extends NotificationsState {}
class GetNotificationsSuccess extends NotificationsState {}
class GetNotificationsFailure extends NotificationsState {
  final String error ;

  GetNotificationsFailure({required this.error});
}

class ReadAllNotificationsLoading extends NotificationsState {}
class ReadAllNotificationsSuccess extends NotificationsState {}
class ReadAllNotificationsFailure extends NotificationsState {
  final String error ;

  ReadAllNotificationsFailure({required this.error});
}

class ReadNotificationLoading extends NotificationsState {}
class ReadNotificationSuccess extends NotificationsState {}
class ReadNotificationFailure extends NotificationsState {
  final String error ;

  ReadNotificationFailure({required this.error});
}



