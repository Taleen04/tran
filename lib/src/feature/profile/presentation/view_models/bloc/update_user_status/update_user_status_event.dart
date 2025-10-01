
import 'package:equatable/equatable.dart';

sealed class UpdateUserStatusEvent extends Equatable {
  const UpdateUserStatusEvent();

  @override
  List<Object> get props => [];
}

// Event لتحديث حالة المستخدم
class UpdateUserStatusRequested extends UpdateUserStatusEvent {
       // توكن المستخدم
  final bool isOnline; 
  final bool onlineStatus;
       // true -> Online, false -> Offline

  const UpdateUserStatusRequested({
   required this.onlineStatus,
    required this.isOnline,
  });

  @override
  List<Object> get props => [isOnline];
}
