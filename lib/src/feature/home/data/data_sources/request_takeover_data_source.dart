import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/core/utils/snack_bar_helper.dart';
import 'package:ai_transport/src/feature/home/data/models/request_takeover_model.dart';
import 'package:dio/dio.dart';

class RequestTakeoverDataSource {
  // سحب طلب من سائق آخر
  Future<RequestTakeoverModel> takeoverRequest({
    required int requestId,
    required String reason,
    context
  }) async {
    final body = {'reason': reason};

    try {
      final response = await ApiClient.dio.post(
        ApiConstants.takeoverRequest(requestId),
        data: body,
      );

      if (response.statusCode == 200) {
        return RequestTakeoverModel.fromJson(response.data);
      } else {
        // حالة خاصة لمعالجة 400
        if (response.statusCode == 400) {
          final message = response.data['message'] ?? 'Unknown error';
          throw Exception('Cannot takeover request: $message');
        }
        throw Exception('Failed to takeover request: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // التعامل مع الأخطاء الخاصة بـ Dio
      if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'] ?? 'Unknown error';
        SnackbarUtils.showError(context, message);
        throw Exception('Cannot takeover request: $message');
        
        
      } else {
        throw Exception('Error taking over request: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}



// import 'package:ai_transport/src/core/database/api/apiclient.dart';
// import 'package:ai_transport/src/core/resources/api_constants.dart';
// import 'package:ai_transport/src/feature/home/data/models/request_takeover_model.dart';

// class RequestTakeoverDataSource {
//   // سحب طلب من سائق آخر
//   Future<RequestTakeoverModel> takeoverRequest({
//     required int requestId,
//     required String reason,
//   }) async {
//     final body = {
//       'reason': reason,
//     };

//     try {
//       final response = await ApiClient.dio.post(
//         ApiConstants.takeoverRequest(requestId),
//         data: body,
//       );

//       if (response.statusCode == 200) {
//         return RequestTakeoverModel.fromJson(response.data);
//       } else {
//         throw Exception('Failed to takeover request: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error taking over request: $e');
//     }
//   }
// }
