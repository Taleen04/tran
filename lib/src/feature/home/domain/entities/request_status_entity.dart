import 'package:equatable/equatable.dart';

class RequestStatusEntity extends Equatable {
  final int requestId;
  final String status; // 'available', 'accepted', 'completed', 'cancelled'
  final int? acceptedByDriverId;
  final String? acceptedByDriverName;
  final DateTime? acceptedAt;
  final bool isAcceptedByCurrentDriver;
  final bool canAccept;

  const RequestStatusEntity({
    required this.requestId,
    required this.status,
    this.acceptedByDriverId,
    this.acceptedByDriverName,
    this.acceptedAt,
    required this.isAcceptedByCurrentDriver,
    required this.canAccept,
  });

  @override
  List<Object?> get props => [
        requestId,
        status,
        acceptedByDriverId,
        acceptedByDriverName,
        acceptedAt,
        isAcceptedByCurrentDriver,
        canAccept,
      ];

  RequestStatusEntity copyWith({
    int? requestId,
    String? status,
    int? acceptedByDriverId,
    String? acceptedByDriverName,
    DateTime? acceptedAt,
    bool? isAcceptedByCurrentDriver,
    bool? canAccept,
  }) {
    return RequestStatusEntity(
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
      acceptedByDriverId: acceptedByDriverId ?? this.acceptedByDriverId,
      acceptedByDriverName: acceptedByDriverName ?? this.acceptedByDriverName,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      isAcceptedByCurrentDriver: isAcceptedByCurrentDriver ?? this.isAcceptedByCurrentDriver,
      canAccept: canAccept ?? this.canAccept,
    );
  }
}

// Enum for request status
enum RequestStatusType {
  available('available'),
  accepted('accepted'),
  completed('completed'),
  cancelled('cancelled');

  const RequestStatusType(this.value);
  final String value;

  static RequestStatusType fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return RequestStatusType.available;
      case 'accepted':
        return RequestStatusType.accepted;
      case 'completed':
        return RequestStatusType.completed;
      case 'cancelled':
        return RequestStatusType.cancelled;
      default:
        return RequestStatusType.available;
    }
  }
}
