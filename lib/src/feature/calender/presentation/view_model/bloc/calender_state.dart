import 'package:ai_transport/src/feature/calender/data/model/request_task_model.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<RequestModel> requests;

  const CalendarLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}








// import 'package:trasport_ai/src/feature/calender/domain/model/calender_model.dart';

// enum CalendarStatus { initial, loading, success, failure }

// class CalendarState  {
//   final CalendarStatus status;
//   final Map<DateTime, List<ServiceOrderModel>> ordersByDate;
//   final Map<String, List<ServiceOrderModel>> ordersByStatus;
//   final DateTime selectedDate;
//   final int currentTab;
//   final String? errorMessage;
//   final List<ServiceOrderModel> selectedDateOrders;

//   const CalendarState({
//     this.status = CalendarStatus.initial,
//     this.ordersByDate = const {},
//     this.ordersByStatus = const {},
//     required this.selectedDate,
//     this.currentTab = 0,
//     this.errorMessage,
//     this.selectedDateOrders = const [],
//   });

//   CalendarState copyWith({
//     CalendarStatus? status,
//     Map<DateTime, List<ServiceOrderModel>>? ordersByDate,
//     Map<String, List<ServiceOrderModel>>? ordersByStatus,
//     DateTime? selectedDate,
//     int? currentTab,
//     String? errorMessage,
//     List<ServiceOrderModel>? selectedDateOrders,
//   }) {
//     return CalendarState(
//       status: status ?? this.status,
//       ordersByDate: ordersByDate ?? this.ordersByDate,
//       ordersByStatus: ordersByStatus ?? this.ordersByStatus,
//       selectedDate: selectedDate ?? this.selectedDate,
//       currentTab: currentTab ?? this.currentTab,
//       errorMessage: errorMessage ?? this.errorMessage,
//       selectedDateOrders: selectedDateOrders ?? this.selectedDateOrders,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     status,
//     ordersByDate,
//     ordersByStatus,
//     selectedDate,
//     currentTab,
//     errorMessage,
//     selectedDateOrders,
//   ];
// }