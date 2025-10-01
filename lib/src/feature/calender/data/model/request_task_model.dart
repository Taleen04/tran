import 'package:ai_transport/src/feature/calender/domain/entity/request_task_entity.dart';

class RequestModel extends RequestEntity {
  RequestModel({
    required super.id,
    required super.status,
    required super.client,
    required super.origin,
    required super.destination,
    required super.vehicleType,
    required super.passengers,
    required super.bags,
    super.notes,
    required super.acceptedAt,
    super.startedAt,
    super.arrivedAt,
    super.pickedUpAt,
    required super.nextActions,
    required super.hasActiveChat,
    required super.requiresArrivalProof,
    super.extraAmount,
    required super.isPrimary,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      status: json['status'],
      client: ClientModel.fromJson(json['client']),
      origin: json['origin'],
      destination: json['destination'],
      vehicleType: json['vehicle_type'],
      passengers: json['passengers'],
      bags: json['bags'],
      notes: json['notes'],
      acceptedAt: DateTime.parse(json['accepted_at']),
      startedAt:
          json['started_at'] != null
              ? DateTime.tryParse(json['started_at'])
              : null,
      arrivedAt:
          json['arrived_at'] != null
              ? DateTime.tryParse(json['arrived_at'])
              : null,
      pickedUpAt:
          json['picked_up_at'] != null
              ? DateTime.tryParse(json['picked_up_at'])
              : null,
      nextActions: List<String>.from(json['next_actions']),
      hasActiveChat: json['has_active_chat'],
      requiresArrivalProof: json['requires_arrival_proof'],
      extraAmount:
          json['extra_amount'] != null
              ? (json['extra_amount'] as num).toDouble()
              : null,
      isPrimary: json['is_primary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "client": (client as ClientModel).toJson(),
      "origin": origin,
      "destination": destination,
      "vehicle_type": vehicleType,
      "passengers": passengers,
      "bags": bags,
      "notes": notes,
      "accepted_at": acceptedAt.toIso8601String(),
      "started_at": startedAt?.toIso8601String(),
      "arrived_at": arrivedAt?.toIso8601String(),
      "picked_up_at": pickedUpAt?.toIso8601String(),
      "next_actions": nextActions,
      "has_active_chat": hasActiveChat,
      "requires_arrival_proof": requiresArrivalProof,
      "extra_amount": extraAmount,
      "is_primary": isPrimary,
    };
  }
}

class ClientModel extends ClientEntity {
  ClientModel({required super.name, required super.phone});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "phone": phone};
  }
}
