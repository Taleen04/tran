part of 'location_status_bloc.dart';

sealed class LocationStatusEvent extends Equatable {
  const LocationStatusEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateLocationStatusEvent extends LocationStatusEvent {
  final LocationStatusEnum status;

  const UpdateLocationStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}
class LoadLocationEvent extends LocationStatusEvent {}

