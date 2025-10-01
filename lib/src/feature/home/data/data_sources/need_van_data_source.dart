import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/need_van_request_model.dart';

class NeedVanDataSource {
  Future<NeedVanResponseModel> requestNeedVan({
    required int requestId,
    required NeedVanRequestModel needVanRequest,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiConstants.needVanRequest(requestId),
        data: needVanRequest.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        return NeedVanResponseModel.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = response.data;
        throw Exception(
          'Error: ${errorData['message'] ?? 'Unknown error occurred'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to request need van: $e');
    }
  }
}
