import 'package:ai_transport/src/feature/profile/data/data_source/online_status_data_sourse.dart';
import 'package:ai_transport/src/feature/profile/domain/entity/online_status_entity.dart';

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
}
