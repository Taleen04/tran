// Entity for Client
class ClientEntity {
  final String name;
  final String phone;

  ClientEntity({required this.name, required this.phone});
}

// Entity for Request
class RequestEntity {
  final int id;
  final String status;
  final ClientEntity client;
  final String origin;
  final String destination;
  final String vehicleType;
  final int passengers;
  final int bags;
  final String? notes;
  final int minutesRemaining;
  final List<int>? timeRemaining;
  final int priorityLevel;
  final DateTime? acceptanceDeadline;
  final bool needsVan;
  final bool needsAdditionalDriver;
  final DateTime? createdAt;
  final bool isUrgent;
  final String currentStatus;
  final Map<String, String> currentStatusTypes; 
  final bool isTimedOut;
  final bool acceptanceTimedOut;
  final int rejectionCount;
  final bool canAccept;
  final double? estimatedDistance;
  final double? estimatedDuration;
  final List<int> driverIds;


  RequestEntity({
    required this.id,
    required this.status,
    required this.client,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.passengers,
    required this.currentStatus,
    required this.currentStatusTypes,
    required this.bags,
    this.notes,
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
}

// (Response entity moved to `get_my_requset_entity.dart`)
