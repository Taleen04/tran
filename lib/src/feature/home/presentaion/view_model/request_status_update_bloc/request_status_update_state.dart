import 'package:ai_transport/src/feature/home/domain/entities/request_status_update_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RequestStatusUpdateState extends Equatable {
  const RequestStatusUpdateState();

  @override
  List<Object?> get props => [];
}

class RequestStatusUpdateInitial extends RequestStatusUpdateState {}

class RequestStatusUpdateLoading extends RequestStatusUpdateState {}

class RequestStatusUpdateSuccess extends RequestStatusUpdateState {
  final RequestStatusUpdateEntity response;

  const RequestStatusUpdateSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class RequestStatusUpdateError extends RequestStatusUpdateState {
  final String message;

  const RequestStatusUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}
