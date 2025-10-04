import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/core/utils/snack_bar_helper.dart';
import 'package:ai_transport/src/feature/home/data/models/get_my_request_model.dart';
import 'package:ai_transport/src/feature/home/data/models/requset_model.dart';

class OrderDataSource {
  Future<List<MyRequestModel>> fetchOrders(String vehicleType, bool urgentOnly,) async {
    final queryParameters = {
      'vehicle_type': vehicleType,
      'urgent_only': urgentOnly,
      'date': DateTime.now().toIso8601String().split('T')[0]
    };

    final response = await ApiClient.dio.get(
      ApiConstants.ordersList,
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final data = response.data;

      if (data is Map && data['data'] is Map) {
        final innerData = data['data'] as Map;
        final availableRequests = innerData['available_requests'];

        if (availableRequests is List) {
          return availableRequests
              .map((item) => MyRequestModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        } else {
          return <MyRequestModel>[]; 
        }
      }

      throw Exception("Unexpected response format: ${data.runtimeType}");
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }


  Future<GetMyRequestsResponse> getMyRequests(String status) async {
    final queryParameters={'status':status};
    final response = await ApiClient.dio.get(ApiConstants.getMyRequests,queryParameters:queryParameters );
   
    if (response.statusCode == 200) {
      return GetMyRequestsResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch my requests: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> acceptRequest(int id,) async {
    final response = await ApiClient.dio.post(ApiConstants.acceptRequest(id));
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
     
      return data;
    } else {
      throw Exception('Failed to accept request $id: ${response.statusCode}');
    }
  }
}
  // Future<RequestModel> fetchOrderById(String id) async { //! edit
  //   final uri = Uri.parse('$baseUrl/orders/$id');
  //   final response = await httpClient.get(uri);
  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     final Map<String, dynamic> body = json.decode(response.body) as Map<String, dynamic>;
  //     // Some APIs return the object under data, others at root
  //     final Map<String, dynamic> data = (body['data'] ?? body) as Map<String, dynamic>;
  //     return RequestModel.fromJson(data);
  //   }
  //   throw Exception('Failed to fetch order $id: ${response.statusCode}');
  // }
