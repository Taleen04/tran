import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrdersEvent {
  final String vehicleType;
  final bool urgentOnly;

  const FetchOrders({required this.vehicleType, this.urgentOnly = false});

  @override
  List<Object?> get props => [vehicleType, urgentOnly];
}
