import 'package:ai_transport/src/feature/home/data/data_sources/request_takeover_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_takeover_entity.dart';

abstract class RequestTakeoverRepository {
  Future<RequestTakeoverEntity> takeoverRequest({
    required int requestId,
    required String reason,
  });
}

class RequestTakeoverRepositoryImpl implements RequestTakeoverRepository {
  final RequestTakeoverDataSource dataSource;

  RequestTakeoverRepositoryImpl({required this.dataSource});

  @override
  Future<RequestTakeoverEntity> takeoverRequest({
    required int requestId,
    required String reason,
  }) async {
    final model = await dataSource.takeoverRequest(
      requestId: requestId,
      reason: reason,
    );
    return model.toEntity();
  }
}
