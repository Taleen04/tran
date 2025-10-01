import 'package:ai_transport/src/feature/home/data/data_sources/request_status_update_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_status_update_entity.dart';

abstract class RequestStatusUpdateRepository {
  RequestStatusUpdateRepository(RequestStatusUpdateDataSource requestStatusUpdateDataSource);

  Future<RequestStatusUpdateEntity> updateRequestStatus({
    required int requestId,
    required RequestStatus status,
    String? currentLocation,
    String? notes,
  });
}

class RequestStatusUpdateRepositoryImpl implements RequestStatusUpdateRepository {
  final RequestStatusUpdateDataSource dataSource;

  RequestStatusUpdateRepositoryImpl({required this.dataSource});

  @override
  Future<RequestStatusUpdateEntity> updateRequestStatus({
    required int requestId,
    required RequestStatus status,
    String? currentLocation,
    String? notes,
  }) async {
    final model = await dataSource.updateRequestStatus(
      requestId: requestId,
      status: status,
      currentLocation: currentLocation,
      notes: notes,
    );
    return model.toEntity();
  }
}
