import 'package:ai_transport/src/feature/home/domain/entities/vehicle_entity.dart';
import 'package:ai_transport/src/feature/vehicle/repository/vehicle_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc(this.vehicleRepository) : super(VehicleInitial()) {
    //on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
  }

  // Future<void> _onLoadVehicles(
  //   LoadVehicles event,
  //   Emitter<VehicleState> emit,
  // ) async {
  //   emit(VehicleLoading());
  //   try {
  //     final vehicles = await vehicleRepository.getVehicles();
  //     emit(VehicleLoaded(vehicles));
  //   } catch (e) {
  //     emit(VehicleError(e.toString()));
  //   }
  // }

  Future<void> _onAddVehicle(
    AddVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());
    try {
      final vehicle = await vehicleRepository.registerVehicle(event.vehicleData);
      final currentState = state;
      if (currentState is VehicleLoaded) {
        emit(VehicleLoaded([...currentState.vehicles, vehicle]));
      } else {
        emit(VehicleLoaded([vehicle]));
      }
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }
}
