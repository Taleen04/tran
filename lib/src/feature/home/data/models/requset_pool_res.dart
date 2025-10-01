class RequestsPoolResponse {
  final int total;
  final int available;
  final int urgent;
  final List<Request> requests;

  RequestsPoolResponse({
    required this.total,
    required this.available,
    required this.urgent,
    required this.requests,
  });

  factory RequestsPoolResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return RequestsPoolResponse(
      total: data['total'],
      available: data['available'],
      urgent: data['urgent'],
      requests: (data['requests'] as List<dynamic>)
          .map((e) => Request.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': {
          'total': total,
          'available': available,
          'urgent': urgent,
          'requests': requests.map((e) => e.toJson()).toList(),
        },
      };
}

class Request {
  final int id;
  final int clientId;
  final Client client;
  final String vehicleType;
  final int passengerCount;
  final int bagCount;
  final String destination;
  final String status;
  final DateTime acceptanceDeadlineAt;
  final Vehicle? vehicle;
  final DateTime createdAt;
  final DateTime updatedAt;

  Request({
    required this.id,
    required this.clientId,
    required this.client,
    required this.vehicleType,
    required this.passengerCount,
    required this.bagCount,
    required this.destination,
    required this.status,
    required this.acceptanceDeadlineAt,
    this.vehicle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      clientId: json['client_id'],
      client: Client.fromJson(json['client']),
      vehicleType: json['vehicle_type'],
      passengerCount: json['passenger_count'],
      bagCount: json['bag_count'],
      destination: json['destination'],
      status: json['status'],
      acceptanceDeadlineAt: DateTime.parse(json['acceptance_deadline_at']),
      vehicle: json['assigned_driver'] != null &&
              json['assigned_driver']['vehicle'] != null
          ? Vehicle.fromJson(json['assigned_driver']['vehicle'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'client_id': clientId,
        'client': client.toJson(),
        'vehicle_type': vehicleType,
        'passenger_count': passengerCount,
        'bag_count': bagCount,
        'destination': destination,
        'status': status,
        'acceptance_deadline_at': acceptanceDeadlineAt.toIso8601String(),
        'assigned_driver':
            vehicle != null ? {'vehicle': vehicle!.toJson()} : null,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class Client {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String countryCode;
  final String phoneWithCountryCode;
  final Level level;
  final int stars;
  final int entersCount;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.countryCode,
    required this.phoneWithCountryCode,
    required this.level,
    required this.stars,
    required this.entersCount,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        countryCode: json['country_code'],
        phoneWithCountryCode: json['phone_with_country_code'],
        level: Level.fromJson(json['level']),
        stars: json['stars'],
        entersCount: json['enters_count'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'country_code': countryCode,
        'phone_with_country_code': phoneWithCountryCode,
        'level': level.toJson(),
        'stars': stars,
        'enters_count': entersCount,
      };
}

class Level {
  final int id;
  final String name;
  final int days;
  final String imageUrl;

  Level({
    required this.id,
    required this.name,
    required this.days,
    required this.imageUrl,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json['id'],
        name: json['name'],
        days: json['days'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'days': days,
        'image_url': imageUrl,
      };
}

class Vehicle {
  final int id;
  final String type;
  final String plateNumber;
  final String name;
  final String color;
  final int passengerCapacity;
  final int bagCapacity;
  final String status;

  Vehicle({
    required this.id,
    required this.type,
    required this.plateNumber,
    required this.name,
    required this.color,
    required this.passengerCapacity,
    required this.bagCapacity,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        type: json['type'],
        plateNumber: json['plate_number'],
        name: json['name'],
        color: json['color'],
        passengerCapacity: json['passenger_capacity'],
        bagCapacity: json['bag_capacity'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'plate_number': plateNumber,
        'name': name,
        'color': color,
        'passenger_capacity': passengerCapacity,
        'bag_capacity': bagCapacity,
        'status': status,
      };
}
