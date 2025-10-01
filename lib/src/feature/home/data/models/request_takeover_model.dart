import 'package:ai_transport/src/feature/home/domain/entities/request_takeover_entity.dart';

class RequestTakeoverModel {
  final String status;
  final String message;
  final RequestTakeoverDataModel data;

  const RequestTakeoverModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RequestTakeoverModel.fromJson(Map<String, dynamic> json) {
    return RequestTakeoverModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: RequestTakeoverDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }

  RequestTakeoverEntity toEntity() {
    return RequestTakeoverEntity(
      status: status,
      message: message,
      data: data.toEntity(),
    );
  }
}

class RequestTakeoverDataModel {
  final int requestId;
  final int previousDriver;
  final int newDriver;
  final String reason;

  const RequestTakeoverDataModel({
    required this.requestId,
    required this.previousDriver,
    required this.newDriver,
    required this.reason,
  });

  factory RequestTakeoverDataModel.fromJson(Map<String, dynamic> json) {
    return RequestTakeoverDataModel(
      requestId: json['request_id'] ?? 0,
      previousDriver: json['previous_driver'] ?? 0,
      newDriver: json['new_driver'] ?? 0,
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'previous_driver': previousDriver,
      'new_driver': newDriver,
      'reason': reason,
    };
  }

  RequestTakeoverDataEntity toEntity() {
    return RequestTakeoverDataEntity(
      requestId: requestId,
      previousDriver: previousDriver,
      newDriver: newDriver,
      reason: reason,
    );
  }
}
