import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/request_status_update_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_status_update_entity.dart';

class RequestStatusUpdateDataSource {
  Future<RequestStatusUpdateModel> updateRequestStatus({
    required int requestId,
    required RequestStatus status,
    String? currentLocation,
    String? notes,
  }) async {
    final body = {
      'status': status.value,
      if (currentLocation != null) 'current_location': currentLocation,
      if (notes != null) 'notes': notes,
    };

    try {
      final response = await ApiClient.dio.post(
        ApiConstants.updateRequestStatus(requestId),
        data: body,
      );

      if (response.statusCode == 200) {
        return RequestStatusUpdateModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update request status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating request status: $e');
    }
  }
}
