import 'package:ai_transport/src/feature/home/domain/entities/request_status_update_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RequestStatusUpdateEvent extends Equatable {
  const RequestStatusUpdateEvent();

  @override
  List<Object?> get props => [];
}

class UpdateRequestStatusEvent extends RequestStatusUpdateEvent {
  final int requestId;
  final RequestStatus status;
  final String? currentLocation;
  final String? notes;

  const UpdateRequestStatusEvent({
    required this.requestId,
    required this.status,
    this.currentLocation,
    this.notes,
  });

  @override
  List<Object?> get props => [requestId, status, currentLocation, notes];
}
