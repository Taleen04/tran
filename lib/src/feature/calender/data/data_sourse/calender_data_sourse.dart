import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/calender/data/model/request_task_model.dart';

class CalendarDataSource {
  Future<List<RequestModel>> fetchCalendar({
    required String status, // accepted, arrived, picked_up
  }) async {
    try {
      Map<String, dynamic> queryParams = {'status': status};

   

      final response = await ApiClient.dio.get(
        ApiConstants.History,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        print('Calendar API Response: ${response.data}');
        final data = _extractDataFromResponse(response.data);
        print('Extracted data count: ${data.length}');
        if (data.isNotEmpty) {
          final requests = _parseRequestsFromData(data);
          print('Parsed requests count: ${requests.length}');
          return requests;
        }
      }
    } catch (e) {
      print('Calendar API Error: $e');
    }

    return [];
  }

  // استخراج البيانات من الاستجابة
  List<dynamic> _extractDataFromResponse(dynamic responseData) {
    if (responseData is List) {
      return responseData;
    }

    if (responseData is Map<String, dynamic>) {
      final responseMap = responseData;

      // التعامل مع البنية الجديدة: {status: "success", data: {my_requests: [...]}}
      if (responseMap.containsKey('data') &&
          responseMap['data'] is Map<String, dynamic>) {
        final dataMap = responseMap['data'] as Map<String, dynamic>;
        if (dataMap.containsKey('my_requests') &&
            dataMap['my_requests'] is List) {
          return dataMap['my_requests'];
        }
      }

      // التعامل مع البنية المعقدة: {data: {data: [...], current_page: 1}}
      if (responseMap.containsKey('data') &&
          responseMap['data'] is Map<String, dynamic>) {
        final nestedData = responseMap['data'] as Map<String, dynamic>;
        if (nestedData.containsKey('data') && nestedData['data'] is List) {
          return nestedData['data'];
        }
      }

      // التعامل مع البنية البسيطة
      if (responseMap.containsKey('data') && responseMap['data'] is List) {
        return responseMap['data'];
      }

      if (responseMap.containsKey('tickets') &&
          responseMap['tickets'] is List) {
        return responseMap['tickets'];
      }

      if (responseMap.containsKey('vehicles') &&
          responseMap['vehicles'] is List) {
        return responseMap['vehicles'];
      }

      // إذا كان Map واحد، اعتباره طلب واحد
      return [responseMap];
    }

    return [];
  }

  // تحليل الطلبات من البيانات
  List<RequestModel> _parseRequestsFromData(List<dynamic> data) {
    return data
        .map((json) {
          try {
            return RequestModel.fromJson(json);
          } catch (e) {
            print('Error parsing request: $e');
            return null;
          }
        })
        .where((request) => request != null)
        .cast<RequestModel>()
        .toList();
  }
}
