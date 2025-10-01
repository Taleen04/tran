import 'package:ai_transport/src/feature/home/data/models/requset_model.dart';

class GetMyRequestsResponse {
  final List<MyRequestModel> availableRequests;
  final int totalCount;
  final int urgentCount;

  GetMyRequestsResponse({
    required this.availableRequests,
    required this.totalCount,
    required this.urgentCount,
  });

  factory GetMyRequestsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final list = (data['available_requests'] as List?) ?? (data['my_requests'] as List?) ?? const [];
    return GetMyRequestsResponse(
      availableRequests: list
          .map((e) => MyRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: data['total_count'] ?? 0,
      urgentCount: data['urgent_count'] ?? 0,
    );
  }
}
