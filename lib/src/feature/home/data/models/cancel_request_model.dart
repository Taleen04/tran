import 'package:ai_transport/src/feature/home/domain/entities/cancel_request_entity.dart';

class CancelRequestResponseModel {
  final String status;
  final String message;
  final CancelRequestModel data;

  const CancelRequestResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CancelRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return CancelRequestResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: CancelRequestModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }

  CancelRequestResponseEntity toEntity() {
    return CancelRequestResponseEntity(
      status: status,
      message: message,
      data: data.toEntity(),
    );
  }
}

class CancelRequestModel {
  final int requestId;
  final String status;
  final DateTime cancelledAt;
  final String reason;
  final int photosUploaded;

  const CancelRequestModel({
    required this.requestId,
    required this.status,
    required this.cancelledAt,
    required this.reason,
    required this.photosUploaded,
  });

  factory CancelRequestModel.fromJson(Map<String, dynamic> json) {
    return CancelRequestModel(
      requestId: json['request_id'] ?? 0,
      status: json['status'] ?? '',
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : DateTime.now(),
      reason: json['reason'] ?? '',
      photosUploaded: json['photos_uploaded'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'status': status,
      'cancelled_at': cancelledAt.toIso8601String(),
      'reason': reason,
      'photos_uploaded': photosUploaded,
    };
  }

  CancelRequestEntity toEntity() {
    return CancelRequestEntity(
      requestId: requestId,
      status: status,
      cancelledAt: cancelledAt,
      reason: reason,
      photosUploaded: photosUploaded,
    );
  }
}
