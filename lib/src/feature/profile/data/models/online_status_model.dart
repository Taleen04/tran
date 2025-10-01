
import 'package:ai_transport/src/feature/profile/domain/entity/online_status_entity.dart';

class OnlineStatusModel extends OnlineStatusEntity {
  OnlineStatusModel({
    required super.isOnline,
    required super.currentStatus,
  });

  factory OnlineStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return OnlineStatusModel(
      isOnline: data['is_online'] ?? false,
      currentStatus: data['current_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'is_online': isOnline,
        'current_status': currentStatus,
      },
    };
  }

  OnlineStatusEntity toEntity() => this;
}
