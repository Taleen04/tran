import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/home/data/models/request_status_model.dart';
import 'package:ai_transport/src/feature/home/utils/debug_helper.dart';

class RequestStatusDataSource {
  // الحصول على حالة الطلبات
  Future<List<RequestStatusModel>> getRequestStatuses() async {
    try {
      final response = await ApiClient.dio.get(ApiConstants.requestsStatus);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => RequestStatusModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch request statuses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching request statuses: $e');
    }
  }

  // قبول طلب
  Future<RequestStatusModel> acceptRequest(int requestId) async {
    try {
      final url = ApiConstants.acceptRequest(requestId);
      DebugHelper.logApiRequest('POST', url);
      
      final response = await ApiClient.dio.post(url);
      
      DebugHelper.logApiResponse(response.statusCode!, response.data);
      
      if (response.statusCode == 200) {
        // محاولة الوصول للبيانات بطرق مختلفة
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          // إذا كان هناك حقل 'data'
          if (data.containsKey('data')) {
            return RequestStatusModel.fromJson(data['data']);
          }
          // إذا كانت البيانات مباشرة في الاستجابة
          else {
            return RequestStatusModel.fromJson(data);
          }
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to accept request: ${response.statusCode}');
      }
    } catch (e) {
      DebugHelper.logApiError(e);
      throw Exception('Error accepting request: $e');
    }
  }

  // إلغاء قبول طلب
  Future<RequestStatusModel> cancelAcceptance(int requestId) async {
    try {
      final response = await ApiClient.dio.post(
        ApiConstants.cancelRequest(requestId),
      );
      
      if (response.statusCode == 200) {
        // تحقق من هيكل الاستجابة
        print('Cancel acceptance response: ${response.data}');
        
        // محاولة الوصول للبيانات بطرق مختلفة
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          
          // إذا كان هناك حقل 'data'
          if (data.containsKey('data')) {
            return RequestStatusModel.fromJson(data['data']);
          }
          // إذا كانت البيانات مباشرة في الاستجابة
          else {
            return RequestStatusModel.fromJson(data);
          }
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to cancel acceptance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error cancelling acceptance: $e');
    }
  }
}
