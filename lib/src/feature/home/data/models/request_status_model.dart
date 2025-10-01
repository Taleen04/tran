import 'package:ai_transport/src/feature/home/domain/entities/request_status_entity.dart';

class RequestStatusModel {
  final int requestId;
  final String status;
  final int? acceptedByDriverId;
  final String? acceptedByDriverName;
  final String? acceptedAt;
  final bool isAcceptedByCurrentDriver;
  final bool canAccept;

  const RequestStatusModel({
    required this.requestId,
    required this.status,
    this.acceptedByDriverId,
    this.acceptedByDriverName,
    this.acceptedAt,
    required this.isAcceptedByCurrentDriver,
    required this.canAccept,
  });

  factory RequestStatusModel.fromJson(Map<String, dynamic> json) {
    print('Parsing RequestStatusModel from: $json');
    
    return RequestStatusModel(
      requestId: json['request_id'] ?? json['id'] ?? 0,
      status: json['status'] ?? 'available',
      acceptedByDriverId: json['accepted_by_driver_id'] ?? json['driver_id'],
      acceptedByDriverName: json['accepted_by_driver_name'] ?? json['driver_name'],
      acceptedAt: json['accepted_at'] ?? json['created_at'],
      isAcceptedByCurrentDriver: json['is_accepted_by_current_driver'] ?? 
                                json['is_accepted'] ?? 
                                json['accepted'] ?? 
                                false,
      canAccept: json['can_accept'] ?? 
                 json['can_take'] ?? 
                 json['available'] ?? 
                 true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'status': status,
      'accepted_by_driver_id': acceptedByDriverId,
      'accepted_by_driver_name': acceptedByDriverName,
      'accepted_at': acceptedAt,
      'is_accepted_by_current_driver': isAcceptedByCurrentDriver,
      'can_accept': canAccept,
    };
  }

  RequestStatusEntity toEntity() {
    return RequestStatusEntity(
      requestId: requestId,
      status: status,
      acceptedByDriverId: acceptedByDriverId,
      acceptedByDriverName: acceptedByDriverName,
      acceptedAt: acceptedAt != null ? DateTime.tryParse(acceptedAt!) : null,
      isAcceptedByCurrentDriver: isAcceptedByCurrentDriver,
      canAccept: canAccept,
    );
  }
}
