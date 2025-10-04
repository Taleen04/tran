import 'package:ai_transport/src/feature/home/domain/entities/get_my_requset_entity.dart';
import 'package:ai_transport/src/feature/home/domain/entities/order_entity.dart';

class MyRequestsResponseModel {
  final List<MyRequestModel> availableRequests;
  final int totalCount;
  final int urgentCount;

  MyRequestsResponseModel({
    required this.availableRequests,
    required this.totalCount,
    required this.urgentCount,
  });

  factory MyRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final list =
        (data['available_requests'] as List?) ??
        (data['my_requests'] as List?) ??
        const [];
    return MyRequestsResponseModel(
      availableRequests:
          list
              .map((e) => MyRequestModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalCount: data['total_count'] ?? 0,
      urgentCount: data['urgent_count'] ?? 0,
    );
  }

  GetMyRequestsEntity toEntity() {
    return GetMyRequestsEntity(
      availableRequests: availableRequests.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      urgentCount: urgentCount,
    );
  }
}

class MyRequestModel {
  final int id;
  final String status;
  final ClientModel client;
  final String origin;
  final String destination;
  final Map<String, String> currentStatusTypes;
  final String vehicleType;
  final int passengers;
  final int bags;
  final String? notes;
  final String currentStatus;
  final int minutesRemaining;
  final List<int>? timeRemaining;
  final int priorityLevel;
  final DateTime? acceptanceDeadline;
  final bool needsVan;
  final bool needsAdditionalDriver;
  final DateTime? createdAt;
  final bool isUrgent;
  final bool isTimedOut;
  final bool acceptanceTimedOut;
  final int rejectionCount;
  final bool canAccept;
  final double? estimatedDistance;
  final double? estimatedDuration;
  final List<int> driverIds;
  final String previousDriverName;


  MyRequestModel({
    required this.id,
    required this.status,
    required this.client,
    required this.previousDriverName,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.passengers,
    required this.currentStatus,
    required this.bags,
    this.notes,
    required this.currentStatusTypes,
    required this.minutesRemaining,
    this.timeRemaining,
    required this.priorityLevel,
    this.acceptanceDeadline,
    required this.needsVan,
    required this.needsAdditionalDriver,
    this.createdAt,
    required this.isUrgent,
    required this.isTimedOut,
    required this.acceptanceTimedOut,
    required this.rejectionCount,
    required this.canAccept,
    this.estimatedDistance,
    this.estimatedDuration,
    required this.driverIds,
  });

  factory MyRequestModel.fromJson(Map<String, dynamic> json) {
    List<int> driverIds = [];
  if (json['driver'] != null) {
    driverIds.add((json['driver']['id'] as num).toInt());
  }
    // Parse time_remaining array [minutes, seconds] or null if not available
    List<int>? timeRemaining;
    if (json['time_remaining'] != null && json['time_remaining'] is List) {
      final timeList = json['time_remaining'] as List;
      if (timeList.length >= 2) {
        timeRemaining = [
          (timeList[0] as num).toInt(),
          (timeList[1] as num).toInt(),
        ];
      }
    }

    return MyRequestModel(
      id: json['id'] as int,
      previousDriverName: json['driver']['name']?? "",
      currentStatus: json['current_status'] ?? "",
      currentStatusTypes: Map<String, String>.from(json['current_status_types']),
      status: json['status'] as String,
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      vehicleType: json['vehicle_type'] as String,
      passengers: (json['passengers'] as num).toInt(),
      bags: (json['bags'] as num).toInt(),
      notes: json['notes'] as String?,
      priorityLevel: (json['priority_level'] as num?)?.toInt() ?? 0,
      minutesRemaining: (json['minutes_remaining'] as num?)?.toInt() ?? 0,
      timeRemaining: timeRemaining,
      acceptanceDeadline:
          json['acceptance_deadline'] != null
              ? DateTime.parse(json['acceptance_deadline'] as String)
              : null,
      needsVan: (json['needs_van'] as bool?) ?? false,
      needsAdditionalDriver:
          (json['needs_additional_driver'] as bool?) ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      isUrgent: (json['is_urgent'] as bool?) ?? false,
      isTimedOut: (json['is_timed_out'] as bool?) ?? false,
      acceptanceTimedOut: (json['acceptance_timed_out'] as bool?) ?? false,
      rejectionCount: (json['rejection_count'] as num?)?.toInt() ?? 0,
      canAccept: (json['can_accept'] as bool?) ?? false,
      estimatedDistance:
          json['estimated_distance'] != null
              ? double.tryParse(json['estimated_distance'].toString())
              : null,
      estimatedDuration:
          json['estimated_duration'] != null
              ? double.tryParse(json['estimated_duration'].toString())
              : null,
      driverIds: driverIds,
    );
  }

  RequestEntity toEntity() {
    return RequestEntity(
      id: id,
      previousDriverName: previousDriverName,
      currentStatus: currentStatus,
      currentStatusTypes: currentStatusTypes,
      status: status,
      client: client.toEntity(),
      origin: origin,
      destination: destination,
      vehicleType: vehicleType,
      passengers: passengers,
      bags: bags,
      notes: notes,
      minutesRemaining: minutesRemaining,
      timeRemaining: timeRemaining,
      priorityLevel: priorityLevel,
      acceptanceDeadline: acceptanceDeadline,
      needsVan: needsVan,
      needsAdditionalDriver: needsAdditionalDriver,
      createdAt: createdAt,
      isUrgent: isUrgent,
      isTimedOut: isTimedOut,
      acceptanceTimedOut: acceptanceTimedOut,
      rejectionCount: rejectionCount,
      canAccept: canAccept,
      estimatedDistance: estimatedDistance,
      estimatedDuration: estimatedDuration, 
       driverIds: driverIds,
    );
  }
}

class ClientModel {
  final String name;
  final String phone;

  ClientModel({required this.name, required this.phone});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(name: json['name'], phone: json['phone']);
  }

  ClientEntity toEntity() {
    return ClientEntity(name: name, phone: phone);
  }
}
