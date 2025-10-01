import 'dart:developer';

import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_event.dart';
import 'package:ai_transport/src/feature/home/repository/order_repo.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepo repo;

  OrdersBloc({required this.repo}) : super(OrdersInitial()) {
    on<FetchOrders>(_onLoadOrders);
    //on<LoadOrderByIdEvent>(_onLoadOrderById);
  }

  Future<void> _onLoadOrders(
    FetchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await repo.getOrders(event.vehicleType, event.urgentOnly);

      // تصفية الطلبات بناءً على حالة الموقع
      final filteredOrders = _filterOrdersByLocationStatus(orders);

      emit(OrdersLoaded(filteredOrders));
      log(
        'Orders loaded successfully: ${filteredOrders.length} items (filtered from ${orders.length})',
      );

      // إضافة معلومات إضافية للـ logging
      final currentLocationStatus = SharedPrefHelper.getString(
        StorageKeys.locationStaff,
      );
      log(
        'Location-based filtering applied for status: $currentLocationStatus',
      );
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  /// تصفية الطلبات بناءً على حالة الموقع الحالية للموظف
  List<RequestEntity> _filterOrdersByLocationStatus(
    List<RequestEntity> orders,
  ) {
    try {
      // الحصول على حالة الموقع الحالية من SharedPreferences
      final currentLocationStatus = SharedPrefHelper.getString(
        StorageKeys.locationStaff,
      );
      log("Current location status for orders: $currentLocationStatus");

      // التحقق من الحالات الأربع المحددة فقط
      if (!_isValidLocationStatus(currentLocationStatus)) {
        log(
          "Invalid or empty location status: $currentLocationStatus, showing all orders",
        );
        return orders;
      }

      // تصفية الطلبات بناءً على حالة الموقع
      final filteredOrders =
          orders.where((order) {
            return _isOrderLocationCompatible(order, currentLocationStatus);
          }).toList();

      log(
        "Filtered ${filteredOrders.length} orders out of ${orders.length} based on location status: $currentLocationStatus",
      );
      return filteredOrders;
    } catch (e) {
      log("Error filtering orders by location: $e");
      return orders; // في حالة الخطأ، اعرض جميع الطلبات
    }
  }

  /// التحقق من صحة حالة الموقع
  bool _isValidLocationStatus(String status) {
    const validStatuses = [
      'in_garage',
      'to_airport',
      'in_airport',
      'to_garage',
    ];
    return validStatuses.contains(status);
  }

  /// التحقق من توافق موقع الطلب مع حالة الموقع الحالية للموظف
  bool _isOrderLocationCompatible(
    RequestEntity order,
    String currentLocationStatus,
  ) {
    final origin = order.origin.toLowerCase();

    log(
      "Checking order compatibility - Order origin: '$origin', Location status: '$currentLocationStatus'",
    );

    // منطق التصفية بناءً على الحالات الأربع المحددة
    bool isCompatible = false;

    switch (currentLocationStatus) {
      case 'in_garage':
        // إذا كان الموظف في الكراج، يمكنه رؤية الطلبات التي تبدأ من الكراج فقط
        isCompatible = origin == 'garage' || origin.contains('garage') || origin.contains('كراج');
        log("in_garage check: origin='$origin' -> compatible: $isCompatible");
        break;

      case 'in_airport':
        // إذا كان الموظف في المطار، يمكنه رؤية الطلبات التي تبدأ من المطار فقط
        isCompatible = origin == 'airport' || origin.contains('airport') || origin.contains('مطار');
        log("in_airport check: origin='$origin' -> compatible: $isCompatible");
        break;

      case 'to_airport':
        // إذا كان الموظف في الطريق للمطار، يمكنه رؤية الطلبات من المطار فقط
        isCompatible = origin == 'airport' || origin.contains('airport') || origin.contains('مطار');
        log("to_airport check: origin='$origin' -> compatible: $isCompatible");
        break;

      case 'to_garage':
        // إذا كان الموظف في الطريق للكراج، يمكنه رؤية الطلبات من الكراج فقط
        isCompatible = origin == 'garage' || origin.contains('garage') || origin.contains('كراج');
        log("to_garage check: origin='$origin' -> compatible: $isCompatible");
        break;

      default:
        // في الحالات الأخرى، لا تعرض أي طلبات
        log(
          "Invalid location status: $currentLocationStatus, showing no orders",
        );
        return false;
    }

    log("Final order compatibility result: $isCompatible");
    return isCompatible;
  }

  // Future<void> _onLoadOrderById(LoadOrderByIdEvent event, Emitter<OrdersState> emit) async {
  //   emit(OrdersLoading());
  //   try {
  //     final order = await repo.getOrderById(event.id);
  //     emit(OrdersLoaded([order]));
  //   } catch (e) {
  //     emit(OrdersError(e.toString()));
  //   }
  // }
}
