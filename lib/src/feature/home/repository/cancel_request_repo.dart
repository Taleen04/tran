import 'dart:developer';
import 'dart:io';
import 'package:ai_transport/src/feature/home/data/data_sources/cancel_request_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancel_request_entity.dart';

abstract class CancelRequestRepository {
  Future<CancelRequestResponseEntity> cancelRequest({
    required int requestId,
    required List<File> evidencePhotos,
    required CancellationReason reason,
    String? notes,
  });
}

class CancelRequestRepositoryImpl implements CancelRequestRepository {
  final CancelRequestDataSource _dataSource;

  CancelRequestRepositoryImpl(this._dataSource);

  @override
  Future<CancelRequestResponseEntity> cancelRequest({
    required int requestId,
    required List<File> evidencePhotos,
    required CancellationReason reason,
    String? notes,
  }) async {
    try {
      log('[CancelRequestRepository] Cancelling request $requestId with reason: ${reason.value}');
      
      final result = await _dataSource.cancelRequest(
        requestId: requestId,
        evidencePhotos: evidencePhotos,
        reason: reason,
        notes: notes,
      );
      
      log('[CancelRequestRepository] Request cancelled successfully');
      return result;
    } catch (e, stackTrace) {
      log(
        '[CancelRequestRepository] Error cancelling request: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
