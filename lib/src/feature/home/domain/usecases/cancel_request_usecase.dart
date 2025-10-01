import 'dart:io';
import 'package:ai_transport/src/core/usecases/usecase.dart';
import 'package:ai_transport/src/feature/home/domain/entities/cancel_request_entity.dart';
import 'package:ai_transport/src/feature/home/repository/cancel_request_repo.dart';

class CancelRequestUseCase implements UseCase<CancelRequestResponseEntity, CancelRequestParams> {
  final CancelRequestRepository _repository;

  CancelRequestUseCase(this._repository);

  @override
  Future<CancelRequestResponseEntity> call(CancelRequestParams params) async {
    return await _repository.cancelRequest(
      requestId: params.requestId,
      evidencePhotos: params.evidencePhotos,
      reason: params.reason,
      notes: params.notes,
    );
  }
}

class CancelRequestParams {
  final int requestId;
  final List<File> evidencePhotos;
  final CancellationReason reason;
  final String? notes;

  const CancelRequestParams({
    required this.requestId,
    required this.evidencePhotos,
    required this.reason,
    this.notes,
  });
}
