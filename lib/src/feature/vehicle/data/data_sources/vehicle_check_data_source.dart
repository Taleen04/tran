import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/vehicle/data/models/vehicle_check_model.dart';

class VehicleCheckDataSource {
  Future<VehicleCheckModel> checkVehiclePlate(String plateNumber) async {
    try {
      final response = await ApiClient.dio.get(
        ApiConstants.checkVehiclePlate(plateNumber),
      );

      if (response.statusCode == 200) {
        return VehicleCheckModel.fromJson(response.data);
      } else {
        throw Exception('Failed to check vehicle plate: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking vehicle plate: $e');
    }
  }
}
