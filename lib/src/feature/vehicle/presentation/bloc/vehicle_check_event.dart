part of 'vehicle_check_bloc.dart';

abstract class VehicleCheckEvent extends Equatable {
  const VehicleCheckEvent();

  @override
  List<Object> get props => [];
}

class CheckVehiclePlate extends VehicleCheckEvent {
  final String plateNumber;

  const CheckVehiclePlate({required this.plateNumber});

  @override
  List<Object> get props => [plateNumber];
}
