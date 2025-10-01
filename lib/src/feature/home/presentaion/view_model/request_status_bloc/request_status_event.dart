import 'package:equatable/equatable.dart';

abstract class RequestStatusEvent extends Equatable {
  const RequestStatusEvent();

  @override
  List<Object?> get props => [];
}

class LoadRequestStatusesEvent extends RequestStatusEvent {}

class AcceptRequestEvent extends RequestStatusEvent {
  final int requestId;

  const AcceptRequestEvent({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class CancelAcceptanceEvent extends RequestStatusEvent {
  final int requestId;

  const CancelAcceptanceEvent({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class RefreshRequestStatusEvent extends RequestStatusEvent {}
