import 'package:ai_transport/src/feature/home/domain/entities/request_status_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RequestStatusState extends Equatable {
  const RequestStatusState();

  @override
  List<Object?> get props => [];
}

class RequestStatusInitial extends RequestStatusState {}

class RequestStatusLoading extends RequestStatusState {}

class RequestStatusLoaded extends RequestStatusState {
  final List<RequestStatusEntity> requestStatuses;

  const RequestStatusLoaded({required this.requestStatuses});

  @override
  List<Object?> get props => [requestStatuses];
}

class RequestStatusError extends RequestStatusState {
  final String message;

  const RequestStatusError({required this.message});

  @override
  List<Object?> get props => [message];
}

class RequestAcceptedSuccess extends RequestStatusState {
  final RequestStatusEntity requestStatus;

  const RequestAcceptedSuccess({required this.requestStatus});

  @override
  List<Object?> get props => [requestStatus];
}

class RequestAcceptanceCancelledSuccess extends RequestStatusState {
  final RequestStatusEntity requestStatus;

  const RequestAcceptanceCancelledSuccess({required this.requestStatus});

  @override
  List<Object?> get props => [requestStatus];
}
