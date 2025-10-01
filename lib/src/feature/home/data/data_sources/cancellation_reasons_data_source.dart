import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/cancellation_reason_model.dart';

class CancellationReasonsDataSource {
Future<List<CancellationReason>> fetchCancellationReasons() async {
    final response = await ApiClient.dio.get(ApiConstants.cancellationReason);

    if (response.statusCode == 200) {
      final data = response.data;
      final List<dynamic> reasonsJson = data['data']['reasons'];
      return reasonsJson
          .map((json) => CancellationReason.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else {
      throw Exception('Failed to fetch cancellation reasons: ${response.statusCode}');
    }
  }
}