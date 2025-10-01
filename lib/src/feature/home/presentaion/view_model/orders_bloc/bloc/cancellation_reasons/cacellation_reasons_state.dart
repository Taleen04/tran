import 'package:ai_transport/src/feature/home/domain/entities/cancellation_reason_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CancellationReasonsState extends Equatable {
  const CancellationReasonsState();

  @override
  List<Object?> get props => [];
}

class CancellationReasonsInitial extends CancellationReasonsState {}

class CancellationReasonsLoading extends CancellationReasonsState {}

class CancellationReasonsLoaded extends CancellationReasonsState {
  final List<CancellationReasonEntity> reasons;

  const CancellationReasonsLoaded(this.reasons);

  @override
  List<Object?> get props => [reasons];
}

class CancellationReasonsError extends CancellationReasonsState {
  final String message;

  const CancellationReasonsError(this.message);

  @override
  List<Object?> get props => [message];
}
