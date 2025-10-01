import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ai_transport/src/feature/vehicle/domain/entities/vehicle_check_entity.dart';
import 'package:ai_transport/src/feature/vehicle/repository/vehicle_check_repository.dart';

part 'vehicle_check_event.dart';
part 'vehicle_check_state.dart';

class VehicleCheckBloc extends Bloc<VehicleCheckEvent, VehicleCheckState> {
  final VehicleCheckRepository repository;

  VehicleCheckBloc({required this.repository}) : super(VehicleCheckInitial()) {
    on<CheckVehiclePlate>(_onCheckVehiclePlate);
  }

  Future<void> _onCheckVehiclePlate(
    CheckVehiclePlate event,
    Emitter<VehicleCheckState> emit,
  ) async {
    emit(VehicleCheckLoading());
    try {
      final result = await repository.checkVehiclePlate(event.plateNumber);
      emit(VehicleCheckSuccess(result));
    } catch (e) {
      emit(VehicleCheckError(e.toString()));
    }
  }
}
