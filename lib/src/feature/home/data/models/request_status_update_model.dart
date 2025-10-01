import 'package:ai_transport/src/feature/home/domain/entities/request_status_update_entity.dart';

class RequestStatusUpdateModel {
  final String status;
  final String message;
  final RequestStatusDataModel data;

  const RequestStatusUpdateModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RequestStatusUpdateModel.fromJson(Map<String, dynamic> json) {
    return RequestStatusUpdateModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: RequestStatusDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }

  RequestStatusUpdateEntity toEntity() {
    return RequestStatusUpdateEntity(
      status: status,
      message: message,
      data: data.toEntity(),
    );
  }
}

class RequestStatusDataModel {
  final int requestId;
  final String status;
  final String updatedAt;
  final List<String> nextActions;
  final bool proofUploaded;

  const RequestStatusDataModel({
    required this.requestId,
    required this.status,
    required this.updatedAt,
    required this.nextActions,
    required this.proofUploaded,
  });

  factory RequestStatusDataModel.fromJson(Map<String, dynamic> json) {
    return RequestStatusDataModel(
      requestId: json['request_id'] ?? 0,
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      nextActions: (json['next_actions'] as List<dynamic>?)
          ?.map((action) => action.toString())
          .toList() ?? [],
      proofUploaded: json['proof_uploaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'status': status,
      'updated_at': updatedAt,
      'next_actions': nextActions,
      'proof_uploaded': proofUploaded,
    };
  }

  RequestStatusDataEntity toEntity() {
    return RequestStatusDataEntity(
      requestId: requestId,
      status: status,
      updatedAt: updatedAt,
      nextActions: nextActions,
      proofUploaded: proofUploaded,
    );
  }
}
