import 'package:ai_transport/src/feature/profile/data/data_source/online_status_data_sourse.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/online_status_entity.dart';

import '../data/models/profile_models.dart';
import '../domain/entity/profile_entity.dart';

class OnlineStatusRepo {
  final OnlineStatusDataSource dataSource;

  OnlineStatusRepo({required this.dataSource});

  Future<OnlineStatusEntity> updateOnlineStatus(
    bool onlineStatus,
    bool isOnline,
  ) async {
    final model = await dataSource.updateOnlineStatus(onlineStatus, isOnline);
    return model.toEntity(); 
  }

  Future<OnlineStatusEntity> updateAvailableStatus(
      String availableStatus,

      ) async {
    final model = await dataSource.updateAvailableStatus(availableStatus);
    return model.toEntity();
  }
  Future<StaffProfileEntity> getUserProfile(
      ) async {
    final model = await dataSource.getUserProfile();
    return model.toEntity();
  }
}
