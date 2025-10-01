part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<VehicleEntity> vehicles;

  VehicleLoaded(this.vehicles);
}

class VehicleError extends VehicleState {
  final String message;

  VehicleError(this.message);
}
