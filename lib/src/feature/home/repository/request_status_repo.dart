import 'package:ai_transport/src/feature/home/data/data_sources/request_status_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_status_entity.dart';

abstract class RequestStatusRepository {
  Future<List<RequestStatusEntity>> getRequestStatuses();
  Future<RequestStatusEntity> acceptRequest(int requestId);
  Future<RequestStatusEntity> cancelAcceptance(int requestId);
}

class RequestStatusRepositoryImpl implements RequestStatusRepository {
  final RequestStatusDataSource dataSource;

  RequestStatusRepositoryImpl({required this.dataSource});

  @override
  Future<List<RequestStatusEntity>> getRequestStatuses() async {
    final models = await dataSource.getRequestStatuses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<RequestStatusEntity> acceptRequest(int requestId) async {
    final model = await dataSource.acceptRequest(requestId);
    return model.toEntity();
  }

  @override
  Future<RequestStatusEntity> cancelAcceptance(int requestId) async {
    final model = await dataSource.cancelAcceptance(requestId);
    return model.toEntity();
  }
}
