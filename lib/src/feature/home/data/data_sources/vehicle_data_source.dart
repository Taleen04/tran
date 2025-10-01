import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/vehicle_model.dart';

class VehicleDataSource {
  Future<VehicleModel> registerVehicle(Map<String, dynamic> body) async {
    try {
      final response = await ApiClient.dio.post(
        ApiConstants.vehicleRegister,
        data: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VehicleModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to register vehicle: ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await ApiClient.dio.get(
        ApiConstants.vehicles,
      );

      if (response.statusCode == 200) {
        final List<dynamic> vehiclesData = response.data['data'] ?? [];
        return vehiclesData
            .map((vehicle) => VehicleModel.fromJson(vehicle))
            .toList();
      } else {
        throw Exception('Failed to get vehicles: ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
