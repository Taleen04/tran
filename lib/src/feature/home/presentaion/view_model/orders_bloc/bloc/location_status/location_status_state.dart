part of 'location_status_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationStateInitial extends LocationState {}

final class LocationStateLoading extends LocationState {}

final class LocationStateSuccess extends LocationState {
  final LocationStatusEnum status;

  const LocationStateSuccess(this.status);
}

final class LocationStateError extends LocationState {
  final String message;

  const LocationStateError(this.message);
}

class LocationStateCleared extends LocationState {}
