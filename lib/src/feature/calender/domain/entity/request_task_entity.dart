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
  final DateTime acceptedAt;
  final DateTime? startedAt;
  final DateTime? arrivedAt;
  final DateTime? pickedUpAt;
  final List<String> nextActions;
  final bool hasActiveChat;
  final bool requiresArrivalProof;
  final double? extraAmount;
  final bool isPrimary;

  RequestEntity({
    required this.id,
    required this.status,
    required this.client,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.passengers,
    required this.bags,
    this.notes,
    required this.acceptedAt,
    this.startedAt,
    this.arrivedAt,
    this.pickedUpAt,
    required this.nextActions,
    required this.hasActiveChat,
    required this.requiresArrivalProof,
    this.extraAmount,
    required this.isPrimary,
  });
}

class ClientEntity {
  final String name;
  final String phone;

  ClientEntity({
    required this.name,
    required this.phone,
  });
}
