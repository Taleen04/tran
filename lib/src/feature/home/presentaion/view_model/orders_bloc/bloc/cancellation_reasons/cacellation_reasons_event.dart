
import 'package:equatable/equatable.dart';

sealed class CanellationReasonsEvent extends Equatable {
  const CanellationReasonsEvent();

  @override
  List<Object> get props => [];
}
class LoadCancellationReasons extends CanellationReasonsEvent {}