import 'dart:developer';
import 'package:ai_transport/main.dart';
import 'package:ai_transport/src/core/database/cache/shared_pref_helper.dart';
import 'package:ai_transport/src/core/constants/app_colors.dart';
import 'package:ai_transport/src/feature/auth/data/models/staff_model.dart';
import 'package:ai_transport/src/feature/home/domain/entities/request_status_entity.dart';
import 'package:ai_transport/src/feature/home/presentaion/view/widgets/home_view_widgets/order_list_cards_info.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/request_status_bloc/request_status_state.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/tasks_bloc/tasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListCards extends StatelessWidget {
  // final Staff staff;
  const OrderListCards({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: FutureBuilder<bool?>(
        future: Future.value(
          SharedPrefHelper.getBool(StorageKeys.current_status),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'فشل في جلب الحالة',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final currentStatus = snapshot.data ?? false;
          if (!currentStatus) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 1),
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.person_off, color: Colors.orange, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'المستخدم غير نشط',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'يرجى تفعيل حالتك في صفحة البروفايل لاستقبال الطلبات',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // ✅ المستخدم نشط، عرض الطلبات
          return BlocListener<RequestStatusBloc, RequestStatusState>(
            listener: (context, state) {
              if (state is RequestAcceptedSuccess) {
                log("Request accepted, refreshing orders list");

                context.read<OrdersBloc>().add(
                  FetchOrders(vehicleType: "car", urgentOnly: true),
                );
                log("Request accepted, refreshing tasks list");
                context.read<TasksBloc>().add(
                  const GetMyRequests(status: 'accepted'),
                );
              }
            },
            child: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OrdersError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is OrdersLoaded) {
                  final orders = state.orders;
                  final String driverVehicleType = SharedPrefHelper.getString(
                    StorageKeys.vehicle_type,
                  );
                  final int staffId = SharedPrefHelper.getInt(
                    StorageKeys.driver_id,
                  );
                  log("Driver id: $staffId");
                  log("Driver vehicle type: $driverVehicleType");

                  // 🔹 تصفية الطلبات حسب vehicleType و staffId
                  final filteredOrders =
                      orders.where((order) {
                        final matchesVehicle =
                            driverVehicleType.isEmpty
                                ? true
                                : order.vehicleType == driverVehicleType;

                        // final driverNotInOrder = !order.driverIds.contains(staffId);

                        return matchesVehicle;
                      }).toList();

                  log(
                    "Driver vehicle type is empty: ${driverVehicleType.isEmpty}",
                  );
                  log(
                    "Filtered orders count: ${filteredOrders.length} out of ${orders.length}",
                  );

                  if (filteredOrders.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد طلبات متاحة حالياً',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final RequestStatusEntity? requestStatus =
                          RequestStatusEntity(
                            status: order.status, // String من order
                            isAcceptedByCurrentDriver: false, // قيمة افتراضية
                            canAccept: true,
                            requestId: order.id, // قيمة افتراضية
                          );
                      final staff = Staff(
                        id: staffId,
                        name: "", // أو null حسب الموديل
                        phone: "",
                        employeeType: '',
                        rating: '',
                        isOnline: false,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: screenWidth * 0.9,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.1),
                            color: AppColors.background.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OrderListCardsInfo(
                                order: order,
                                requestStatus: requestStatus,
                                staff: staff,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
