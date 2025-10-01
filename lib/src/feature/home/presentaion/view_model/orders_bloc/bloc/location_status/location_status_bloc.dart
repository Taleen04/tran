import 'dart:developer';

import 'package:ai_transport/src/feature/home/domain/entities/location_status_entity.dart';
import 'package:ai_transport/src/feature/home/repository/location_status_repo.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_bloc.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/orders_bloc/bloc/orders_event.dart';
import 'package:ai_transport/src/feature/home/presentaion/view_model/tasks_bloc/tasks_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_status_event.dart';
part 'location_status_state.dart';

class LocationStatusBloc extends Bloc<LocationStatusEvent, LocationState> {
  final LocationStatusRepo repo;
  final OrdersBloc? ordersBloc; // إضافة مرجع لـ OrdersBloc
  final TasksBloc? tasksBloc; // إضافة مرجع لـ TasksBloc

  LocationStatusBloc({required this.repo, this.ordersBloc, this.tasksBloc})
    : super(LocationStateInitial()) {
    on<UpdateLocationStatusEvent>(_onUpdateLocationStatus);
     on<LoadLocationEvent>(_onClearLocationStatus);
      
    // optional
  }

  // Event handler for updating location status
  Future<void> _onUpdateLocationStatus(
    UpdateLocationStatusEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationStateLoading());

    try {
      await repo.getLocationStatus(event.status);
      emit(LocationStateSuccess(event.status));

      // تحديث الطلبات بعد تغيير حالة الموقع
      if (ordersBloc != null) {
        log("LocationStatusBloc: Updating orders after location change");
        ordersBloc!.add(FetchOrders(vehicleType: "car", urgentOnly: true));
      } else {
        log("LocationStatusBloc: OrdersBloc is null, cannot update orders");
      }

      // تحديث قائمة المهام بعد تغيير حالة الموقع
      if (tasksBloc != null) {
        log("LocationStatusBloc: Updating tasks after location change");
        tasksBloc!.add(const GetMyRequests(status: 'accepted'));
      } else {
        log("LocationStatusBloc: TasksBloc is null, cannot update tasks");
      }
    } catch (e) {
      emit(LocationStateError(e.toString()));
    }
    
  }
   Future<void> _onClearLocationStatus(
    LoadLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    log("LocationStatusBloc: clearing location state...");
    emit(LocationStateCleared());
  }
}

