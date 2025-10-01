import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';

class GetMyRequestsEntity {
  final List<RequestEntity> availableRequests;
  final int totalCount;
  final int urgentCount;

  GetMyRequestsEntity({
    required this.availableRequests,
    required this.totalCount,
    required this.urgentCount,
  });
}
