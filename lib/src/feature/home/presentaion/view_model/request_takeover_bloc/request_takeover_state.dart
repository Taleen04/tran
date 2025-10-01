import 'package:ai_transport/src/feature/home/domain/entities/request_takeover_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RequestTakeoverState extends Equatable {
  const RequestTakeoverState();

  @override
  List<Object?> get props => [];
}

class RequestTakeoverInitial extends RequestTakeoverState {}

class RequestTakeoverLoading extends RequestTakeoverState {}

class RequestTakeoverSuccess extends RequestTakeoverState {
  final RequestTakeoverEntity takeoverResponse;

  const RequestTakeoverSuccess({required this.takeoverResponse});

  @override
  List<Object?> get props => [takeoverResponse];
}

class RequestTakeoverError extends RequestTakeoverState {
  final String message;

  const RequestTakeoverError({required this.message});

  @override
  List<Object?> get props => [message];
}
