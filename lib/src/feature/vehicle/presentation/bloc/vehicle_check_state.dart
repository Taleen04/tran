part of 'vehicle_check_bloc.dart';

abstract class VehicleCheckState extends Equatable {
  const VehicleCheckState();

  @override
  List<Object?> get props => [];
}

class VehicleCheckInitial extends VehicleCheckState {}

class VehicleCheckLoading extends VehicleCheckState {}

class VehicleCheckSuccess extends VehicleCheckState {
  final VehicleCheckEntity vehicleCheck;

  const VehicleCheckSuccess(this.vehicleCheck);

  @override
  List<Object> get props => [vehicleCheck];
}

class VehicleCheckError extends VehicleCheckState {
  final String message;

  const VehicleCheckError(this.message);

  @override
  List<Object> get props => [message];
}
