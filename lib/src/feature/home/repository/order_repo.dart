
import 'dart:developer';

import 'package:ai_transport/src/feature/home/data/data_sources/order_data_source.dart';
import 'package:ai_transport/src/feature/home/repository/mabber.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';

class OrderRepo {
  final OrderDataSource dataSource;

  OrderRepo({required this.dataSource});

  Future<List<RequestEntity>> getOrders(
    String vehicleType,
    bool urgentOnly,
    
  ) async {
    try {
      final result = await dataSource.fetchOrders(vehicleType, urgentOnly);
      return RequestMapper.mapList(result);
    } catch (e, st) {
      log(
        '[OrderRepo.getOrders] Error while fetching/mapping orders: $e',
        stackTrace: st,
      );
      return <RequestEntity>[];
    }
  }

  // Future<RequestEntity> getOrderById(String id) async {
  //   final model = await dataSource.fetchOrderById(id);
  //   return RequestMapper.mapRequest(model);
  // }

  Future<List<RequestEntity>> getMyRequests(String status) async {
    log('[OrderRepo.getMyRequests] Fetching my requests');
    try {
      final models = await dataSource.getMyRequests(status);
      final count = models.availableRequests.length;
      log(
        '[OrderRepo.getMyRequests] Received $count requests (totalCount=${models.totalCount})',
      );
      if (count == 0) {
        log('[OrderRepo.getMyRequests] myRequests is empty');
        return <RequestEntity>[];
      }
      // Map MyRequestModel -> RequestEntity
      return RequestMapper.mapList(models.availableRequests);
    } catch (e, st) {
      log(
        '[OrderRepo.getMyRequests] Error while fetching/mapping my requests: $e',
        stackTrace: st,
      );
      return <RequestEntity>[];
    }
  }

  Future<bool> acceptRequest(int id) async {
    try {
      final res = await dataSource.acceptRequest(id);
      return (res['status'] == 'success');
    } catch (e, st) {
      log('[OrderRepo.acceptRequest] Error: $e', stackTrace: st);
      return false;
    }
  }
}