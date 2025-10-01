import 'package:ai_transport/src/feature/home/domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  VehicleModel({
    required super.id,
    required super.type,
    required super.plateNumber,
    required super.name,
    required super.color,
    required super.make,
    required super.model,
    required super.year,
    required super.capacityPassengers,
    required super.capacityBags,
    required super.wasExisting,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      type: json['type'] ?? json['vehicle_type'], // Handle both field names
      plateNumber: json['plate_number'],
      name: json['name'],
      color: json['color'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      capacityPassengers: json['capacity_passengers'],
      capacityBags: json['capacity_bags'],
      wasExisting: json['was_existing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'plate_number': plateNumber,
      'name': name,
      'color': color,
      'make': make,
      'model': model,
      'year': year,
      'capacity_passengers': capacityPassengers,
      'capacity_bags': capacityBags,
      'was_existing': wasExisting,
    };
  }


  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      type: type,
      plateNumber: plateNumber,
      name: name,
      color: color,
      make: make,
      model: model,
      year: year,
      capacityPassengers: capacityPassengers,
      capacityBags: capacityBags,
      wasExisting: wasExisting,
    );
  }
}
