part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Map<String, dynamic> vehicleData;

  AddVehicle(this.vehicleData);
}
