import 'package:equatable/equatable.dart';

class RequestStatusUpdateEntity extends Equatable {
  final String status;
  final String message;
  final RequestStatusDataEntity data;

  const RequestStatusUpdateEntity({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class RequestStatusDataEntity extends Equatable {
  final int requestId;
  final String status;
  final String updatedAt;
  final List<String> nextActions;
  final bool proofUploaded;

  const RequestStatusDataEntity({
    required this.requestId,
    required this.status,
    required this.updatedAt,
    required this.nextActions,
    required this.proofUploaded,
  });

  @override
  List<Object?> get props => [requestId, status, updatedAt, nextActions, proofUploaded];
}

// Enum for request status values
enum RequestStatus {
  accepted('accepted'),
  arrived('arrived'),
  pickedUp('picked_up'),
  droppedOff('dropped_off'),
  completed('completed'),
  cancelled('cancelled');

  const RequestStatus(this.value);
  final String value;

  static RequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'arrived':
        return RequestStatus.arrived;
      case 'picked_up':
        return RequestStatus.pickedUp;
      case 'dropped_off':
        return RequestStatus.droppedOff;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }
}
