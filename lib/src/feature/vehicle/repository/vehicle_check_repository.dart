import 'package:ai_transport/src/feature/vehicle/data/data_sources/vehicle_check_data_source.dart';
import 'package:ai_transport/src/feature/vehicle/domain/entities/vehicle_check_entity.dart';

class VehicleCheckRepository {
  final VehicleCheckDataSource dataSource;

  VehicleCheckRepository(this.dataSource);

  Future<VehicleCheckEntity> checkVehiclePlate(String plateNumber) async {
    try {
      final model = await dataSource.checkVehiclePlate(plateNumber);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
