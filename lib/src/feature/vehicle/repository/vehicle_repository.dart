import 'package:ai_transport/src/feature/home/data/data_sources/vehicle_data_source.dart';
import 'package:ai_transport/src/feature/home/domain/entities/vehicle_entity.dart';
import 'package:ai_transport/src/feature/home/data/models/vehicle_model.dart';

class VehicleRepository {
  final VehicleDataSource dataSource;

  VehicleRepository(this.dataSource);

  Future<VehicleEntity> registerVehicle(Map<String, dynamic> body) async {
    try {
      final VehicleModel model = await dataSource.registerVehicle(body);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  // Future<List<VehicleEntity>> getVehicles() async {
  //   try {
  //     final List<VehicleModel> models = await dataSource.getVehicles();
  //     return models.map((model) => model.toEntity()).toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
